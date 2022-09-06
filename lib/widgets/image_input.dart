import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPath;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './Toast.dart';

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  final List<File> galleryGO;

  ImageInput(this.onSelectImage, this.galleryGO);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;
  bool isMap = false;
  late FToast ftoast;
  @override
  void initState() {
    super.initState();
    ftoast = FToast();
    ftoast.init(context);
  }

  void saveImage(File img) {
    setState(() {
      widget.galleryGO.insert(0, img);
    });
  }

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(
      source: ImageSource.camera,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });
    final appDir = await sysPath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);

    final savedImage =
        await File(imageFile.path).copy("${appDir.path}/$fileName");

    saveImage(savedImage);

    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          Builder(builder: (context) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).backgroundColor,
                  boxShadow: const [
                    BoxShadow(
                        blurRadius: 20,
                        offset: Offset(-10, -10),
                        color: Colors.white,
                        inset: true),
                    BoxShadow(
                        blurRadius: 12,
                        offset: Offset(10, 10),
                        color: Color(0xFFA7A9AF),
                        inset: true)
                  ],
                ),
                child: widget.galleryGO.isNotEmpty
                    ? CarouselSlider.builder(
                        itemCount: widget.galleryGO.length,
                        itemBuilder: (context, index, realIndex) {
                          return GestureDetector(
                            onTap: () => showDialog(
                                context: context,
                                builder: (context) => _dialogBuilder(
                                    context, (widget.galleryGO[index]))),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              width: double.infinity,
                              child: Material(
                                elevation: 20,
                                borderRadius: BorderRadius.circular(20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    widget.galleryGO[index],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          viewportFraction: 0.7,
                          height: double.infinity,
                          enableInfiniteScroll: false,
                          enlargeCenterPage: true,
                          aspectRatio: 1,
                          initialPage: 0,
                        ),
                      )
                    : const Text(
                        "No picture selected",
                        style: TextStyle(
                            fontFamily: "RobotRegular",
                            color: Color.fromARGB(255, 96, 116, 137),
                            fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                alignment: Alignment.center,
              ),
            );
          }),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 130,
                  height: 42,
                  child: ElevatedButton.icon(
                    onPressed: () => _takePicture(),
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Color.fromRGBO(244, 238, 255, 1),
                    ),
                    label: Text(
                      isMap ? "Add point" : "Photo",
                      style: TextStyle(
                          fontFamily: "NexaTextBook",
                          color: Color.fromRGBO(244, 238, 255, 1)),
                    ),
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.resolveWith<double>(
                            (Set<MaterialState> states) {
                          return 10;
                        }),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                  width: 130,
                  height: 42,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          isMap = !isMap;
                        });
                      },
                      icon: Icon(
                        Icons.photo_library,
                        color: Color.fromRGBO(244, 238, 255, 1),
                      ),
                      label: Text(
                        isMap ? "Gallery" : "Map",
                        style: TextStyle(
                          color: Color.fromRGBO(244, 238, 255, 1),
                          fontWeight: FontWeight.normal,
                          fontFamily: "NexaTextBook",
                        ),
                      ),
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.resolveWith<double>(
                              (Set<MaterialState> states) {
                            return 10;
                          }),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

//Widget buildImage(File img, int index, path.Context context) =>
//    Image.file(img, fit: BoxFit.fill);

Widget _dialogBuilder(BuildContext context, File img) {
  return SimpleDialog(
    contentPadding: EdgeInsets.zero,
    children: [
      Image.file(
        img,
        fit: BoxFit.fill,
      ),
    ],
  );
}
