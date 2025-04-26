import 'package:http/http.dart' as http;
import 'dart:convert';


  Future<void> getPlaceDetails(String placeId) async {
    String url = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=AIzaSyBVB2HLxdyG4Zt-067212h_LRcApdOUAsQ";
    final response = await http.get(url as Uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      double latitude = data['result']['geometry']['location']['lat'];
      double longitude = data['result']['geometry']['location']['lng'];
      print("Latitude: $latitude, Longitude: $longitude");
    } else {
      throw Exception('Failed to load data');
    }
  }

