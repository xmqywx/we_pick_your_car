import 'dart:io';
import 'package:car_wrecker/app/color/colors.dart';
import 'package:car_wrecker/app/services/screen_adapter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/https_client.dart';
import './image_preview_screen.dart';
import '../widget/toast.dart';
import '../modules/pretreatment_detail/controllers/pretreatment_detail_controller.dart';
import 'package:get/get.dart';

class ImagePickerWidget extends StatelessWidget {
  final Function(List<String>) onImagesChanged;
  final List<String> images;
  ImagePickerWidget(
      {Key? key, required this.onImagesChanged, required this.images})
      : super(key: key);
  final picker = ImagePicker();
  void _showSelectionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Take a photo'),
                  onTap: () async {
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      var response = await httpsClient.uploadFile(
                          "/admin/base/comm/upload",
                          file: File(pickedFile.path));
                      if (response != null) {
                        showCustomSnackbar(message: 'Upload successful');
                        images.add(response.data['data']);
                      } else {
                        showCustomSnackbar(
                            message: 'Upload failed', status: '3');
                      }
                      onImagesChanged(images);
                      Navigator.pop(context);
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Select photos'),
                  onTap: () async {
                    final pickedFiles = await picker.pickMultiImage(
                        maxHeight: 1920, maxWidth: 1080);
                    if (pickedFiles != null) {
                      pickedFiles.forEach((file) async {
                        var response = await httpsClient.uploadFile(
                            "/admin/base/comm/upload",
                            file: File(file.path));
                        if (response != null) {
                          if (response.data["message"] == "success") {
                            //保存
                            print(response.data["message"]);
                            images.add(response.data['data']);
                            // print(_images);
                            showCustomSnackbar(message: 'Upload successful');
                          }
                        } else {
                          print('upload faild');
                          showCustomSnackbar(
                              message: 'Upload failed', status: '3');
                        }
                      });
                      onImagesChanged(images);
                      Navigator.pop(context);
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.cancel),
                  title: Text('Cancel'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPreviewDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Stack(
                  children: [
                    Image.network(
                      images[index],
                      fit: BoxFit.contain,
                      height: MediaQuery.of(context).size.height * 0.5,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.white),
                        onPressed: () {
                          // setState(() {
                          // });
                          images.removeAt(index);
                          onImagesChanged(images);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _showSelectionMenu(context),
            child: Container(
              margin: EdgeInsets.only(top: 10),
              height: images.isNotEmpty ? null : ScreenAdapter.height(331.2),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.themeBorderColor1),
//               borderRadius: BorderRadius.circular(8),
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.center,
              child: images.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/icon_upload.png",
                          width: ScreenAdapter.width(60.48),
                        ),
                        SizedBox(
                          height: ScreenAdapter.height(40.32),
                        ),
                        Text(
                          'Click to upload',
                          style: TextStyle(
                            fontSize: ScreenAdapter.fontSize(40.32),
                            fontWeight: FontWeight.bold,
                            fontFamily: "Roboto-Medium",
                            color: AppColors.themeTextColor1,
                          ),
                        )
                      ],
                    )
                  : GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 4,
                      children: List.generate(images.length + 1, (index) {
                        if (index == images.length) {
                          // This is the last item, which will be the box with the plus sign.
                          return GestureDetector(
                            onTap: () {
                              // Handle adding a new image here.
                              _showSelectionMenu(context);
                            },
                            child: Container(
                              margin: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  // color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      width: 1, color: Colors.black12)),
                              child: Icon(
                                Icons.add,
                                color: Colors.grey[600],
                              ),
                            ),
                          );
                        } else {
                          // This is a regular image item.
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ImagePreviewScreen(
                                    images: images,
                                    index: index,
                                  ),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                      image: NetworkImage(images[index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: AppColors.redColor,
                                    ),
                                    onPressed: () {
                                      // setState(() {
                                      // });
                                      images.removeAt(index);
                                      onImagesChanged(images);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

HttpsClient httpsClient = HttpsClient();
