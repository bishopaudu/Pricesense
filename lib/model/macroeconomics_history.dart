// ignore_for_file: public_member_api_docs, sort_constructors_first
class MacroeconomicsHistoryResponse {
  final String? error;
  final MacroeconomicsDataItem data;

  MacroeconomicsHistoryResponse({this.error, required this.data});

  factory MacroeconomicsHistoryResponse.fromJson(Map<String, dynamic> json) {
    return MacroeconomicsHistoryResponse(
      error: json['error'],
      data: MacroeconomicsDataItem.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'data': data.toJson(),
    };
  }
}

class MacroeconomicsDataItem {
  final String id;
  final String status;
  final DateTime date;
  final String analyst;
  final int v;
  MacroeconomicsDataItem({
    required this.id,
    required this.status,
    required this.date,
    required this.analyst,
    required this.v,
  });



  factory MacroeconomicsDataItem.fromJson(Map<String, dynamic> json) {
    return MacroeconomicsDataItem(
      id: json['_id'],
      status: json['status'],
      date: DateTime.parse(json['date']),
      analyst: json['analyst'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'status': status,
      'date': date.toIso8601String(),
      'analyst': analyst,
      '__v': v,
    };
  }
}
