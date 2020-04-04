class Current {
  final String location;
  final int confirmed; 
  final int deaths; 
  final int recovered; 

  Current({
    this.location, 
    this.confirmed, 
    this.deaths, 
    this.recovered
  }); 

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      location: json['location'], 
      confirmed: json['confirmed'], 
      deaths: json['deaths'], 
      recovered: json['recovered'], 
    );
  }
}

class CurrentStats {
  final List<Current> data; 
  final String dt; 

  CurrentStats({this.data, this.dt});

  factory CurrentStats.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List; 
    List<Current> currentList = dataList.map((i) => Current.fromJson(i)).toList();
    
    return CurrentStats(
      data: currentList,
      dt: json['dt'] 
    ); 
  }
}