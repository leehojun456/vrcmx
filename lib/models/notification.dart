class VRChatNotification {
  final String id;
  final String type;
  final String? senderUserId;
  final String? senderUsername;
  final String? receiverUserId;
  final String message;
  final Map<String, dynamic>? details;
  final bool seen;
  final DateTime? created;
  final Map<String, dynamic>? rawApiResponse;

  const VRChatNotification({
    required this.id,
    required this.type,
    this.senderUserId,
    this.senderUsername,
    this.receiverUserId,
    required this.message,
    this.details,
    this.seen = false,
    this.created,
    this.rawApiResponse,
  });

  VRChatNotification copyWith({
    String? id,
    String? type,
    String? senderUserId,
    String? senderUsername,
    String? receiverUserId,
    String? message,
    Map<String, dynamic>? details,
    bool? seen,
    DateTime? created,
    Map<String, dynamic>? rawApiResponse,
  }) {
    return VRChatNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      senderUserId: senderUserId ?? this.senderUserId,
      senderUsername: senderUsername ?? this.senderUsername,
      receiverUserId: receiverUserId ?? this.receiverUserId,
      message: message ?? this.message,
      details: details ?? this.details,
      seen: seen ?? this.seen,
      created: created ?? this.created,
      rawApiResponse: rawApiResponse ?? this.rawApiResponse,
    );
  }

  factory VRChatNotification.fromJson(Map<String, dynamic> json) {
    return VRChatNotification(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      senderUserId: json['senderUserId'] as String?,
      senderUsername: json['senderUsername'] as String?,
      receiverUserId: json['receiverUserId'] as String?,
      message: json['message'] as String? ?? '',
      details: json['details'] as Map<String, dynamic>?,
      seen: (json['seen'] as bool?) ?? false,
      created: json['created'] != null
          ? DateTime.tryParse(json['created'] as String)
          : null,
      rawApiResponse: json['rawApiResponse'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'senderUserId': senderUserId,
        'senderUsername': senderUsername,
        'receiverUserId': receiverUserId,
        'message': message,
        'details': details,
        'seen': seen,
        'created': created?.toIso8601String(),
        'rawApiResponse': rawApiResponse,
      };
}

class WebSocketMessage {
  final String type;
  final String? content;
  final Map<String, dynamic>? rawData;

  const WebSocketMessage({
    required this.type,
    this.content,
    this.rawData,
  });

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) =>
      WebSocketMessage(
        type: json['type'] as String? ?? '',
        content: json['content'] as String?,
        rawData: json['rawData'] as Map<String, dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'content': content,
        'rawData': rawData,
      };
}

