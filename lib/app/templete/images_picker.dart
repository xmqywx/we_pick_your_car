import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:chewie/chewie.dart';

class ImagesPicker extends StatefulWidget {
  const ImagesPicker({super.key});

  @override
  State<ImagesPicker> createState() => _ImagesPickerState();
}

class _ImagesPickerState extends State<ImagesPicker> {
  @override
  Widget build(BuildContext context) {
    return const ImagePickerPage();
  }
}

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({super.key});
  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  final ImagePicker _picker = ImagePicker();
  final List _imageFileDir = [];
  int count = 0;
//配置播放视频
  late ChewieController chewieController;

  //打开底modal框
  _modelBottomSheet() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 220,
            child: Column(
              children: <Widget>[
                const Divider(),
                ListTile(
                  title: const Text("Take photo"),
                  onTap: () {
                    _takePhoto();
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text("Select photos"),
                  onTap: () {
                    _openGallery();
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                const Divider(),
                ListTile(
                  title: const Text("Cancel"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  _initImageFileDir() {
    List<Widget> list = [];
    if (_imageFileDir.isNotEmpty) {
      list = _imageFileDir.map((path) {
        return Image.file(File(path['imageUrl']));
      }).toList();
    }
    return list;
  }

  List<Widget> _getListData() {
    var tempList = _imageFileDir.map((value) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/view_img_file", arguments: {
            "imageUrl": value['imageUrl'],
            "initialPage": value['id'],
            "listData": _imageFileDir,
          });
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: const Color.fromRGBO(233, 233, 233, 0.9), width: 1)),
          child: Hero(
              tag: "${value['id']}",
              child: Image.file(File(value['imageUrl']))),
          // child: Image.file(File(value['imageUrl']))
        ),
      );
    });
    return tempList.toList();
  }

  @override
  void dispose() {
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Upload site photos :",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            // SizedBox(
            //   width: 100,
            //   child: TextButton(
            //     onPressed: _takePhoto,
            //     child: const Text("Take photo"),
            //   ),
            // ),
            // SizedBox(
            //   width: 100,
            //   child: TextButton(
            //     onPressed: _openGallery,
            //     child: const Text("Select photos"),
            //   ),
            // ),
            OutlinedButton(
              onPressed: _modelBottomSheet,
              child: Text("To upload"),
            )
          ],
        ),
        _imageFileDir.length <= 0
            ? Text("")
            : Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Expanded(
                        child: GridView.count(
                          crossAxisSpacing: 10.0, //水平子 Widget 之间间距
                          mainAxisSpacing: 10.0, //垂直子 Widget 之间间距
                          padding: const EdgeInsets.all(10),
                          crossAxisCount: 2, //一行的 Widget 数量
                          // childAspectRatio:0.7,  //宽度和高度的比例
                          children: _getListData(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed("/generate_signature");
                              },
                              child: Text("Next")),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Back"))
                        ],
                      )
                    ],
                  ),
                ))
      ],
    );
  }

/*拍照*/
  _takePhoto() async {
    XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera, maxWidth: 600, maxHeight: 600);
    if (pickedFile != null) {
      setState(() {
        _imageFileDir.add({"imageUrl": pickedFile.path, "id": count});
        count++;
      });
    }
  }

/*相册*/
  _openGallery() async {
    XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, maxWidth: 600, maxHeight: 600);
    if (pickedFile != null) {
      setState(() {
        _imageFileDir.add({"imageUrl": pickedFile.path, "id": count});
        count++;
      });
      // _uploadFile(pickedFile.path);
    }
  }

//录制视频

//选择视频

/*上传文件*/
  _uploadFile(String imagePath) async {
    var formData = FormData.fromMap({
      'name': 'wendux',
      'age': 25,
      'file': await MultipartFile.fromFile(imagePath, filename: 'aaa.png'),
    });
//https://jd.itying.com/imgupload
//https://jd.itying.com/public/upload/UCO0ZgNYzxkFsjFcGjoVPxkp.png
    var response =
        await Dio().post('https://jdmall.itying.com/imgupload', data: formData);
    print(response);
  }
}
