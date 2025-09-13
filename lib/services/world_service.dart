import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/instance.dart';

class WorldService {
  final String baseUrl;
  final String authCookie;

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
        return Instance.fromJson(data);
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
}
