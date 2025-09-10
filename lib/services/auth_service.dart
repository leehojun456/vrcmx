import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart' as models;
import '../models/friend.dart';

class AuthService {
  static const String baseUrl = 'https://api.vrchat.cloud/api/1';
  static const String _cookieKey = 'vrchat_auth_cookie';
  String? _authCookie; // 인증 쿠키 저장
  
  AuthService();

  // 저장된 쿠키 로드
  Future<void> _loadSavedCookie() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _authCookie = prefs.getString(_cookieKey);
      print('🍪 저장된 쿠키 로드: $_authCookie');
    } catch (e) {
      print('🍪 쿠키 로드 실패: $e');
    }
  }

  // 쿠키 저장
  Future<void> _saveCookie(String cookie) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cookieKey, cookie);
      _authCookie = cookie;
      print('🍪 쿠키 저장 완료: $cookie');
    } catch (e) {
      print('🍪 쿠키 저장 실패: $e');
    }
  }

  // 쿠키 삭제
  Future<void> _clearCookie() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cookieKey);
      _authCookie = null;
      print('🍪 쿠키 삭제 완료');
    } catch (e) {
      print('🍪 쿠키 삭제 실패: $e');
    }
  }

  // Basic Auth 헤더 생성
  String _createBasicAuth(String username, String password) {
    final credentials = '$username:$password';
    final encoded = base64Encode(utf8.encode(credentials));
    return 'Basic $encoded';
  }

  // Set-Cookie 헤더에서 auth 쿠키 추출
  String? _extractAuthCookie(String setCookieHeader) {
    print('🍪 Set-Cookie 헤더: $setCookieHeader'); // 디버그 로그
    
    // Set-Cookie 헤더는 여러 쿠키가 있을 때 여러 줄로 올 수 있음
    final cookies = setCookieHeader.split('\n');
    
    for (final cookieLine in cookies) {
      final trimmed = cookieLine.trim();
      print('🍪 쿠키 라인: $trimmed'); // 디버그 로그
      
      if (trimmed.startsWith('auth=')) {
        // auth=value; 형태에서 value만 추출
        final parts = trimmed.split(';');
        final authPart = parts[0]; // auth=value 부분
        final cookieValue = authPart.substring(5); // 'auth=' 제거
        print('🍪 추출된 쿠키: $cookieValue'); // 디버그 로그
        return cookieValue;
      }
      
      // 쉼표로 구분된 경우도 확인
      if (trimmed.contains('auth=')) {
        final commaSplit = trimmed.split(',');
        for (final part in commaSplit) {
          if (part.trim().startsWith('auth=')) {
            final authPart = part.trim().split(';')[0];
            final cookieValue = authPart.substring(5);
            print('🍪 쉼표 구분에서 추출된 쿠키: $cookieValue');
            return cookieValue;
          }
        }
      }
    }
    
    print('🍪 auth 쿠키를 찾을 수 없음');
    return null;
  }

  Future<models.LoginResponse> login(models.LoginRequest request) async {
    try {
      if (request.username.isEmpty || request.password.isEmpty) {
        return const models.LoginResponse(
          success: false,
          message: 'Username and password are required',
        );
      }

      // VRChat API 호출
      final response = await http.get(
        Uri.parse('$baseUrl/auth/user'),
        headers: {
          'Authorization': _createBasicAuth(request.username, request.password),
          'User-Agent': 'VRCMX/1.0.0',
        },
      ).timeout(const Duration(seconds: 10));

      final responseData = jsonDecode(response.body);
      
      // 모든 응답 헤더 디버그 출력
      print('📨 응답 상태: ${response.statusCode}');
      print('📨 응답 헤더: ${response.headers}');
      print('📨 응답 본문: ${response.body}');
      
      if (response.statusCode == 200) {
        // 2FA가 필요한지 확인
        if (responseData.containsKey('requiresTwoFactorAuth') && 
            responseData['requiresTwoFactorAuth'] is List &&
            (responseData['requiresTwoFactorAuth'] as List).isNotEmpty) {
          
          print('🔐 2FA 필요함. 쿠키 추출 시도...');
          
          // 쿠키 저장 - 여러 가능한 헤더 키 시도
          String? cookies;
          cookies = response.headers['set-cookie'] ?? 
                   response.headers['Set-Cookie'] ??
                   response.headers['SET-COOKIE'];
          
          if (cookies != null) {
            print('🍪 쿠키 헤더 발견: $cookies');
            _authCookie = _extractAuthCookie(cookies);
          } else {
            print('🍪 Set-Cookie 헤더가 없음');
            // 모든 헤더에서 쿠키 찾기
            for (final entry in response.headers.entries) {
              if (entry.key.toLowerCase().contains('cookie')) {
                print('🍪 쿠키 관련 헤더 발견: ${entry.key} = ${entry.value}');
                _authCookie = _extractAuthCookie(entry.value);
                if (_authCookie != null) break;
              }
            }
          }
          
          print('🔑 저장된 인증 쿠키: $_authCookie');
          
          // 쿠키 저장
          if (_authCookie != null) {
            await _saveCookie(_authCookie!);
          }
          
          final twoFactorMethods = List<String>.from(responseData['requiresTwoFactorAuth']);
          
          return models.LoginResponse(
            success: false,
            message: '2FA_REQUIRED',
            requires2FA: true,
            twoFactorMethods: twoFactorMethods,
            rawApiResponse: responseData,
          );
        }
        
        // 일반 로그인 성공
        final user = models.User(
          id: responseData['id'] ?? '',
          username: responseData['username'] ?? responseData['displayName'] ?? '',
          displayName: responseData['displayName'] ?? '',
          email: responseData['email'],
          avatarImageUrl: responseData['currentAvatarImageUrl'],
          isLoggedIn: true,
          bio: responseData['bio'],
          status: responseData['status'],
          statusDescription: responseData['statusDescription'],
          developerType: responseData['developerType'],
          lastLogin: responseData['last_login'] != null 
            ? DateTime.tryParse(responseData['last_login']) 
            : null,
          platform: responseData['last_platform'],
          rawApiResponse: responseData,
        );
        
        return models.LoginResponse(
          success: true,
          message: 'Login successful',
          user: user,
          token: 'vrchat_session',
        );

      } else if (response.statusCode == 401) {
        return const models.LoginResponse(
          success: false,
          message: 'Invalid username or password',
        );
      } else if (response.statusCode == 429) {
        return const models.LoginResponse(
          success: false,
          message: 'Too many login attempts. Please wait before trying again.',
        );
      } else {
        return models.LoginResponse(
          success: false,
          message: 'Login failed with status: ${response.statusCode}',
        );
      }

    } on SocketException {
      return const models.LoginResponse(
        success: false,
        message: 'Network error. Please check your internet connection.',
      );
    } on http.ClientException {
      return const models.LoginResponse(
        success: false,
        message: 'Connection failed. Please try again.',
      );
    } on FormatException {
      return const models.LoginResponse(
        success: false,
        message: 'Invalid response from server.',
      );
    } catch (e) {
      return models.LoginResponse(
        success: false,
        message: 'Login failed: ${e.toString()}',
      );
    }
  }

  Future<models.LoginResponse> verify2FA(String code, String method) async {
    try {
      print('🔐 2FA 검증 시작 - 쿠키 상태: $_authCookie');
      
      if (_authCookie == null || _authCookie!.isEmpty) {
        print('❌ 인증 쿠키가 없거나 비어있음');
        return const models.LoginResponse(
          success: false,
          message: '인증 쿠키가 없습니다. 다시 로그인해주세요.',
        );
      }

      late http.Response response;
      late String endpoint;
      
      // VRChat API 방식에 따라 엔드포인트 결정
      switch (method.toLowerCase()) {
        case 'totp':
        case 'authenticator':
          endpoint = '$baseUrl/auth/twofactorauth/totp/verify';
          break;
        case 'otp':
        case 'emailotp':
        case 'email':
          endpoint = '$baseUrl/auth/twofactorauth/emailotp/verify';
          break;
        default:
          return models.LoginResponse(
            success: false,
            message: 'Unsupported 2FA method: $method',
          );
      }

      // 쿠키 기반 2FA 요청
      final headers = {
        'Content-Type': 'application/json',
        'User-Agent': 'VRCMX/1.0.0',
        'Cookie': 'auth=$_authCookie',
      };
      final body = jsonEncode({'code': code});
      
      print('🚀 2FA 요청 전송');
      print('🌐 엔드포인트: $endpoint');
      print('📤 헤더: $headers');
      print('📤 바디: $body');
      
      response = await http.post(
        Uri.parse(endpoint),
        headers: headers,
        body: body,
      ).timeout(const Duration(seconds: 10));
      
      print('📨 2FA 응답 상태: ${response.statusCode}');
      print('📨 2FA 응답 헤더: ${response.headers}');
      print('📨 2FA 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        
        final user = models.User(
          id: userData['id'] ?? '',
          username: userData['username'] ?? userData['displayName'] ?? '',
          displayName: userData['displayName'] ?? '',
          email: userData['email'],
          avatarImageUrl: userData['currentAvatarImageUrl'],
          isLoggedIn: true,
          bio: userData['bio'],
          status: userData['status'],
          statusDescription: userData['statusDescription'],
          developerType: userData['developerType'],
          lastLogin: userData['last_login'] != null 
            ? DateTime.tryParse(userData['last_login']) 
            : null,
          platform: userData['last_platform'],
          rawApiResponse: userData,
        );
        
        // 2FA 성공 후 쿠키 저장
        if (_authCookie != null) {
          await _saveCookie(_authCookie!);
        }
        
        return models.LoginResponse(
          success: true,
          message: '2FA verification successful',
          user: user,
          token: 'vrchat_session_2fa',
        );
      } else if (response.statusCode == 401) {
        return const models.LoginResponse(
          success: false,
          message: 'Invalid 2FA code',
        );
      } else {
        final errorData = jsonDecode(response.body);
        return models.LoginResponse(
          success: false,
          message: '2FA verification failed: ${errorData['error']?['message'] ?? 'Unknown error'}',
        );
      }

    } on SocketException {
      return const models.LoginResponse(
        success: false,
        message: 'Network error during 2FA verification.',
      );
    } catch (e) {
      return models.LoginResponse(
        success: false,
        message: '2FA verification failed: ${e.toString()}',
      );
    }
  }

  Future<void> logout() async {
    try {
      if (_authCookie != null) {
        await http.put(
          Uri.parse('$baseUrl/logout'),
          headers: {
            'User-Agent': 'VRCMX/1.0.0',
            'Cookie': 'auth=$_authCookie',
          },
        ).timeout(const Duration(seconds: 5));
      }
    } catch (e) {
      print('Logout error: $e');
    } finally {
      // 로컬 쿠키 삭제
      await _clearCookie();
    }
  }

  Future<bool> checkAuthStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/user'),
        headers: {
          'User-Agent': 'VRCMX/1.0.0',
        },
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // 저장된 세션으로 자동 로그인 시도
  Future<models.LoginResponse> tryAutoLogin() async {
    try {
      // 먼저 저장된 쿠키를 로드
      await _loadSavedCookie();
      
      print('🔄 자동 로그인 시도 - 쿠키 상태: $_authCookie');
      
      if (_authCookie == null || _authCookie!.isEmpty) {
        return const models.LoginResponse(
          success: false,
          message: '저장된 세션이 없습니다.',
        );
      }

      final response = await http.get(
        Uri.parse('$baseUrl/auth/user'),
        headers: {
          'User-Agent': 'VRCMX/1.0.0',
          'Cookie': 'auth=$_authCookie',
        },
      ).timeout(const Duration(seconds: 10));

      print('📨 자동 로그인 응답 상태: ${response.statusCode}');
      print('📨 자동 로그인 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        
        final user = models.User(
          id: userData['id'] ?? '',
          username: userData['username'] ?? userData['displayName'] ?? '',
          displayName: userData['displayName'] ?? '',
          email: userData['email'],
          avatarImageUrl: userData['currentAvatarImageUrl'],
          isLoggedIn: true,
          bio: userData['bio'],
          status: userData['status'],
          statusDescription: userData['statusDescription'],
          developerType: userData['developerType'],
          lastLogin: userData['last_login'] != null 
            ? DateTime.tryParse(userData['last_login']) 
            : null,
          platform: userData['last_platform'],
          rawApiResponse: userData,
        );

        print('✅ 자동 로그인 성공: ${user.displayName}');
        
        return models.LoginResponse(
          success: true,
          message: 'Auto-login successful',
          user: user,
          token: 'vrchat_session_auto',
        );

      } else if (response.statusCode == 401) {
        print('❌ 세션 만료됨, 쿠키 삭제');
        await _clearCookie();
        return const models.LoginResponse(
          success: false,
          message: '세션이 만료되었습니다. 다시 로그인해주세요.',
        );
      } else {
        return models.LoginResponse(
          success: false,
          message: 'Auto-login failed with status: ${response.statusCode}',
        );
      }

    } on SocketException {
      return const models.LoginResponse(
        success: false,
        message: 'Network error during auto-login.',
      );
    } catch (e) {
      print('❌ 자동 로그인 오류: $e');
      return models.LoginResponse(
        success: false,
        message: 'Auto-login failed: ${e.toString()}',
      );
    }
  }

  Future<FriendsListResponse> getFriends({
    int offset = 0,
    int limit = 60,
    bool includeOffline = true,
  }) async {
    try {
      print('👥 친구목록 요청 시작 - 쿠키 상태: $_authCookie');
      
      if (_authCookie == null || _authCookie!.isEmpty) {
        return const FriendsListResponse(
          success: false,
          message: '인증 쿠키가 필요합니다. 로그인 후 시도해주세요.',
        );
      }

      // VRChat Friends API 엔드포인트: GET /auth/user/friends
      final uri = Uri.parse('$baseUrl/auth/user/friends').replace(
        queryParameters: {
          'offset': offset.toString(),
          'n': limit.toString(),
          'offline': includeOffline.toString(),
        },
      );

      final headers = {
        'User-Agent': 'VRCMX/1.0.0',
        'Cookie': 'auth=$_authCookie',
      };

      print('🚀 친구목록 요청 전송');
      print('🌐 엔드포인트: $uri');
      print('📤 헤더: $headers');

      final response = await http.get(uri, headers: headers)
          .timeout(const Duration(seconds: 10));

      print('📨 친구목록 응답 상태: ${response.statusCode}');
      print('📨 친구목록 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> friendsData = jsonDecode(response.body);
        
        final friends = friendsData.map<Friend>((friendJson) {
          return Friend(
            id: friendJson['id'] ?? '',
            username: friendJson['username'] ?? friendJson['displayName'] ?? '',
            displayName: friendJson['displayName'] ?? '',
            bio: friendJson['bio'],
            currentAvatarImageUrl: friendJson['currentAvatarImageUrl'],
            status: friendJson['status'],
            statusDescription: friendJson['statusDescription'],
            location: friendJson['location'],
            instanceId: friendJson['instanceId'],
            worldId: friendJson['worldId'],
            lastLogin: friendJson['last_login'] != null 
                ? DateTime.tryParse(friendJson['last_login'])
                : null,
            platform: friendJson['last_platform'],
            isOnline: friendJson['location'] != 'offline',
            developerType: friendJson['developerType'],
            tags: friendJson['tags'] != null 
                ? List<String>.from(friendJson['tags'])
                : null,
            friendKey: friendJson['friendKey'],
            rawApiResponse: friendJson,
          );
        }).toList();

        print('👥 친구목록 가져오기 성공: ${friends.length}명');

        return FriendsListResponse(
          success: true,
          message: '친구목록을 성공적으로 가져왔습니다.',
          friends: friends,
          total: friends.length,
          rawApiResponse: {'friends': friendsData},
        );

      } else if (response.statusCode == 401) {
        return const FriendsListResponse(
          success: false,
          message: '인증이 만료되었습니다. 다시 로그인해주세요.',
        );
      } else {
        final errorData = jsonDecode(response.body);
        return FriendsListResponse(
          success: false,
          message: '친구목록 가져오기 실패: ${errorData['error']?['message'] ?? 'Unknown error'}',
        );
      }

    } on SocketException {
      return const FriendsListResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다.',
      );
    } catch (e) {
      print('❌ 친구목록 가져오기 오류: $e');
      return FriendsListResponse(
        success: false,
        message: '친구목록 가져오기 실패: ${e.toString()}',
      );
    }
  }
}