// import 'dart:async';
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:prayertime/common/masjid.dart';
// import 'package:prayertime/user.dart';
//
//
// class UploadDoc extends StatefulWidget {
//   final MyUser user;
//   final MyMasjid masjid;
//   const UploadDoc({Key? key, required this.user,
//     required this.masjid,}) : super(key: key);
//
//
//   @override
//   State<UploadDoc> createState() => _UploadDocState();
// }
//
// class _UploadDocState extends State<UploadDoc> {
//
//   final fireStoreInstance = FirebaseFirestore.instance;
//   bool userFieldExist = false;
//   final List<XFile> _selectedDoc = [];
//   final Map<String, Image> _loadedDoc = Map();
//   final List<String> _toDeleteDocs = [];
//
//   final List<String> _toDeleteImages = [];
//   final ImagePicker imagePicker = ImagePicker();
//
//   double _progressDoc = 0;
//
//   int docUploaded = 0;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     loadDocs();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Telecharger document'),
//
//       ),
//       body: ListView(
//         children: [
//
//           Column(
//             children: [
//               SizedBox(
//                 height: 150,
//                 child: GridView.builder(
//                     gridDelegate:
//                     const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3),
//                     itemCount: _loadedDoc.length,
//                     itemBuilder: (context, index) {
//                       return Stack(
//                         fit: StackFit.expand,
//                         children: [
//                           _loadedDoc.values.elementAt(index),
//                           // Positioned(
//                           //     top: 0,
//                           //     right: 0,
//                           //     child: IconButton(
//                           //       icon: const Icon(Icons.delete_forever),
//                           //       onPressed: () {
//                           //         setState(() {
//                           //           String name =
//                           //           _loadedDoc.keys.elementAt(index);
//                           //           _toDeleteDocs.add(name);
//                           //           _loadedDoc.remove(
//                           //               _loadedDoc.keys.elementAt(index));
//                           //         });
//                           //       },
//                           //     ))
//                         ],
//                       );
//                     }),
//               ),
//               TextButton(
//                   onPressed: () {
//                     selectDoc();
//                   },
//                   child: const Text(
//                       'Ajouter une copie du document justificatif')),
//               SizedBox(
//                 height: 150,
//                 child: GridView.builder(
//                     itemCount: _selectedDoc.length,
//                     gridDelegate:
//                     const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3),
//                     itemBuilder: (BuildContext context, int index) {
//                       return Stack(
//                         fit: StackFit.expand,
//                         children: [
//                           Image.file(
//                             File(_selectedDoc[index].path),
//                             fit: BoxFit.cover,
//                           ),
//                           Positioned(
//                               top: 0,
//                               right: 0,
//                               child: IconButton(
//                                 icon: const Icon(Icons.delete_forever),
//                                 onPressed: () {
//                                   setState(() {
//                                     _selectedDoc.removeAt(index);
//                                   });
//                                 },
//                               ))
//                         ],
//                       );
//                     }),
//               ),
//             ],
//           ),
//         ],
//       ),
//
//     );
//   }
//
//
//   Future<bool> checkUploadDocs() async {
//     bool uploadCompleted = true;
//     if (_selectedDoc.isNotEmpty) {
//       setState(() {
//         _progressDoc = docUploaded / _selectedDoc.length;
//       });
//     }
//     if (docUploaded < _selectedDoc.length) {
//       uploadCompleted = false;
//     }
//     if (!uploadCompleted) {
//       await Future.delayed(const Duration(milliseconds: 50));
//       uploadCompleted = await checkUploadDocs();
//     }
//
//     //await new Future.delayed(const Duration(seconds: 2));
//     return uploadCompleted;
//   }
//
//   Future<bool> uploadDoc() async {
//     bool saved = true;
//     if (_selectedDoc.isNotEmpty) {
//       _selectedDoc.forEach((element) async {
//         File file = File(element.path);
//         //Todo rondomize name(duplicates?)
//         String imageName = file.path.split("/").last;
//         Reference ref = FirebaseStorage.instance
//             .ref()
//             .child(widget.masjid.id)
//             .child("documents")
//             .child(imageName);
//         try {
//           await ref.putFile(file).whenComplete(() {
//             docUploaded++;
//           });
//         } catch (e) {
//           saved = false;
//         }
//       });
//       await checkUploadDocs();
//     }
//     return saved;
//   }
//   void selectDoc() async {
//     final List<XFile> selectedImages =
//     await imagePicker.pickMultiImage(imageQuality: 20);
//     if (selectedImages.isNotEmpty) {
//       _selectedDoc.addAll(selectedImages);
//     }
//     setState(() {});
//   }
//   Future<void> loadDocs() async {
//     await FirebaseStorage.instance
//         .ref()
//         .child(widget.masjid.id)
//         .child("documents")
//         .listAll()
//         .then((value) {
//       value.items.forEach((element) async {
//         _loadedDoc[element.name] =
//             Image.network(await element.getDownloadURL());
//       });
//     });
//   }
//
// }

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prayertime/views/my_drawer_views/adhan.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/home_page.dart';
import 'package:prayertime/views/my_drawer_views/setting_masjid/setting_masjid.dart';
import 'package:prayertime/class/user.dart';
import 'package:progress_state_button/progress_button.dart';

class UploadDoc extends StatefulWidget {
  final MyUser user;
  final MyMasjid masjid;

  const UploadDoc({
    Key? key,
    required this.user,
    required this.masjid,
  }) : super(key: key);

  @override
  State<UploadDoc> createState() => _UploadDocState();
}

class _UploadDocState extends State<UploadDoc> {
  final fireStoreInstance = FirebaseFirestore.instance;
  bool userFieldExist = false;
  final List<XFile> _selectedDoc = [];
  ButtonState stateOnlyText = ButtonState.idle;

  final Map<String, Image> _loadedDoc = Map();

  final List<String> _toDeleteDoc = [];
  final ImagePicker imagePicker = ImagePicker();
  int docUploaded = 0;
  bool saved = false;
  double _progressDoc = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDoc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Telecharger photo et document'),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              SizedBox(
                height: 150,
                child: GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemCount: _loadedDoc.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          _loadedDoc.values.elementAt(index),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.delete_forever),
                                onPressed: () {
                                  setState(() {
                                    String name =
                                    _loadedDoc.keys.elementAt(index);
                                    _toDeleteDoc.add(name);
                                    _loadedDoc.remove(
                                        _loadedDoc.keys.elementAt(index));
                                  });
                                },
                              ))
                        ],
                      );
                    }),
              ),
              TextButton(
                  onPressed: () {
                    selectDoc();
                  },
                  child: const Text('Ajouter 3 photos de la mosquée')),
              SizedBox(
                height: 150,
                child: GridView.builder(
                    itemCount: _selectedDoc.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return ListView(
                        children: [
                          SizedBox(
                            height:400,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.file(
                                  File(_selectedDoc[index].path),
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(Icons.delete_forever),
                                      onPressed: () {
                                        setState(() {
                                          _selectedDoc.removeAt(index);
                                        });
                                      },
                                    ))
                              ],
                            ),
                          ),

                        ],
                      );
                    }),
              ),
              Container(
                height:200,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: const Text('Retour'),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(child: buildCustomButton()),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void selectDoc() async {
    final List<XFile> selectedDoc =
    await imagePicker.pickMultiImage(imageQuality: 20);
    if (selectedDoc.isNotEmpty) {
      _selectedDoc.addAll(selectedDoc);
    }
    setState(() {});
  }

  Future<bool> uploadFile() async {
    bool saved = true;
    if (_selectedDoc.isNotEmpty) {
      _selectedDoc.forEach((element) async {
        File file = File(element.path);
        //Todo rondomize name(duplicates?)
        String docName = file.path.split("/").last;
        Reference ref = FirebaseStorage.instance
            .ref()
            .child(widget.masjid.id)
            .child("document")
            .child(docName);
        try {
          await ref.putFile(file).whenComplete(() {
            docUploaded++;
          });
        } catch (e) {
          saved = false;
        }
      });
      await checkUploadFiles();
    }
    return saved;
  }

  Future<bool> checkUploadFiles() async {
    bool uploadCompleted = true;
    if (_selectedDoc.isNotEmpty) {
      setState(() {
        _progressDoc = docUploaded / _selectedDoc.length;
      });
    }

    if (docUploaded < _selectedDoc.length) {
      uploadCompleted = false;
    }

    if (!uploadCompleted) {
      await Future.delayed(const Duration(milliseconds: 50));
      uploadCompleted = await checkUploadFiles();
    }

    //await new Future.delayed(const Duration(seconds: 2));
    return uploadCompleted;
  }

  Future<void> loadDoc() async {
    await FirebaseStorage.instance
        .ref()
        .child(widget.masjid.id)
        .child("document")
        .listAll()
        .then((value) async {
      for (var element in value.items) {
        _loadedDoc[element.name] =
            Image.network(await element.getDownloadURL());
        setState(() {});
      }
    });
  }
  Widget buildCustomButton() {
    var progressTextButton = ProgressButton(
      stateWidgets: {
        ButtonState.idle: Text(
          saved ? "Recommencer le téléchargement" : "Enregistrer",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.loading: const Text(
          "Loading",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.fail: const Text(
          "Fail",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.success: const Text(
          "Success",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        )
      },
      stateColors: {
        ButtonState.idle: Colors.blue.shade300,
        ButtonState.loading: Colors.grey.shade400,
        ButtonState.fail: Colors.red.shade300,
        ButtonState.success: Colors.green.shade400,
      },
      onPressed: onPressedCustomButton,
      state: stateOnlyText,
      padding: const EdgeInsets.all(8.0),
    );
    return progressTextButton;
  }

  Future<bool> deleteFile() async {
    bool deleted = true;
    if (_toDeleteDoc.isNotEmpty) {
      _toDeleteDoc.forEach((element) async {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child(widget.masjid.id)
            .child("document")
            .child(element);
        try {
          await ref.delete();
        } catch (e) {
          deleted = false;
        }
      });
    }
    return deleted;
  }

  void onPressedCustomButton() async {
    switch (stateOnlyText) {
      case ButtonState.idle:
        setState(() {
          stateOnlyText = ButtonState.loading;
        });
        if (!saved) {

          await loadDoc();

          await deleteFile();


          bool filesUploaded = await uploadFile();

          if (filesUploaded) {
            setState(() {
              stateOnlyText = ButtonState.success;
            });
            Navigator.of(context).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SettingMasjid(user: widget.user, masjid: widget.masjid)),
            );
          } else {
            Navigator.of(context).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Adhan()),
            );
          }

        }
        if (saved) {
        } else {
          setState(() {
            stateOnlyText = ButtonState.idle;
          });
        }
        break;
      case ButtonState.loading:
      case ButtonState.success:
      case ButtonState.fail:
        return;
    }

    setState(() {});
  }

}
