// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// class NearMasjid extends StatefulWidget {
//   const NearMasjid({Key? key}) : super(key: key);
//
//   @override
//   State<NearMasjid> createState() => _NearMasjidState();
// }
//
// class _NearMasjidState extends State<NearMasjid> {
//   String apiKey = '';
//   String radius = '30';
//
//   double longitude = 71.279664;
//
//   double latitude = 31.5111093;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Mosquées proches'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             ElevatedButton(
//                 onPressed: () {
//                   getNearMasjid();
//                 },
//                 child: const Text('Mosquée proche'))
//           ],
//         ),
//       ),
//     );
//   }
//
//   void getNearMasjid() async{
// var url = Uri.parse('https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=' + latitude.toString() + '.'
//     + longitude.toString() + '&radius=' + radius + '&key=' + apiKey);
//
// var response = await http.post(url);
//
//
//   }
// }
