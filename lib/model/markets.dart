class Market {
  final String id;
  final String name;

  Market({required this.id, required this.name});

    factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Market.fromMap(Map<String, dynamic> map) {
    return Market(
      id: map['id'],
      name: map['name'],
    );
  }
}

class City {
  final String id;
  final String name;
  final List<Market> markets;

  City({required this.id, required this.name, required this.markets});

  factory City.fromJson(Map<String, dynamic> json) {
    var marketList = json['markets'] as List;
    List<Market> markets = marketList.map((i) => Market.fromJson(i)).toList();

    return City(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      markets: markets,
    );
  }
    Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'markets': markets.map((market) => market.toMap()).toList(),
    };
  }
}
