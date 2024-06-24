class AnalystHistoryResponse {
  final String? error;
  final  AnalystHistoryData data;

  AnalystHistoryResponse({this.error, required this.data});

  factory AnalystHistoryResponse.fromJson(Map<String, dynamic> json) {
    return AnalystHistoryResponse(
      error: json['error'],
      data:  AnalystHistoryData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'data': data.toJson(),
    };
  }
}

class AnalystHistoryData {
  final List<AnalystHistoryItem> history;

  AnalystHistoryData({required this.history});

  factory AnalystHistoryData.fromJson(Map<String, dynamic> json) {
    var historyJson = json['history'] as List;
    List<AnalystHistoryItem> historyList = historyJson.map((i) => AnalystHistoryItem.fromJson(i)).toList();

    return AnalystHistoryData(history: historyList);
  }

  Map<String, dynamic> toJson() {
    return {
      'history': history.map((item) => item.toJson()).toList(),
    };
  }
}

class AnalystHistoryItem{
  final String title;
  final String subtitle;
  final String id;
  final String type;
  final  DateTime date;
  final String? figure;

  AnalystHistoryItem({
    required this.title,
    required this.subtitle,
    required this.id,
    required this.type,
    required this.date,
    this.figure,
  });

  factory AnalystHistoryItem.fromJson(Map<String, dynamic> json) {
    return AnalystHistoryItem(
      title: json['title'],
      subtitle: json['subtitle'],
      id: json['id'],
      type: json['type'],
       date: DateTime.parse(json['date']),
      figure: json['figure'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'id': id,
      'type': type,
      'date': date.toIso8601String(),
      'figure': figure,
    };
  }
}
