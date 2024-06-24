// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EnergyModel {
  final String city;
  final int unofficialusdexchangerate;
  final int pricepetrolindependent;
  final int pricepetrolnnpc;
  final int pricedieselindependent;
  final int pricedieselnnpc;

  EnergyModel({required this.city, required this.unofficialusdexchangerate, required this.pricepetrolindependent, required this.pricepetrolnnpc, required this.pricedieselindependent, required this.pricedieselnnpc});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'city': city,
      'unofficialusdexchangerate': unofficialusdexchangerate,
      'pricepetrolindependent': pricepetrolindependent,
      'pricepetrolnnpc': pricepetrolnnpc,
      'pricedieselindependent': pricedieselindependent,
      'pricedieselnnpc': pricedieselnnpc,
    };
  }

  factory EnergyModel.fromMap(Map<String, dynamic> map) {
    return EnergyModel(
      city: map['city'] as String,
      unofficialusdexchangerate: map['unofficialusdexchangerate'] as int,
      pricepetrolindependent: map['pricepetrolindependent'] as int,
      pricepetrolnnpc: map['pricepetrolnnpc'] as int,
      pricedieselindependent: map['pricedieselindependent'] as int,
      pricedieselnnpc: map['pricedieselnnpc'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory EnergyModel.fromJson(String source) => EnergyModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
