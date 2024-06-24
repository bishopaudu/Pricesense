// ignore_for_file: public_member_api_docs, sort_constructors_first
class MacroeconomicsModel {
  final int? id;
  final int officialUsdExchangeRate;
  final int monetaryPolicyRate;
  final int minimumDiscountRate;
  final int interbankCallRate;
  final int treasuryBillRate;
  final int savingsDepositRate;
  final int primeLendingRate;
  final int marketCapitalization;
  final int allShareIndex;
  final int turnOverRatio;
   final int valueShareTraded;
  final int totalListingStocks;
  MacroeconomicsModel({
    this.id,
    required this.officialUsdExchangeRate,
    required this.monetaryPolicyRate,
    required this.minimumDiscountRate,
    required this.interbankCallRate,
    required this.treasuryBillRate,
    required this.savingsDepositRate,
    required this.primeLendingRate,
    required this.marketCapitalization,
    required this.allShareIndex,
    required this.turnOverRatio,
    required this.valueShareTraded,
  required this.totalListingStocks
  });
   Map<String, dynamic> toMap() {
    return {
      'id': id,
      'officialUsdExchangeRate': officialUsdExchangeRate,
      'monetaryPolicyRate': monetaryPolicyRate,
      'minimumDiscountRate': minimumDiscountRate,
      'interbankCallRate': interbankCallRate,
      'treasuryBillRate': treasuryBillRate,
      'savingsDepositRate': savingsDepositRate,
      'primeLendingRate': primeLendingRate,
      'marketCapitalization': marketCapitalization,
      'allShareIndex': allShareIndex,
      'turnOverRatio': turnOverRatio,
      'valueShareTraded': valueShareTraded,
      'totalListingStocks': totalListingStocks,
    };
  }

  static MacroeconomicsModel fromMap(Map<String, dynamic> map) {
    return MacroeconomicsModel(
      id: map['id'],
      officialUsdExchangeRate: map['officialUsdExchangeRate'],
      monetaryPolicyRate: map['monetaryPolicyRate'],
      minimumDiscountRate: map['minimumDiscountRate'],
      interbankCallRate: map['interbankCallRate'],
      treasuryBillRate: map['treasuryBillRate'],
      savingsDepositRate: map['savingsDepositRate'],
      primeLendingRate: map['primeLendingRate'],
      marketCapitalization: map['marketCapitalization'],
      allShareIndex: map['allShareIndex'],
      turnOverRatio: map['turnOverRatio'],
      valueShareTraded: map['valueShareTraded'],
      totalListingStocks: map['totalListingStocks'],
    );
  }
}
