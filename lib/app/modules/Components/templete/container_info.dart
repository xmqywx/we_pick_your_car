import 'package:car_wrecker/app/services/screen_adapter.dart';
import 'package:car_wrecker/app/widget/card_container.dart';
import 'package:flutter/material.dart';
import '../../../templete/files_map.dart';
import '../../../const/wrecker.dart';
import '../../../widget/passButton.dart';
import '../../../color/colors.dart';
import '../../../widget/photo_upload.dart';
import 'dart:convert';

class ContainerInfo extends StatelessWidget {
  final Map<dynamic, dynamic> info;
  final void Function()? edit;
  final void Function()? add;
  final void Function()? delete;
  const ContainerInfo(
      {super.key,
      required this.info,
      required this.edit,
      required this.add,
      required this.delete});

  @override
  Widget build(BuildContext context) {
    Map? containerStatusMap =
        containerStatus[info['status']] ?? {"fields": [], "op": []};
    List<Widget> containerFields() {
      return containerStatusMap['fields'].map<Widget>((data) {
        if (data['type'] != null && data['type'] == 'img') {
          List cloneData = [];
          List<String> imagesFile = <String>[];
          try {
            cloneData = json
                .decode(info[data['prop']])
                .map((e) => e.toString())
                .toList();
          } catch (e) {
            cloneData = [];
          }
          imagesFile = cloneData.cast<String>().toList();
          return Column(
            children: [
              FilesMap(
                attribute: data['label'],
                value: info[data['prop']],
                key: key,
                hasValue: false,
              ),
              ImagePickerWidget(
                onImagesChanged: (list) {},
                images: imagesFile,
                isEditable: false,
              )
            ],
          );
        }
        return FilesMap(
          attribute: data['label'],
          value: info[data['prop']],
          key: key,
        );
      }).toList();
    }

    return CardContainer(
      crossAlign: CrossAxisAlignment.start,
      padding: EdgeInsets.fromLTRB(
          ScreenAdapter.width(20),
          ScreenAdapter.width(10),
          ScreenAdapter.width(20),
          ScreenAdapter.width(10)),
      children: [
        ...containerFields(),
        // Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            containerStatusMap['op'].contains('edit')
                ? Container(
                    // width: ScreenAdapter.width(200),
                    margin: EdgeInsets.only(left: ScreenAdapter.width(10)),
                    child: PassButton(
                      // text: "Edit",
                      btnColor: AppColors.logoBgc,
                      height: 100,
                      fontSize: 45,
                      icon: Icons.edit_document,
                      onPressed: edit,
                    ),
                  )
                : const SizedBox(),
            // containerStatusMap?['op'].contains('add')
            //     ? Container(
            //         // width: ScreenAdapter.width(250),
            //         margin: EdgeInsets.only(left: ScreenAdapter.width(10)),
            //         child: PassButton(
            //           // text: "Add part",
            //           icon: Icons.qr_code_scanner,
            //           btnColor: AppColors.white,
            //           textColor: AppColors.themeTextColor1,
            //           height: 100,
            //           fontSize: 45,
            //           onPressed: add,
            //         ),
            //       )
            //     : const SizedBox(),
            // containerStatusMap?['op'].contains('delete')
            //     ? Container(
            //         // width: ScreenAdapter.width(250),
            //         margin: EdgeInsets.only(left: ScreenAdapter.width(10)),
            //         child: PassButton(
            //           // text: "Delete",
            //           icon: Icons.delete,
            //           btnColor: AppColors.white,
            //           textColor: AppColors.themeTextColor1,
            //           height: 100,
            //           fontSize: 45,
            //           onPressed: delete,
            //         ),
            //       )
            //     : const SizedBox(),
          ],
        ),
        SizedBox(
          height: ScreenAdapter.width(15),
        )
      ],
    );
  }
}
