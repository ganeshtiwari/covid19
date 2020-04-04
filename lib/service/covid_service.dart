import 'dart:async' show Future; 
import 'package:covid19/models/current.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert';
import 'package:covid19/models/covid_summary.dart';

Future<CovidSummary> fetchCovidSummary() async {
  final String url = "https://covid2019-api.herokuapp.com/total"; 
  final response = await http.get(url); 
  if (response.statusCode == 200) {
    return CovidSummary.fromJson(json.decode(response.body)); 
  } else {
    throw Exception("Failed to fetch covid summary"); 
  }
}

Future<CurrentStats> fetchCurrentStats() async {
  final String url = "https://covid2019-api.herokuapp.com/v2/current";
  final response = await http.get(url); 

  if (response.statusCode == 200) {
    return CurrentStats.fromJson(json.decode(response.body)); 
  } else {
    throw Exception("Failed to fetch current stats");
  }
}