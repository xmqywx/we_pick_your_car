import 'package:car_wrecker/app/services/screen_adapter.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../controllers/pretreatment_controller.dart';
import '../../../widget/no_login.dart';
import '../../../color/colors.dart';

import '../../../widget/loading.dart';

class PretreatmentView extends GetView<PretreatmentController> {
  const PretreatmentView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            Obx(() => CustomAppBar(
                onSelectChanged: controller.onSelectChanged,
                onSelectStatusChanged: controller.onSelectStatusChanged,
                selectValue: controller.selectValue.value,
                selectStatusValue: controller.selectStatusValue.value,
                searchController: controller.textEditingController.value,
                onSearchChange: controller.onSearchChange,
                clearFilter: controller.clearFilter,
                keyWordFilter: controller.keyWordFilter)),
            Expanded(
              flex: 1,
              child: RefreshIndicator(
                  onRefresh: controller.handleRefresh,
                  child: Obx(() => ListView(
                          padding: EdgeInsets.fromLTRB(
                              0,
                              ScreenAdapter.height(12),
                              0,
                              ScreenAdapter.height(24)),
                          children: [
                            !controller.isLoadingController.isLoading.value
                                ? (Column(
                                    children:
                                        controller.initListView().length > 0
                                            ? controller.initListView()
                                            : [NoLogin()],
                                  ))
                                : Loading()
                          ]))),
            )
          ],
        ));
  }
}

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ValueChanged<String> onSelectChanged;
  final ValueChanged<String> onSelectStatusChanged;
  final void Function(String)? onSearchChange;
  final void Function()? keyWordFilter;
  final void Function()? clearFilter;
  final String? initialValue;
  final String? initialStatusValue;
  final String selectValue;
  final String selectStatusValue;
  final TextEditingController searchController;
  CustomAppBar(
      {Key? key,
      required this.onSelectChanged,
      required this.onSelectStatusChanged,
      this.initialValue,
      this.initialStatusValue,
      required this.onSearchChange,
      required this.selectValue,
      required this.selectStatusValue,
      required this.keyWordFilter,
      required this.clearFilter,
      required this.searchController})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  final Size preferredSize;
}

class _CustomAppBarState extends State<CustomAppBar> {
  late String _dropdownValue;
  late String _statusDropdownValue;
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _dropdownValue = widget.initialValue ?? 'All time';
    _statusDropdownValue = widget.initialStatusValue ?? 'Waiting';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // backgroundColor: Color.fromARGB(255, 253, 247, 247).withOpacity(0.3),
        // elevation: 0,
        // height: ScreenAdapter.height(260),
        height: ScreenAdapter.height(371.52),
        // color: AppColors.themeColor1,
        child: Column(
          children: [
            Container(
                height: ScreenAdapter.height(259.2),
                color: AppColors.themeColor1,
                padding: EdgeInsets.fromLTRB(
                    ScreenAdapter.width(43.2),
                    ScreenAdapter.height(129.6),
                    ScreenAdapter.width(43.2),
                    ScreenAdapter.height(43.2)),
                child: SizedBox(
                  height: ScreenAdapter.height(86.4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          height: ScreenAdapter.height(86.4),
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(43.2)),
                          child: TextField(
                            focusNode: _focusNode,
                            controller: widget.searchController,
                            onChanged: widget.onSearchChange,
                            style: TextStyle(fontFamily: "Roboto-Medium"),
                            decoration: InputDecoration(
                              hintText: 'Search',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 10)
                                  .copyWith(bottom: 6),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          widget.keyWordFilter!();
                          _focusNode.unfocus();
                        },
                        icon: Icon(
                          Icons.search,
                          color: AppColors.darkBlueColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          widget.clearFilter!();
                          _focusNode.unfocus();
                        },
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )),
            Container(
              height: ScreenAdapter.height(112.32),
              color: AppColors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                      flex: 1,
                      // width: ScreenAdapter.width(300),
                      child: Center(
                        child: DropdownButton<String>(
                          value: widget.selectStatusValue,
                          underline: Text(""),
                          style: TextStyle(
                              fontFamily: "Roboto-Medium",
                              color: AppColors.themeTextColor1),
                          // dropdownColor: Colors.transparent,
                          // icon: const Icon(Icons.arrow_drop_down),
                          // alignment: AlignmentDirectional.center,
                          iconSize: 24,
                          // elevation: 16,
                          onChanged: (String? newValue) {
                            setState(() {
                              _statusDropdownValue = newValue!;
                            });
                            widget.onSelectStatusChanged(newValue!);
                          },
                          items: <String>['All status', 'Waiting', 'Completed']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      )),
                  Container(
                    width: 1,
                    height: ScreenAdapter.height(54.72),
                    color: AppColors.verDrvider,
                  ),
                  Expanded(
                      // width: ScreenAdapter.width(300),
                      flex: 1,
                      child: Center(
                        child: DropdownButton<String>(
                          value: widget.selectValue,
                          underline: Text(""),
                          // dropdownColor: Colors.transparent,
                          // icon: const Icon(Icons.arrow_drop_down),
                          // alignment: AlignmentDirectional.center,
                          iconSize: 24,
                          style: TextStyle(
                              fontFamily: "Roboto-Medium",
                              color: AppColors.themeTextColor1),
                          // elevation: 16,
                          onChanged: (String? newValue) {
                            setState(() {
                              _dropdownValue = newValue!;
                            });
                            widget.onSelectChanged(newValue!);
                          },
                          items: <String>[
                            'All time',
                            '3 days',
                            '1 week',
                            '1 month'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      )),
                  // Expanded(
                  //   flex: 1,
                  //   child:
                  // ),
                ],
              ),
            )
          ],
        ));
  }
}
