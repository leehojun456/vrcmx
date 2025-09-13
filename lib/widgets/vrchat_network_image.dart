import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vrcmx/constants/app_info.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// 전역 이미지 캐시
class ImageCache {
  // 디스크 캐시 경로 생성
  static Future<String> _getCacheFilePath(String id) async {
    final dir = await getTemporaryDirectory();
    return '${dir.path}/friend_thumb_$id.jpg';
  }

  // 디스크에서 이미지 불러오기
  static Future<Uint8List?> getDisk(String id) async {
    final path = await _getCacheFilePath(id);
    final file = File(path);
    if (await file.exists()) {
      return await file.readAsBytes();
    }
    return null;
  }

  // 디스크에 이미지 저장
  static Future<void> setDisk(String id, Uint8List data) async {
    final path = await _getCacheFilePath(id);
    final file = File(path);
    await file.writeAsBytes(data, flush: true);
  }

  // id 기반 캐시: {id: {imageUrl, imageData}}
  static final Map<String, _CachedImage> _cache = {};

  static _CachedImage? get(String id) => _cache[id];
  static void set(String id, String imageUrl, Uint8List data) {
    _cache[id] = _CachedImage(imageUrl, data);
  }

  static bool contains(String id) => _cache.containsKey(id);
  static void clear() => _cache.clear();
}

class _CachedImage {
  final String imageUrl;
  final Uint8List imageData;
  _CachedImage(this.imageUrl, this.imageData);
}

class VRChatCircleAvatar extends StatelessWidget {
  final String id;
  final String? imageUrl;
  final double radius;
  final Widget? child;

  const VRChatCircleAvatar({
    super.key,
    required this.id,
    this.imageUrl,
    this.radius = 25,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return CircleAvatar(
        radius: radius,
        child: child ?? const Icon(Icons.person),
      );
    }

    final cached = ImageCache.get(id);
    if (cached != null && cached.imageUrl == imageUrl) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: MemoryImage(cached.imageData),
      );
    }

    // 디스크 캐시 우선 사용 (비동기)
    return FutureBuilder<Uint8List?>(
      future: _loadImageWithDiskCache(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircleAvatar(
            radius: radius,
            child: const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          return CircleAvatar(
            radius: radius,
            backgroundImage: MemoryImage(snapshot.data!),
          );
        } else {
          // 에러 발생 시 기본 NetworkImage로 폴백
          return CircleAvatar(
            radius: radius,
            backgroundImage: NetworkImage(imageUrl!),
            onBackgroundImageError: (exception, stackTrace) {
              print('이미지 로드 실패: $exception');
            },
            child: null,
          );
        }
      },
    );
  }

  Future<Uint8List?> _loadImageWithCustomHeaders() async {
    try {
      // 메모리 캐시 우선
      final cached = ImageCache.get(id);
      if (cached != null && cached.imageUrl == imageUrl) {
        return cached.imageData;
      }

      // 디스크 캐시 확인
      final diskImage = await ImageCache.getDisk(id);
      if (diskImage != null) {
        // 메모리 캐시에 없으면 디스크에서 불러와서 메모리에도 저장
        ImageCache.set(id, imageUrl!, diskImage);
        return diskImage;
      }

      // 네트워크에서 받아오기
      final response = await http
          .get(
            Uri.parse(imageUrl!),
            headers: {
              'User-Agent': AppInfo.userAgent,
              'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
              'Accept-Encoding': 'gzip, deflate, br',
              'Accept-Language': 'en-US,en;q=0.9',
              'Referer': 'https://vrchat.com/',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final imageData = response.bodyBytes;
        // 캐시에 저장
        ImageCache.set(id, imageUrl!, imageData);
        await ImageCache.setDisk(id, imageData);
        return imageData;
      } else {
        print('이미지 로드 실패: HTTP ${response.statusCode} for $imageUrl');
        return null;
      }
    } catch (e) {
      print('이미지 로드 에러: $e for $imageUrl');
      return null;
    }
  }

  // 디스크 캐시 우선 로딩
  Future<Uint8List?> _loadImageWithDiskCache() async {
    // 메모리 캐시 확인
    final cached = ImageCache.get(id);
    if (cached != null && cached.imageUrl == imageUrl) {
      return cached.imageData;
    }

    // 디스크 캐시 확인
    final diskImage = await ImageCache.getDisk(id);
    if (diskImage != null) {
      ImageCache.set(id, imageUrl!, diskImage);
      return diskImage;
    }

    // 네트워크에서 받아오기
    return await _loadImageWithCustomHeaders();
  }
}
