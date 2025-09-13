class World {
  final String id;
  final String name;
  final String description;
  final String authorId;
  final String authorName;
  final int capacity;
  final int recommendedCapacity;
  final String imageUrl;
  final String releaseStatus;
  final List<String> tags;
  final int favorites;
  final int heat;
  final int occupants;
  final int publicOccupants;
  final int privateOccupants;
  final String? previewYoutubeId;
  final String createdAt;
  final String? publicationDate;
  final String? labsPublicationDate;

  World({
    required this.id,
    required this.name,
    required this.description,
    required this.authorId,
    required this.authorName,
    required this.capacity,
    required this.recommendedCapacity,
    required this.imageUrl,
    required this.releaseStatus,
    required this.tags,
    required this.favorites,
    required this.heat,
    required this.occupants,
    required this.publicOccupants,
    required this.privateOccupants,
    this.previewYoutubeId,
    required this.createdAt,
    this.publicationDate,
    this.labsPublicationDate,
  });

  factory World.fromJson(Map<String, dynamic> json) {
    return World(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      capacity: json['capacity'] ?? 0,
      recommendedCapacity: json['recommendedCapacity'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      releaseStatus: json['releaseStatus'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      favorites: json['favorites'] ?? 0,
      heat: json['heat'] ?? 0,
      occupants: json['occupants'] ?? 0,
      publicOccupants: json['publicOccupants'] ?? 0,
      privateOccupants: json['privateOccupants'] ?? 0,
      previewYoutubeId: json['previewYoutubeId'],
      createdAt: json['created_at'] ?? '',
      publicationDate: json['publicationDate'],
      labsPublicationDate: json['labsPublicationDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'authorId': authorId,
      'authorName': authorName,
      'capacity': capacity,
      'recommendedCapacity': recommendedCapacity,
      'imageUrl': imageUrl,
      'releaseStatus': releaseStatus,
      'tags': tags,
      'favorites': favorites,
      'heat': heat,
      'occupants': occupants,
      'publicOccupants': publicOccupants,
      'privateOccupants': privateOccupants,
      'previewYoutubeId': previewYoutubeId,
      'created_at': createdAt,
      'publicationDate': publicationDate,
      'labsPublicationDate': labsPublicationDate,
    };
  }
}
