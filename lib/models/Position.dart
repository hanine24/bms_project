class Position {
 
  double? lat;
  double? lng;

  
  Position(
      {
      required this.lat,
     required this.lng
     });

  fromJson(Map<String, dynamic> json) {
    lat = lat;
    lng = lng;
   

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;

  
    return data;
  }
}