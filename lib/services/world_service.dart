import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/instance.dart';

class WorldService {
  final String baseUrl;
  final String authCookie;
  static const String _cachePrefix = 'instance_cache_';

  WorldService({required this.baseUrl, required this.authCookie});

  /// 인스턴스 정보를 가져옵니다
  /// location: "wrld_123:12345~nonce(usr_456)" 형태의 전체 위치 문자열
  Future<Instance?> getInstance(String location) async {
    try {
      if (!location.contains(':')) {
        print('Invalid instance location format: $location');
        return null;
      }

      // 월드ID:인스턴스ID만 추출 (~ 이후 제거)
      // wrld_123:12345~hidden(usr_456)~region(jp) -> wrld_123:12345
      final instanceId = _extractInstanceId(location);
      if (instanceId.isEmpty) {
        print('Failed to extract instance ID from: $location');
        return null;
      }

      // 먼저 캐시에서 확인
      final cachedInstance = await _getInstanceFromCache(instanceId, location);
      if (cachedInstance != null) {
        print('📦 Using cached instance data for: $instanceId');
        return cachedInstance;
      }

      final url = '$baseUrl/instances/$instanceId';
      print('🌐 API Call: GET $url');
      print('🔄 Original location: $location');
      print('🔄 Extracted instance ID: $instanceId');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Cookie': 'auth=$authCookie', 'User-Agent': 'VRCMX/1.0'},
      );

      print('📡 Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('✅ Instance data received');
        print('📋 Raw JSON data:');
        print(json.encode(data));
        print('---');

        // Instance 객체 생성시 원본 location 정보도 포함
        data['originalLocation'] = location;
        final instance = Instance.fromJson(data);

        // 캐시에 저장
        await _saveInstanceToCache(instanceId, data);
        print('💾 Instance data saved to cache: $instanceId');

        return instance;
      } else {
        print('❌ Failed to get instance: ${response.statusCode}');
        print('❌ Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error getting instance: $e');
      return null;
    }
  }

  /// location 문자열에서 실제 월드 ID만 추출합니다
  /// 예: "wrld_123:12345~nonce(usr_456)" -> "wrld_123"
  String _extractWorldId(String location) {
    if (location.startsWith('wrld_')) {
      // : 문자가 있으면 그 앞까지만 사용 (인스턴스 정보 제거)
      final colonIndex = location.indexOf(':');
      if (colonIndex != -1) {
        return location.substring(0, colonIndex);
      }
      return location;
    }
    return location;
  }

  /// location 문자열을 사용자 친화적인 텍스트로 변환합니다
  Future<String> getLocationDisplayText(String? location) async {
    if (location == null || location.isEmpty) {
      return 'Unknown';
    }

    // 특수 위치 처리
    if (location == 'offline') {
      return 'Offline';
    } else if (location == 'private') {
      return 'Private World';
    } else if (location.startsWith('wrld_')) {
      // 인스턴스 정보가 있는 경우 (wrld_xxx:instanceId)
      if (location.contains(':')) {
        // 인스턴스 정보만 가져오기 (월드 정보는 인스턴스 API에 포함됨)
        final instance = await getInstance(location);

        if (instance != null) {
          // 월드명 + 인스턴스 정보 (인스턴스 API의 world 필드 사용)
          return '${instance.worldName} (${instance.displayType} ${instance.occupancyText})';
        } else {
          // API 호출 실패시 간단한 표시
          final cleanId = _extractWorldId(location);
          return cleanId.replaceFirst('wrld_', 'World ');
        }
      } else {
        // 월드 정보만 있는 경우 - 인스턴스 API로만 처리
        final cleanId = _extractWorldId(location);
        return cleanId.replaceFirst('wrld_', 'World ');
      }
    }

    // 기타 위치는 그대로 표시
    return location;
  }

  /// location 문자열에서 월드ID:인스턴스ID만 추출합니다
  /// 예: "wrld_123:12345~hidden(usr_456)~region(jp)" -> "wrld_123:12345"
  String _extractInstanceId(String location) {
    if (location.isEmpty) return '';

    // ~ 문자가 있으면 그 앞까지만 사용
    final tildeIndex = location.indexOf('~');
    if (tildeIndex != -1) {
      return location.substring(0, tildeIndex);
    }

    // ~ 문자가 없으면 전체 문자열 사용
    return location;
  }

  /// 캐시에서 인스턴스 정보를 가져옵니다
  Future<Instance?> _getInstanceFromCache(
    String instanceId,
    String originalLocation,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_cachePrefix$instanceId';
      final cachedData = prefs.getString(cacheKey);

      if (cachedData != null) {
        final Map<String, dynamic> data = json.decode(cachedData);
        // 현재 요청의 originalLocation으로 업데이트
        data['originalLocation'] = originalLocation;
        return Instance.fromJson(data);
      }
    } catch (e) {
      print('Error reading instance cache: $e');
    }
    return null;
  }

  /// 캐시에 인스턴스 정보를 저장합니다
  Future<void> _saveInstanceToCache(
    String instanceId,
    Map<String, dynamic> data,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_cachePrefix$instanceId';
      await prefs.setString(cacheKey, json.encode(data));
    } catch (e) {
      print('Error saving instance cache: $e');
    }
  }

  /// 모든 인스턴스 캐시를 삭제합니다 (필요시 사용)
  Future<void> clearInstanceCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => key.startsWith(_cachePrefix));
      for (final key in keys) {
        await prefs.remove(key);
      }
      print('🗑️ All instance cache cleared');
    } catch (e) {
      print('Error clearing instance cache: $e');
    }
  }
}
