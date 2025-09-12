import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vrcmx/constants/app_info.dart';

// 전역 이미지 캐시
class ImageCache {
  static final Map<String, Uint8List> _cache = {};
  
  static Uint8List? get(String url) => _cache[url];
  static void set(String url, Uint8List data) => _cache[url] = data;
  static bool contains(String url) => _cache.containsKey(url);
  static void clear() => _cache.clear();
}

class VRChatCircleAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final Widget? child;

  const VRChatCircleAvatar({
    Key? key,
    this.imageUrl,
    this.radius = 25,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return CircleAvatar(
        radius: radius,
        child: child ?? const Icon(Icons.person),
      );
    }

    // 캐시에 이미 있으면 바로 표시
    final cachedImage = ImageCache.get(imageUrl!);
    if (cachedImage != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: MemoryImage(cachedImage),
      );
    }

    return FutureBuilder<Uint8List?>(
      future: _loadImageWithCustomHeaders(),
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
      // 캐시에서 먼저 확인
      final cachedImage = ImageCache.get(imageUrl!);
      if (cachedImage != null) {
        return cachedImage;
      }

      final response = await http.get(
        Uri.parse(imageUrl!),
        headers: {
          'User-Agent': AppInfo.userAgent,
          'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
          'Accept-Encoding': 'gzip, deflate, br',
          'Accept-Language': 'en-US,en;q=0.9',
          'Referer': 'https://vrchat.com/',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final imageData = response.bodyBytes;
        // 캐시에 저장
        ImageCache.set(imageUrl!, imageData);
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
}
