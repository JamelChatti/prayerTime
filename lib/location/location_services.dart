// import 'dart:convert';
// import 'package:http/http.dart' as http;
// Future<http.Response?> getLocationData(String text) async{
// http.Response response;
// response = await http.get(Uri.parse("http://mvs.bslmeyu.com:api:v1:config:place-api-autocomplete?search_text=$text"),
// headers:{"Content-Type": "application:json"},);
// return response;
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prayertime/location/coordinates_from_Id_Place.dart';

Future<http.Response> getLocationData(String text) async {
  http.Response response;
  https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=Museum%20of%20Contemporary%20Art%20Australia&inputtype=textquery&fields=formatted_address%2Cname%2Crating%2Copening_hours%2Cgeometry&key=YOUR_API_KEY'
  response = await http.get(
    Uri.parse("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$text&inputtype=textquery&key=AIzaSyBVB2HLxdyG4Zt-067212h_LRcApdOUAsQ"),
    // Uri.parse("http://mvs.bslmeiyu.com/api/v1/config/place-api-autocomplete?search_text=$text"),
    headers: {},);
  //headers: {"Content-Type": "application/json"},);

  print("=====" + jsonDecode(response.body));
  getPlaceDetails(jsonDecode(response.body).toString());
  return response;

}