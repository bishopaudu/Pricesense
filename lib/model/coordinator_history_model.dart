/*
import 'dart:convert';

// main Response class
class EnergyHistoryModel {
  final String? error;
  final Data? data;

  EnergyHistoryModel({required this.error, required this.data});

  factory EnergyHistoryModel.fromMap(Map<String, dynamic> json) {
    return EnergyHistoryModel(
      error: json['error'],
      data: json['data'] != null ? Data.fromMap(json['data']) : null,
    );
  }

  factory EnergyHistoryModel.fromJson(String source) => EnergyHistoryModel.fromMap(json.decode(source));
}

// Define the Data class containing the history list
class Data {
  final List<EnergyHistory>? history;

  Data({this.history});

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      history: map['history'] != null
          ? List<EnergyHistory>.from(map['history'].map((x) => EnergyHistory.fromMap(x)))
          : null,
    );
  }

  factory Data.fromJson(String source) => Data.fromMap(json.decode(source));
}

// Define the History class representing each history record
class EnergyHistory {
  final String id;
  final City city;
  final int unofficialUsdExchangeRate;
  final int litreOfPetrolIndependent;
  final int litreOfPetrolNnpc;
  final int litreOfDieselIndependent;
  final int litreOfDieselNnpc;
  final DateTime date;
  final Coordinator coordinator;
  final int version;

  EnergyHistory({
    required this.id,
    required this.city,
    required this.unofficialUsdExchangeRate,
    required this.litreOfPetrolIndependent,
    required this.litreOfPetrolNnpc,
    required this.litreOfDieselIndependent,
    required this.litreOfDieselNnpc,
    required this.date,
    required this.coordinator,
    required this.version,
  });

  factory EnergyHistory.fromMap(Map<String, dynamic> map) {
    return EnergyHistory(
      id: map['_id'],
      city: City.fromMap(map['city']),
      unofficialUsdExchangeRate: map['unofficial_usd_exchange_rate'],
      litreOfPetrolIndependent: map['litre_of_petrol_independent'],
      litreOfPetrolNnpc: map['litre_of_petrol_nnpc'],
      litreOfDieselIndependent: map['litre_of_diesel_independent'],
      litreOfDieselNnpc: map['litre_of_diesel_nnpc'],
      date: DateTime.parse(map['date']),
      coordinator: Coordinator.fromMap(map['coordinator']),
      version: map['__v'],
    );
  }

  factory EnergyHistory.fromJson(String source) => EnergyHistory.fromMap(json.decode(source));
}

// Define the City class
class City {
  final String name;

  City({required this.name});

  factory City.fromMap(Map<String, dynamic> map) {
    return City(name: map['name']);
  }

  factory City.fromJson(String source) => City.fromMap(json.decode(source));
}

// Define the Coordinator class
class Coordinator {
  final String firstname;
  final String lastname;

  Coordinator({required this.firstname, required this.lastname});

  factory Coordinator.fromMap(Map<String, dynamic> map) {
    return Coordinator(
      firstname: map['firstname'],
      lastname: map['lastname'],
    );
  }

  factory Coordinator.fromJson(String source) => Coordinator.fromMap(json.decode(source));
}
*/

import 'dart:convert';

// Main Response class
class EnergyHistoryModel {
  final String? error;
  final Data? data;

  EnergyHistoryModel({required this.error, required this.data});

  factory EnergyHistoryModel.fromMap(Map<String, dynamic> map) {
    return EnergyHistoryModel(
      error: map['error'],
      data: map['data'] != null ? Data.fromMap(map['data']) : null,
    );
  }

  factory EnergyHistoryModel.fromJson(String source) => EnergyHistoryModel.fromMap(json.decode(source));
}

// Data class containing the history list
class Data {
  final List<EnergyHistory>? history;

  Data({this.history});

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      history: map['history'] != null
          ? List<EnergyHistory>.from(map['history'].map((x) => EnergyHistory.fromMap(x)))
          : null,
    );
  }

  factory Data.fromJson(String source) => Data.fromMap(json.decode(source));
}

// History class representing each history record
class EnergyHistory {
  final String id;
  final City city;
  final int unofficialUsdExchangeRate;
  final int litreOfPetrolIndependent;
  final int litreOfPetrolNnpc;
  final int litreOfDieselIndependent;
  final int litreOfDieselNnpc;
  final DateTime date;
  final Coordinator coordinator;
  final int version;

  EnergyHistory({
    required this.id,
    required this.city,
    required this.unofficialUsdExchangeRate,
    required this.litreOfPetrolIndependent,
    required this.litreOfPetrolNnpc,
    required this.litreOfDieselIndependent,
    required this.litreOfDieselNnpc,
    required this.date,
    required this.coordinator,
    required this.version,
  });

  factory EnergyHistory.fromMap(Map<String, dynamic> map) {
    return EnergyHistory(
      id: map['_id'],
      city: City.fromMap(map['city']),
      unofficialUsdExchangeRate: map['unofficial_usd_exchange_rate'],
      litreOfPetrolIndependent: map['litre_of_petrol_independent'],
      litreOfPetrolNnpc: map['litre_of_petrol_nnpc'],
      litreOfDieselIndependent: map['litre_of_diesel_independent'],
      litreOfDieselNnpc: map['litre_of_diesel_nnpc'],
      date: DateTime.parse(map['date']),
      coordinator: Coordinator.fromMap(map['coordinator']),
      version: map['__v'],
    );
  }

  factory EnergyHistory.fromJson(String source) => EnergyHistory.fromMap(json.decode(source));
}

// City class
class City {
  final String name;

  City({required this.name});

  factory City.fromMap(Map<String, dynamic> map) {
    return City(name: map['name']);
  }

  factory City.fromJson(String source) => City.fromMap(json.decode(source));
}

// Coordinator class
class Coordinator {
  final String firstname;
  final String lastname;

  Coordinator({required this.firstname, required this.lastname});

  factory Coordinator.fromMap(Map<String, dynamic> map) {
    return Coordinator(
      firstname: map['firstname'],
      lastname: map['lastname'],
    );
  }

  factory Coordinator.fromJson(String source) => Coordinator.fromMap(json.decode(source));
}
