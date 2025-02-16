import 'dart:io';
import 'package:car_wrecker/app/color/colors.dart';
import 'package:car_wrecker/app/services/screen_adapter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/https_client.dart';
import './image_preview_screen.dart';
import '../widget/toast.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImagePickerWidget extends StatelessWidget {
  final Function(List<String>) onImagesChanged;
  final List<String> images;
  final bool isEditable;
  final bool? isOnlyCamera;
  ImagePickerWidget(
      {Key? key,
      required this.onImagesChanged,
      required this.images,
      this.isOnlyCamera = false,
      this.isEditable = true})
      : super(key: key);

  final picker = ImagePicker();

  void _showSelectionMenu(BuildContext context) {
    takePhoto() async {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
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
        if (response != null) {
          if (response.data["message"] == "success") {
            //保存
            print(response.data["message"]);
            images.add(response.data['data']);
          }
        } else {
          showCustomSnackbar(message: 'Upload failed', status: '3');
        }
        onImagesChanged(images);
      }
    }

    if (isOnlyCamera != null && isOnlyCamera == true) {
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
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Take a photo'),
                  onTap: () {
                    Navigator.pop(context);
                    takePhoto();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Select photos'),
                  onTap: () async {
                    final pickedFiles = await picker.pickMultiImage(
                      maxHeight: 1920,
                      maxWidth: 1080,
                    );

                    for (var file in pickedFiles) {
                      // 检查文件类型，支持更多图片格式
                      if (file.path.endsWith('.jpg') ||
                          file.path.endsWith('.jpeg') ||
                          file.path.endsWith('.png') ||
                          file.path.endsWith('.gif') ||
                          file.path.endsWith('.bmp') ||
                          file.path.endsWith('.tiff') ||
                          file.path.endsWith('.webp')) {
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

                        if (response != null) {
                          if (response.data["message"] == "success") {
                            // 保存
                            print(response.data["message"]);
                            images.add(response.data['data']);
                            onImagesChanged(images);
                          }
                        } else {
                          print('upload failed');
                          showCustomSnackbar(
                            message: 'Upload failed',
                            status: '3',
                          );
                        }
                      } else {
                        // 如果选择的文件不是图片，显示提示
                        showCustomSnackbar(
                          message: 'Please select only image files.',
                          status: '3',
                        );
                      }
                    }

                    Navigator.pop(context);
                                    },
                ),
                ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text('Cancel'),
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
            padding: const EdgeInsets.all(10),
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
                        icon: const Icon(Icons.delete, color: Colors.white),
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
      padding: const EdgeInsets.symmetric(vertical: 5),
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
                  color: AppColors.white),
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
                              margin: const EdgeInsets.all(2),
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
                                  margin: const EdgeInsets.all(2),
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
                                      icon: const Icon(
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
  final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
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
