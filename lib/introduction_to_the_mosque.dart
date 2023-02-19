import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/quibla/loading.dart';

class IntroductionToTheMosque extends StatefulWidget {
  final MyMasjid? masjid;

  const IntroductionToTheMosque({Key? key, this.masjid}) : super(key: key);

  @override
  State<IntroductionToTheMosque> createState() =>
      _IntroductionToTheMosqueState();
}

class _IntroductionToTheMosqueState extends State<IntroductionToTheMosque> {
  //final Map<String, Image> _loadedImages = {};
  bool isLoading = true;
  List<Image> loadedImages = [];

  @override
  initState() {
    super.initState();
    loadImages().then((value) => setState(() {
          isLoading = false;
        }));
  }

  Future<void> loadImages() async {
    await FirebaseStorage.instance
        .ref()
        .child(widget.masjid!.id)
        .child("images")
        .listAll()
        .then((value) async {
      var image = value.items;
      for (var element in image) {
        var url = await element.getDownloadURL();
        loadedImages.add(Image.network(url));
        // element
        //     .getDownloadURL()
        //     .then((url) => loadedImages.add(Image.network(url)));
        // _loadedImages[masjid!.id] = Image.network(url);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showImage= false;
    return isLoading
        ? LoadingIndicator()
        : Container(
             padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
             color: Colors.indigo[100],
             child: Stack(
               children: [
                 Column(
                   children: [
                    SizedBox(
                      height: 200,
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                        itemCount: loadedImages.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(onTap: (){
                            alertDialog(context,index);
                          },child: PhotoView(imageProvider: loadedImages[index]!.image));
                        },
                      ),
                    ),
                    Text(
                      widget.masjid!.introduction,
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
            ),
               ],
             ));
  }

  void alertDialog(context,index){
    showDialog(
        context: context,
        builder: (_) => AlertDialog(

          content: SizedBox(height: 200, child: PhotoView(imageProvider: loadedImages[index]!.image,customSize: Size(350, 500),)),
        ));
  }


}
