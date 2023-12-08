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
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_image/flutter_image.dart';
// class ImagePickerWidget extends StatefulWidget {
//   final Function(List<String>) onImagesChanged;
//   const ImagePickerWidget({Key? key, required this.onImagesChanged})
//       : super(key: key);
//   @override
//   _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
// }

// class _ImagePickerWidgetState extends State<ImagePickerWidget> {
//   final picker = ImagePicker();
//   final PretreatmentDetailController detailController =
//       Get.find<PretreatmentDetailController>();
//   List<String> _images = [];
//   void _showSelectionMenu(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Container(
//             child: Wrap(
//               children: <Widget>[
//                 ListTile(
//                   leading: Icon(Icons.photo_camera),
//                   title: Text('Take a photo'),
//                   onTap: () async {
//                     final pickedFile =
//                         await picker.pickImage(source: ImageSource.camera);
//                     if (pickedFile != null) {
//                       // var response = await httpsClient.uploadFile(
//                       //     "/admin/base/comm/upload",
//                       //     file: pickedFiles);
//                       var response = await httpsClient.uploadFile(
//                           "/admin/base/comm/upload",
//                           file: File(pickedFile.path));
//                       if (response != null) {
//                         if (response.data["message"] == "success") {
//                           //保存
//                         }
//                         print(response.data["message"]);
//                         showCustomSnackbar(message: 'Upload successful');
//                         // setState(() {
//                         //   // _images.add(response.data['data']);
//                         // });
//                         _images.add(response.data['data']);
//                       } else {
//                         showCustomSnackbar(
//                             message: 'Upload failed', status: '3');
//                       }
//                       widget.onImagesChanged(_images);
//                       Navigator.pop(context);
//                     }
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.photo_library),
//                   title: Text('Select photos'),
//                   onTap: () async {
//                     final pickedFiles = await picker.pickMultiImage(
//                         maxHeight: 1920, maxWidth: 1080);
//                     if (pickedFiles != null) {
//                       // var response = await httpsClient.uploadFile(
//                       //     "/admin/base/comm/upload",
//                       //     file: pickedFiles);
//                       pickedFiles.forEach((file) async {
//                         var response = await httpsClient.uploadFile(
//                             "/admin/base/comm/upload",
//                             file: File(file.path));
//                         if (response != null) {
//                           if (response.data["message"] == "success") {
//                             //保存
//                             print(response.data["message"]);
//                             // setState(() {
//                             //   // _images.add(response.data['data']);
//                             // });
//                             _images.add(response.data['data']);
//                             // print(_images);
//                             showCustomSnackbar(message: 'Upload successful');
//                           }
//                         } else {
//                           print('upload faild');
//                           showCustomSnackbar(
//                               message: 'Upload failed', status: '3');
//                         }
//                       });
//                       widget.onImagesChanged(_images);
//                       Navigator.pop(context);
//                     }
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.cancel),
//                   title: Text('Cancel'),
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _showPreviewDialog(BuildContext context, int index) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           child: Container(
//             padding: EdgeInsets.all(10),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Stack(
//                   children: [
//                     Image.network(
//                       _images[index],
//                       fit: BoxFit.contain,
//                       height: MediaQuery.of(context).size.height * 0.5,
//                     ),
//                     Positioned(
//                       top: 0,
//                       right: 0,
//                       child: IconButton(
//                         icon: Icon(Icons.delete, color: Colors.white),
//                         onPressed: () {
//                           // setState(() {
//                           // });
//                           _images.removeAt(index);
//                           widget.onImagesChanged(_images);
//                           Navigator.pop(context);
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Text(
//           //   'Site photos',
//           //   style: TextStyle(
//           //       fontSize: ScreenAdapter.fontSize(40.32),
//           //       fontWeight: FontWeight.w500,
//           //       fontFamily: "Roboto-Medium"),
//           // ),
//           // const Divider(),
//           GestureDetector(
//             onTap: () => _showSelectionMenu(context),
//             child: Container(
//               margin: EdgeInsets.only(top: 10),
//               height: _images.isNotEmpty ? null : ScreenAdapter.height(331.2),
//               decoration: BoxDecoration(
//                 border: Border.all(color: AppColors.themeBorderColor1),
// //               borderRadius: BorderRadius.circular(8),
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               alignment: Alignment.center,
//               child: _images.isEmpty
//                   ? Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           "assets/images/icon_upload.png",
//                           width: ScreenAdapter.width(60.48),
//                         ),
//                         SizedBox(
//                           height: ScreenAdapter.height(40.32),
//                         ),
//                         Text(
//                           'Click to upload',
//                           style: TextStyle(
//                             fontSize: ScreenAdapter.fontSize(40.32),
//                             fontWeight: FontWeight.bold,
//                             fontFamily: "Roboto-Medium",
//                             color: AppColors.themeTextColor1,
//                           ),
//                         )
//                       ],
//                     )
//                   : GridView.count(
//                       shrinkWrap: true,
//                       crossAxisCount: 4,
//                       children: List.generate(_images.length + 1, (index) {
//                         if (index == _images.length) {
//                           // This is the last item, which will be the box with the plus sign.
//                           return GestureDetector(
//                             onTap: () {
//                               // Handle adding a new image here.
//                               _showSelectionMenu(context);
//                             },
//                             child: Container(
//                               margin: EdgeInsets.all(2),
//                               decoration: BoxDecoration(
//                                   // color: Colors.grey[300],
//                                   borderRadius: BorderRadius.circular(5),
//                                   border: Border.all(
//                                       width: 1, color: Colors.black12)),
//                               child: Icon(
//                                 Icons.add,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           );
//                         } else {
//                           // This is a regular image item.
//                           return GestureDetector(
//                             onTap: () {
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (_) => ImagePreviewScreen(
//                                     images: _images,
//                                     index: index,
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: Stack(
//                               children: [
//                                 Container(
//                                   margin: EdgeInsets.all(2),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(5),
//                                     image: DecorationImage(
//                                       image: NetworkImage(_images[index]),
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   right: 0,
//                                   child: IconButton(
//                                     icon: Icon(
//                                       Icons.clear,
//                                       color: AppColors.redColor,
//                                     ),
//                                     onPressed: () {
//                                       // setState(() {
//                                       // });
//                                       _images.removeAt(index);
//                                       widget.onImagesChanged(_images);
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }
//                       }),
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// HttpsClient httpsClient = HttpsClient();

class ImagePickerWidget extends StatelessWidget {
  final Function(List<String>) onImagesChanged;
  final List<String> images;
  final bool isEditable;
  final bool isOnlyCamera;
  ImagePickerWidget(
      {Key? key,
      required this.onImagesChanged,
      required this.images,
      this.isOnlyCamera = false,
      this.isEditable = true})
      : super(key: key);

  final picker = ImagePicker();

  void _showSelectionMenu(BuildContext context) async {
    takePhoto() async {
      Navigator.pop(context);
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        // var response = await httpsClient.uploadFile(
        //     "/admin/base/comm/upload",
        //     file: pickedFiles);
        int fileSize = await pickedFile.length();
        var response;
        // 如果大于800K,进行压缩
        if (fileSize > 800 * 1024) {
// 压缩文件
          File? compressedFile = await compressFile(File(pickedFile.path));
// 上传压缩后的文件
          if (compressedFile != null) {
            response = await httpsClient.uploadFile(
              "/admin/base/comm/upload",
              file: compressedFile,
            );
          }
        } else {
// 文件本身小于800K,直接上传
          response = await httpsClient.uploadFile(
            "/admin/base/comm/upload",
            file: File(pickedFile.path),
          );
        }
        // response = await httpsClient.uploadFile(
        //     "/admin/base/comm/upload",
        //     file: File(pickedFile.path));
        if (response != null) {
          if (response.data["message"] == "success") {
            //保存
            print(response.data["message"]);
            // showCustomSnackbar(message: 'Upload successful');
            // setState(() {
            //   // _images.add(response.data['data']);
            // });
            images.add(response.data['data']);
          }
        } else {
          showCustomSnackbar(message: 'Upload failed', status: '3');
        }
        onImagesChanged(images);
      }
    }

    if (isOnlyCamera) {
      takePhoto();
      return;
    }
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
                  onTap: takePhoto,
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Select photos'),
                  onTap: () async {
                    final pickedFiles = await picker.pickMultiImage(
                        maxHeight: 1920, maxWidth: 1080);
                    if (pickedFiles != null) {
                      // var response = await httpsClient.uploadFile(
                      //     "/admin/base/comm/upload",
                      //     file: pickedFiles);
                      pickedFiles.forEach((file) async {
                        int fileSize = await file.length();
                        var response;
                        if (fileSize > 800 * 1024) {
// 压缩文件
                          File? compressedFile =
                              await compressFile(File(file.path));
// 上传压缩后的文件
                          if (compressedFile != null) {
                            response = await httpsClient.uploadFile(
                              "/admin/base/comm/upload",
                              file: compressedFile,
                            );
                          }
                        } else {
// 文件本身小于800K,直接上传
                          response = await httpsClient.uploadFile(
                            "/admin/base/comm/upload",
                            file: File(file.path),
                          );
                        }
                        // response = await httpsClient.uploadFile(
                        //     "/admin/base/comm/upload",
                        //     file: File(file.path));
                        if (response != null) {
                          if (response.data["message"] == "success") {
                            //保存
                            print(response.data["message"]);
                            // setState(() {
                            //   // _images.add(response.data['data']);
                            // });
                            images.add(response.data['data']);
                            onImagesChanged(images);
                            // print(_images);
                            // showCustomSnackbar(message: 'Upload successful');
                          }
                        } else {
                          print('upload faild');
                          showCustomSnackbar(
                              message: 'Upload failed', status: '3');
                        }
                      });

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
                    // Image(
                    //   fit: BoxFit.contain,
                    //   height: MediaQuery.of(context).size.height * 0.5,
                    //   image: NetworkImageWithRetry(
                    //     images[index],
                    //     // fetchStrategy: (Uri uri, FetchFailure? failure) async {
                    //     //   final FetchInstructions fetchInstruction =
                    //     //       FetchInstructions.attempt(
                    //     //     uri: uri,
                    //     //     timeout: attemptTimeout,
                    //     //   );

                    //     //   if (failure != null &&
                    //     //       failure.attemptCount > maxAttempt) {
                    //     //     return FetchInstructions.giveUp(uri: uri);
                    //     //   }

                    //     //   return fetchInstruction;
                    //     // },
                    //   ),
                    // ),
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
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: isEditable ? () => _showSelectionMenu(context) : null,
            child: Container(
              // margin: EdgeInsets.only(top: 10),
              height: images.isNotEmpty ? null : ScreenAdapter.height(331.2),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.themeBorderColor1),
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.center,
              child: images.isEmpty
                  ? (isEditable
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
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No data',
                              style: TextStyle(
                                fontSize: ScreenAdapter.fontSize(40.32),
                                fontWeight: FontWeight.bold,
                                fontFamily: "Roboto-Medium",
                                color: AppColors.themeTextColor1,
                              ),
                            )
                          ],
                        ))
                  : GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 4,
                      children: List.generate(
                          isEditable ? images.length + 1 : images.length,
                          (index) {
                        if (isEditable && index == images.length) {
                          return GestureDetector(
                            onTap: () {
                              _showSelectionMenu(context);
                            },
                            child: Container(
                              margin: EdgeInsets.all(2),
                              decoration: BoxDecoration(
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
                                if (isEditable)
                                  Positioned(
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: AppColors.white,
                                      ),
                                      onPressed: () {
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
Future<File?> compressFile(File file) async {
  final filePath = file.absolute.path;
// Create output file path
  final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
  final splitted = filePath.substring(0, (lastIndex));
  final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

// Compress file
  final out = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    outPath,
    quality: 70,
  );

  return out;
}
