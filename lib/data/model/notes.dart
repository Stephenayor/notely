import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;
  late bool isFavorite;
  final DateTime? reminderDate;

  Note({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.isFavorite,
    this.reminderDate,
  });

  Note copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    bool? isFavorite,
    DateTime? reminderDate,
    bool clearReminder = false,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      isFavorite: isFavorite ?? this.isFavorite,
      reminderDate: clearReminder ? null : (reminderDate ?? this.reminderDate),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
      'isFavorite': isFavorite,
      'reminderDate':
          reminderDate != null ? Timestamp.fromDate(reminderDate!) : null,
    };
  }

  //
  //   return Note(
  //     id: data['id'] ?? '',
  //     title: data['title'] ?? '',
  //     body: data['body'] ?? '',
  //     createdAt: DateTime.parse(data['createdAt']),
  //     updatedAt: DateTime.parse(data['updatedAt']),
  //     userId: data['userId'] ?? '',
  //     isFavorite: data['isFavorite'] ?? false,
  //     reminderDate:
  //         data['reminderDate'] != null
  //             ? (data['reminderDate'] as Timestamp).toDate()
  //             : null,
  //   );
  // }

  factory Note.fromMap(Map<String, dynamic> data) {
    DateTime? _parseDate(dynamic value) {
      if (value == null || value == "") return null; // 👈 handle empty string
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value);
      throw Exception("Unsupported date type: ${value.runtimeType}");
    }

    return Note(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
      userId: data['userId'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
      reminderDate: _parseDate(data['reminderDate']), // 👈 safe parsing
    );
  }
}
