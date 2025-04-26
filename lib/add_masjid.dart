// import 'dart:ui' as ui;
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:prayertime/common/masjid.dart';
//
//
// class AddMasjid extends StatefulWidget {
//   const AddMasjid({Key? key}) : super(key: key);
//
//   @override
//   State<AddMasjid> createState() => _AddMasjidState();
// }
//
// class _AddMasjidState extends State<AddMasjid> {
//   TextEditingController masjidController = TextEditingController();
//
//   TextEditingController fajrTimeinput = TextEditingController();
//   TextEditingController dhohrTimeinput = TextEditingController();
//   TextEditingController asrTimeinput = TextEditingController();
//   TextEditingController maghrebTimeinput = TextEditingController();
//   TextEditingController ichaTimeinput = TextEditingController();
//   TextEditingController joumouaTimeinput = TextEditingController();
//   TextEditingController aidTimeinput = TextEditingController();
//   final TextEditingController masjidTimeinput= TextEditingController();
//   DateTime _dateTime = DateTime.now();
//   List<MyMasjid> massajid = [];
//   var expression = RegExp('([-]?)([0-9]+)');
//   static final f = DateFormat('dd-MM-yyyy          kk:mm');
//
//   //text editing controller for text field
//
//   @override
//   void initState() {
//     fajrTimeinput.text = "";
//     dhohrTimeinput.text = "";
//     asrTimeinput.text = "";
//     maghrebTimeinput.text = "";
//     ichaTimeinput.text = "";
//     aidTimeinput.text = "";
//     joumouaTimeinput.text = "";//set the initial value of text field
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white70,
//           title: const Text(''),
//         ),
//         body: Directionality(
//             textDirection: ui.TextDirection.rtl,
//             child: SizedBox(
//               height: 600,
//               child: Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: ListView(children: [
//                     Text(f.format(DateTime.now()),
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 20)),
//                     const Text('اضافة مسجد',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 18)),
//                     TextFormField(
//                       controller: masjidController,
//                       decoration: const InputDecoration(
//                         border: UnderlineInputBorder(),
//                         filled: true,
//                         icon: Icon(Icons.confirmation_num_outlined),
//                         labelText: 'اسم المسجد',
//                         hintText: 'اسم المسجد ',
//                       ),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'الرجاء ادحال اسم المسجد';
//                         }
//                         return '';
//                       },
//                     ),
//                     Row(children: [
//                       const Expanded(flex: 2, child: Text('صلاة الفجر')),
//                       //  const Expanded(child: Text('الساعة ')),
//
//                       Expanded(
//                         flex: 7,
//                         child: Container(
//                             padding: const EdgeInsets.all(15),
//                             height:50,
//                             child:Center(
//                                 child:TextField(
//                                   controller: fajrTimeinput, //editing controller of this TextField
//                                   decoration: const InputDecoration(
//                                      // icon: Icon(Icons.timer), //icon of text field
//                                       //labelText: "Enter Time" ,
//                                   ),
//                                   readOnly: true,  //set it true, so that user will not able to edit text
//                                   onTap: () async {
//                                     TimeOfDay? pickedTime =  await showTimePicker(
//                                       initialTime: TimeOfDay.now(),
//                                       context: context,
//                                     );
//
//                                     if(pickedTime != null ){
//                                      // print(pickedTime.format(context));   //output 10:51 PM
//                                       DateTime parsedTime = DateFormat.Hm().parse(pickedTime.format(context).toString());
//                                       //converting to DateTime so that we can further format on different pattern.
//                                       print(parsedTime); //output 1970-01-01 22:53:00.000
//                                       String formattedTime = DateFormat('HH:mm').format(parsedTime);
//                                       print(formattedTime); //output 14:59:00
//                                       //DateFormat() is from intl package, you can format the time on any pattern you need.
//
//                                       setState(() {
//                                         fajrTimeinput.text = formattedTime; //set the value of text field.
//                                       });
//                                     }else{
//                                       print("Time is not selected");
//                                     }
//                                   },
//
//                                 )
//                             )
//
//                         ),
//                       ),
//                     ]),
//                     Row(children: [
//                       const Expanded(flex: 2, child: Text('صلاة الظهر')),
//                       //  const Expanded(child: Text('الساعة ')),
//
//                       Expanded(
//                         flex: 7,
//                         child: Container(
//                             padding: const EdgeInsets.all(15),
//                             height:50,
//                             child:Center(
//                                 child:TextField(
//                                   controller: dhohrTimeinput, //editing controller of this TextField
//                                   decoration: const InputDecoration(
//                                     // icon: Icon(Icons.timer), //icon of text field
//                                    // labelText: "Enter Time" ,
//                                   ),
//                                   readOnly: true,  //set it true, so that user will not able to edit text
//                                   onTap: () async {
//                                     TimeOfDay? pickedTime =  await showTimePicker(
//                                       initialTime: TimeOfDay.now(),
//                                       context: context,
//                                     );
//
//                                     if(pickedTime != null ){
//                                       // print(pickedTime.format(context));   //output 10:51 PM
//                                       DateTime parsedTime = DateFormat.Hm().parse(pickedTime.format(context).toString());
//                                       //converting to DateTime so that we can further format on different pattern.
//                                       print(parsedTime); //output 1970-01-01 22:53:00.000
//                                       String formattedTime = DateFormat('HH:mm').format(parsedTime);
//                                       print(formattedTime); //output 14:59:00
//                                       //DateFormat() is from intl package, you can format the time on any pattern you need.
//
//                                       setState(() {
//                                         dhohrTimeinput.text = formattedTime; //set the value of text field.
//                                       });
//                                     }else{
//                                       print("Time is not selected");
//                                     }
//                                   },
//
//                                 )
//                             )
//
//                         ),
//                       ),
//                     ]),
//                     Row(children: [
//                       const Expanded(flex: 2, child: Text('صلاة العصر')),
//                       //  const Expanded(child: Text('الساعة ')),
//
//                       Expanded(
//                         flex: 7,
//                         child: Container(
//                             padding: const EdgeInsets.all(15),
//                             height:50,
//                             child:Center(
//                                 child:TextField(
//                                   controller: asrTimeinput, //editing controller of this TextField
//                                   decoration: const InputDecoration(
//                                     // icon: Icon(Icons.timer), //icon of text field
//                                    // labelText: "Enter Time" ,
//                                   ),
//                                   readOnly: true,  //set it true, so that user will not able to edit text
//                                   onTap: () async {
//                                     TimeOfDay? pickedTime =  await showTimePicker(
//                                       initialTime: TimeOfDay.now(),
//                                       context: context,
//                                     );
//
//                                     if(pickedTime != null ){
//                                       // print(pickedTime.format(context));   //output 10:51 PM
//                                       DateTime parsedTime = DateFormat.Hm().parse(pickedTime.format(context).toString());
//                                       //converting to DateTime so that we can further format on different pattern.
//                                       print(parsedTime); //output 1970-01-01 22:53:00.000
//                                       String formattedTime = DateFormat('HH:mm').format(parsedTime);
//                                       print(formattedTime); //output 14:59:00
//                                       //DateFormat() is from intl package, you can format the time on any pattern you need.
//
//                                       setState(() {
//                                         asrTimeinput.text = formattedTime; //set the value of text field.
//                                       });
//                                     }else{
//                                       print("Time is not selected");
//                                     }
//                                   },
//
//                                 )
//                             )
//
//                         ),
//                       ),
//                     ]),
//                     Row(children: [
//                       const Expanded(flex: 2, child: Text('صلاة المغرب')),
//                       //  const Expanded(child: Text('الساعة ')),
//
//                       Expanded(
//                         flex: 7,
//                         child: Container(
//                             padding: const EdgeInsets.all(15),
//                             height:50,
//                             child:Center(
//                                 child:TextField(
//                                   controller: maghrebTimeinput, //editing controller of this TextField
//                                   decoration: const InputDecoration(
//                                     // icon: Icon(Icons.timer), //icon of text field
//                                     //labelText: "Enter Time" ,
//                                   ),
//                                   readOnly: true,  //set it true, so that user will not able to edit text
//                                   onTap: () async {
//                                     TimeOfDay? pickedTime =  await showTimePicker(
//                                       initialTime: TimeOfDay.now(),
//                                       context: context,
//                                     );
//
//                                     if(pickedTime != null ){
//                                       // print(pickedTime.format(context));   //output 10:51 PM
//                                       DateTime parsedTime = DateFormat.Hm().parse(pickedTime.format(context).toString());
//                                       //converting to DateTime so that we can further format on different pattern.
//                                       print(parsedTime); //output 1970-01-01 22:53:00.000
//                                       String formattedTime = DateFormat('HH:mm').format(parsedTime);
//                                       print(formattedTime); //output 14:59:00
//                                       //DateFormat() is from intl package, you can format the time on any pattern you need.
//
//                                       setState(() {
//                                         maghrebTimeinput.text = formattedTime; //set the value of text field.
//                                       });
//                                     }else{
//                                       print("Time is not selected");
//                                     }
//                                   },
//
//                                 )
//                             )
//
//                         ),
//                       ),
//                     ]),
//                     Row(children: [
//                       const Expanded(flex: 2, child: Text('صلاة العشاء')),
//                       //  const Expanded(child: Text('الساعة ')),
//
//                       Expanded(
//                         flex: 7,
//                         child: Container(
//                             padding: const EdgeInsets.all(15),
//                             height:50,
//                             child:Center(
//                                 child:TextField(
//                                   controller: ichaTimeinput, //editing controller of this TextField
//                                   decoration: const InputDecoration(
//                                     // icon: Icon(Icons.timer), //icon of text field
//                                    // labelText: "Enter Time" ,
//                                   ),
//                                   readOnly: true,  //set it true, so that user will not able to edit text
//                                   onTap: () async {
//                                     TimeOfDay? pickedTime =  await showTimePicker(
//                                       initialTime: TimeOfDay.now(),
//                                       context: context,
//                                     );
//
//                                     if(pickedTime != null ){
//                                       // print(pickedTime.format(context));   //output 10:51 PM
//                                       DateTime parsedTime = DateFormat.Hm().parse(pickedTime.format(context).toString());
//                                       //converting to DateTime so that we can further format on different pattern.
//                                       print(parsedTime); //output 1970-01-01 22:53:00.000
//                                       String formattedTime = DateFormat('HH:mm').format(parsedTime);
//                                       print(formattedTime); //output 14:59:00
//                                       //DateFormat() is from intl package, you can format the time on any pattern you need.
//
//                                       setState(() {
//                                         ichaTimeinput.text = formattedTime; //set the value of text field.
//                                       });
//                                     }else{
//                                       print("Time is not selected");
//                                     }
//                                   },
//
//                                 )
//                             )
//
//                         ),
//                       ),
//                     ]),
//                     Row(children: [
//                       const Expanded(flex: 2, child: Text('صلاة الجمعة')),
//                       //  const Expanded(child: Text('الساعة ')),
//
//                       Expanded(
//                         flex: 7,
//                         child: Container(
//                             padding: const EdgeInsets.all(15),
//                             height:50,
//                             child:Center(
//                                 child:TextField(
//                                   controller: joumouaTimeinput, //editing controller of this TextField
//                                   decoration: const InputDecoration(
//                                     // icon: Icon(Icons.timer), //icon of text field
//                                     //labelText: "Enter Time" ,
//                                   ),
//                                   readOnly: true,  //set it true, so that user will not able to edit text
//                                   onTap: () async {
//                                     TimeOfDay? pickedTime =  await showTimePicker(
//                                       initialTime: TimeOfDay.now(),
//                                       context: context,
//                                     );
//
//                                     if(pickedTime != null ){
//                                       // print(pickedTime.format(context));   //output 10:51 PM
//                                       DateTime parsedTime = DateFormat.Hm().parse(pickedTime.format(context).toString());
//                                       //converting to DateTime so that we can further format on different pattern.
//                                       print(parsedTime); //output 1970-01-01 22:53:00.000
//                                       String formattedTime = DateFormat('HH:mm').format(parsedTime);
//                                       print(formattedTime); //output 14:59:00
//                                       //DateFormat() is from intl package, you can format the time on any pattern you need.
//
//                                       setState(() {
//                                         joumouaTimeinput.text = formattedTime; //set the value of text field.
//                                       });
//                                     }else{
//                                       print("Time is not selected");
//                                     }
//                                   },
//
//                                 )
//                             )
//
//                         ),
//                       ),
//                     ]),
//                     Row(children: [
//                       const Expanded(flex: 2, child: Text('صلاة العيد')),
//                       //  const Expanded(child: Text('الساعة ')),
//
//                       Expanded(
//                         flex: 7,
//                         child: Container(
//                             padding: const EdgeInsets.all(15),
//                             height:50,
//                             child:Center(
//                                 child:TextField(
//                                   controller: aidTimeinput, //editing controller of this TextField
//                                   decoration: const InputDecoration(
//                                     // icon: Icon(Icons.timer), //icon of text field
//                                    // labelText: "Enter Time" ,
//                                   ),
//                                   readOnly: true,  //set it true, so that user will not able to edit text
//                                   onTap: () async {
//                                     TimeOfDay? pickedTime =  await showTimePicker(
//                                       initialTime: TimeOfDay.now(),
//                                       context: context,
//                                     );
//
//                                     if(pickedTime != null ){
//                                       // print(pickedTime.format(context));   //output 10:51 PM
//                                       DateTime parsedTime = DateFormat.Hm().parse(pickedTime.format(context).toString());
//                                       //converting to DateTime so that we can further format on different pattern.
//                                       print(parsedTime); //output 1970-01-01 22:53:00.000
//                                       String formattedTime = DateFormat('HH:mm').format(parsedTime);
//                                       print(formattedTime); //output 14:59:00
//                                       //DateFormat() is from intl package, you can format the time on any pattern you need.
//
//                                       setState(() {
//                                         aidTimeinput.text = formattedTime; //set the value of text field.
//                                       });
//                                     }else{
//                                       print("Time is not selected");
//                                     }
//                                   },
//
//                                 )
//                             )
//
//                         ),
//                       ),
//                     ]),
//                     ElevatedButton(onPressed: (){
// FirebaseFirestore.instance.collection("masjid").add({
//   "masjidName":masjidController.text,
//   'fajrIqama':fajrTimeinput.text,
//   'dhohrIqama':dhohrTimeinput.text,
//   'asrIqama':asrTimeinput.text,
//   'maghrebIqama':maghrebTimeinput.text,
//   'ichaIqama':ichaTimeinput.text,
//   'joumouaIqama':joumouaTimeinput.text,
//   'aidIqama':aidTimeinput.text,
//
// });
//                     }, child: const Text('Valider'))
//
//
//                   ])),
//             )));
//   }
//
//
//
//   List<MyMasjid> getListMassajid(String value) {
//     massajid.clear();
//     // for (var element in dataList) {
//     //   if (element.name.toLowerCase().startsWith(value.toLowerCase())) {
//     //     articles.add(element);
//     //     // FocusNode node = FocusNode();
//     //     // myFocusNodes.add(node);
//     //     // node.requestFocus();
//     //   }
//     // }
//     return massajid;
//   }
// }
