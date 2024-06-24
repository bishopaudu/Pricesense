
import 'dart:convert';

class GridData {
  final int completed;
  final int submitted;
  final int uploaded;

  GridData({
    required this.completed,
    required this.submitted,
    required this.uploaded,
  });

  factory GridData.fromJson(Map<String, dynamic> json) {
    return GridData(
      uploaded: json['uploaded'] ?? "",
      completed: json['completed'] ?? "",
      submitted: json['submitted'] ?? "",
    );
  }
}

