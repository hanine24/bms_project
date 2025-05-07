class Bms {
 
  String? temp;
  String? tension;
  String? courant;
  String? soc;

  
  Bms(
      {
      required this.courant,
     required this.soc,
     required this.temp,
     required this.tension
     });

  fromJson(Map<String, dynamic> json) {
    tension = tension;
    courant = courant;
      soc = soc;
    temp = temp;
   

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courant'] = this.courant;
    data['temp'] = this.temp;
        data['soc'] = this.soc;
    data['tension'] = this.tension;

  
    return data;
  }
}