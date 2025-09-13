import 'package:flutter/material.dart';

/// 사용자 온라인 상태를 표시하는 위젯
/// 아바타 하단에 작은 원형 표시기로 상태를 보여줍니다
class UserStatusIndicator extends StatelessWidget {
  final String? status;
  final String? location;
  final double size;
  final double borderWidth;

  const UserStatusIndicator({
    super.key,
    required this.status,
    required this.location,
    this.size = 16,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getStatusColor(status, location),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: borderWidth),
      ),
    );
  }

  /// 상태와 위치에 따라 색상을 결정합니다
  Color _getStatusColor(String? status, String? location) {
    final isInWorld =
        location != null &&
        (location.startsWith('wrld_') || location == 'private');

    switch (status?.toLowerCase()) {
      case 'active':
        return isInWorld ? Colors.green : Colors.yellow[700]!;
      case 'join me':
        return isInWorld ? Colors.blue : Colors.yellow[700]!;
      case 'ask me':
        return isInWorld ? Colors.orange : Colors.yellow[700]!;
      case 'busy':
        return isInWorld ? Colors.red : Colors.yellow[700]!;
      case 'offline':
      default:
        return Colors.grey;
    }
  }
}

/// 아바타와 상태 표시기를 함께 보여주는 위젯
/// Stack으로 아바타 위에 상태 표시기를 포지셔닝합니다
class AvatarWithStatus extends StatelessWidget {
  final Widget avatar;
  final String? status;
  final String? location;
  final double? avatarRadius; // 아바타 반지름으로 상태 표시기 크기 자동 계산
  final double? statusSize; // 수동으로 상태 표시기 크기 지정 (우선순위)
  final double? statusBorderWidth; // 수동으로 테두리 두께 지정
  final bool showStatus;

  const AvatarWithStatus({
    super.key,
    required this.avatar,
    required this.status,
    required this.location,
    this.avatarRadius,
    this.statusSize,
    this.statusBorderWidth,
    this.showStatus = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!showStatus) {
      return avatar;
    }

    // 상태 표시기 크기 자동 계산 (아바타 반지름의 30-35% 정도)
    final calculatedStatusSize =
        statusSize ??
        (avatarRadius != null ? (avatarRadius! * 0.4).clamp(14.0, 35.0) : 16.0);

    // 테두리 두께 자동 계산 (상태 표시기 크기에 비례)
    final calculatedBorderWidth =
        statusBorderWidth ?? (calculatedStatusSize * 0.15).clamp(2.0, 5.0);

    // 디버그 출력
    print('🔍 AvatarWithStatus Debug:');
    print('   avatarRadius: $avatarRadius');
    print('   calculatedStatusSize: $calculatedStatusSize');
    print('   calculatedBorderWidth: $calculatedBorderWidth');

    return Stack(
      children: [
        avatar,
        Positioned(
          bottom: 0,
          right: 0,
          child: UserStatusIndicator(
            status: status,
            location: location,
            size: calculatedStatusSize,
            borderWidth: calculatedBorderWidth,
          ),
        ),
      ],
    );
  }
}
