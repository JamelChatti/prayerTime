import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prayertime/adhan.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/home_page.dart';
import 'package:prayertime/setting_masjid/setting_masjid.dart';
import 'package:prayertime/user.dart';
import 'package:progress_state_button/progress_button.dart';

class UploadPhoto extends StatefulWidget {
  final MyUser user;
  final MyMasjid masjid;

  const UploadPhoto({
    Key? key,
    required this.user,
    required this.masjid,
  }) : super(key: key);

  @override
  State<UploadPhoto> createState() => _UploadPhotoState();
}

class _UploadPhotoState extends State<UploadPhoto> {
  final fireStoreInstance = FirebaseFirestore.instance;
  bool userFieldExist = false;
  final List<XFile> _selectedImages = [];
  ButtonState stateOnlyText = ButtonState.idle;

  final Map<String, Image> _loadedImages = Map();

  final List<String> _toDeleteImages = [];
  final ImagePicker imagePicker = ImagePicker();
  double _progress = 0;
  int imageUploaded = 0;
  bool saved = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImages();
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
                    itemCount: _loadedImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          _loadedImages.values.elementAt(index),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.delete_forever),
                                onPressed: () {
                                  setState(() {
                                    String name =
                                        _loadedImages.keys.elementAt(index);
                                    _toDeleteImages.add(name);
                                    _loadedImages.remove(
                                        _loadedImages.keys.elementAt(index));
                                  });
                                },
                              ))
                        ],
                      );
                    }),
              ),
              TextButton(
                  onPressed: () {
                    selectImages();
                  },
                  child: const Text('Ajouter 3 photos de la mosquée')),
              SizedBox(
                height: 150,
                child: GridView.builder(
                    itemCount: _selectedImages.length,
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
                                  File(_selectedImages[index].path),
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(Icons.delete_forever),
                                      onPressed: () {
                                        setState(() {
                                          _selectedImages.removeAt(index);
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

  void selectImages() async {
    final List<XFile> selectedImages =
        await imagePicker.pickMultiImage(imageQuality: 20);
    if (selectedImages.isNotEmpty) {
      _selectedImages.addAll(selectedImages);
    }
    setState(() {});
  }

  Future<bool> uploadFile() async {
    bool saved = true;
    if (_selectedImages.isNotEmpty) {
      _selectedImages.forEach((element) async {
        File file = File(element.path);
        //Todo rondomize name(duplicates?)
        String imageName = file.path.split("/").last;
        Reference ref = FirebaseStorage.instance
            .ref()
            .child(widget.masjid.id)
            .child("images")
            .child(imageName);
        try {
          await ref.putFile(file).whenComplete(() {
            imageUploaded++;
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
    if (_selectedImages.isNotEmpty) {
      setState(() {
        _progress = imageUploaded / _selectedImages.length;
      });
    }

    if (imageUploaded < _selectedImages.length) {
      uploadCompleted = false;
    }

    if (!uploadCompleted) {
      await Future.delayed(const Duration(milliseconds: 50));
      uploadCompleted = await checkUploadFiles();
    }

    //await new Future.delayed(const Duration(seconds: 2));
    return uploadCompleted;
  }

  Future<void> loadImages() async {
    await FirebaseStorage.instance
        .ref()
        .child(widget.masjid.id)
        .child("images")
        .listAll()
        .then((value) async {
      for (var element in value.items) {
        _loadedImages[element.name] =
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
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
    if (_toDeleteImages.isNotEmpty) {
      _toDeleteImages.forEach((element) async {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child(widget.masjid.id)
            .child("images")
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

            await loadImages();

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
