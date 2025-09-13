class Instance {
  final String id;
  final String instanceId;
  final String worldId;
  final String name;
  final String? displayName;
  final String? shortName;
  final String? secureName;
  final bool active;
  final bool full;
  final bool permanent;
  final int capacity;
  final int nUsers;
  final String type;
  final String ownerId;
  final String region;
  final String photonRegion;
  final List<String> tags;
  final bool canRequestInvite;
  final String? location;
  final Map<String, dynamic>? platforms;
  final Map<String, dynamic>? world;
  final List<dynamic>? users;
  final String? originalLocation; // 원본 location 정보 (URL 메타데이터 포함)

  Instance({
    required this.id,
    required this.instanceId,
    required this.worldId,
    required this.name,
    this.displayName,
    this.shortName,
    this.secureName,
    required this.active,
    required this.full,
    required this.permanent,
    required this.capacity,
    required this.nUsers,
    required this.type,
    required this.ownerId,
    required this.region,
    required this.photonRegion,
    required this.tags,
    required this.canRequestInvite,
    this.location,
    this.platforms,
    this.world,
    this.users,
    this.originalLocation,
  });

  factory Instance.fromJson(Map<String, dynamic> json) {
    return Instance(
      id: json['id'] ?? '',
      instanceId: json['instanceId'] ?? '',
      worldId: json['worldId'] ?? '',
      name: json['name'] ?? '',
      displayName: json['displayName'],
      shortName: json['shortName'],
      secureName: json['secureName'],
      active: json['active'] ?? true,
      full: json['full'] ?? false,
      permanent: json['permanent'] ?? false,
      capacity: json['capacity'] ?? 0,
      nUsers: json['n_users'] ?? 0,
      type: json['type'] ?? '',
      ownerId: json['ownerId'] ?? '',
      region: json['region'] ?? '',
      photonRegion: json['photonRegion'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      canRequestInvite: json['canRequestInvite'] ?? true,
      location: json['location'],
      platforms: json['platforms'],
      world: json['world'],
      users: json['users'],
      originalLocation: json['originalLocation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'instanceId': instanceId,
      'worldId': worldId,
      'name': name,
      'displayName': displayName,
      'shortName': shortName,
      'secureName': secureName,
      'active': active,
      'full': full,
      'permanent': permanent,
      'capacity': capacity,
      'n_users': nUsers,
      'type': type,
      'ownerId': ownerId,
      'region': region,
      'photonRegion': photonRegion,
      'tags': tags,
      'canRequestInvite': canRequestInvite,
      'location': location,
      'platforms': platforms,
      'world': world,
      'users': users,
      'originalLocation': originalLocation,
    };
  }

  /// 인스턴스 타입을 사용자 친화적인 텍스트로 변환
  /// originalLocation 정보를 우선적으로 사용하여 실제 인스턴스 타입을 판단
  String get displayType {
    // originalLocation 정보가 있으면 URL 메타데이터를 기반으로 타입 판단
    final locationToCheck = originalLocation ?? location;
    if (locationToCheck != null && locationToCheck.isNotEmpty) {
      if (locationToCheck.contains('~hidden(')) {
        return 'Friends+';
      } else if (locationToCheck.contains('~friends(')) {
        return 'Friends';
      } else if (locationToCheck.contains('~private(')) {
        return 'Invite Only';
      } else if (locationToCheck.contains('~group(')) {
        return 'Group';
      }
      // 메타데이터가 없으면 Public으로 간주
      return 'Public';
    }

    // location 정보가 없으면 기존 type 필드 사용
    switch (type.toLowerCase()) {
      case 'public':
        return 'Public';
      case 'hidden':
        return 'Friends+';
      case 'friends':
        return 'Friends';
      case 'private':
        return 'Invite Only';
      case 'group':
        return 'Group';
      default:
        // 알 수 없는 타입은 원본 값을 그대로 표시
        return type.isNotEmpty ? type : 'Unknown';
    }
  }

  /// 인스턴스 상태 텍스트 (인원수/정원)
  String get occupancyText {
    return '$nUsers/$capacity';
  }

  /// 인스턴스가 가득 찼는지 여부
  bool get isFull {
    return nUsers >= capacity;
  }

  /// 월드 이름 (world 필드가 있으면 사용, 없으면 name 사용)
  String get worldName {
    if (world != null && world!['name'] != null) {
      return world!['name'];
    }
    return name;
  }

  /// 친구 수 계산 (users 배열에서 isFriend가 true인 사용자 수)
  int get friendCount {
    if (users == null) return 0;

    int count = 0;
    for (var user in users!) {
      if (user is Map<String, dynamic> && user['isFriend'] == true) {
        count++;
      }
    }
    return count;
  }
}
