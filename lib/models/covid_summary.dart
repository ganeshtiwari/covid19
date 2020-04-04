class CovidSummary {
  final int confirmed; 
  final int recovered; 
  final int deaths; 
  final String dt;

  CovidSummary({
    this.confirmed, 
    this.recovered, 
    this.deaths, 
    this.dt
  }); 

  factory CovidSummary.fromJson(Map<String, dynamic> json) {
    return CovidSummary(
      confirmed: json['confirmed'], 
      recovered: json['recovered'], 
      deaths: json['deaths'], 
      dt: json['dt']
    ); 
  }
}