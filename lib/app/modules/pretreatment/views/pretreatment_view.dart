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
                            !controller.myController.jobListIsLoading.value
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
        // height: ScreenAdapter.height(371.52),
        // color: AppColors.themeColor1,
        child: Column(
      children: [
        Container(
            // height: ScreenAdapter.height(259.2),
            color: AppColors.themeColor1,
            padding: EdgeInsets.fromLTRB(
                ScreenAdapter.width(43.2),
                ScreenAdapter.height(80.6),
                ScreenAdapter.width(43.2),
                ScreenAdapter.height(20.2)),
            child: Container(
              // height: ScreenAdapter.height(86.4),
              padding: EdgeInsets.zero,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    // flex: 1,
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 30),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        focusNode: _focusNode,
                        controller: widget.searchController,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: AppColors.white,
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                          suffixIcon: Container(
                            padding: EdgeInsets.only(top: 0),
                            margin: EdgeInsets.only(right: 0),
                            constraints: BoxConstraints(maxHeight: 30, maxWidth: 30), 
                            child: IconButton(
                              onPressed: () {
                                widget.keyWordFilter!();
                                _focusNode.unfocus();
                              },
                              icon: Icon(Icons.search, color: AppColors.darkBlueColor, size: 24), 
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: "Roboto-Medium",
                        ),
                        onChanged: widget.onSearchChange,
                      ),
                    ),
                  ),
                  // IconButton(
                  //   padding: EdgeInsets.zero,
                  //   onPressed: () {
                  //     widget.keyWordFilter!();
                  //     _focusNode.unfocus();
                  //   },
                  //   icon: Icon(
                  //     Icons.search,
                  //     color: AppColors.darkBlueColor,
                  //   ),
                  //   iconSize: ScreenAdapter.height(86.4),
                  // ),
                  SizedBox(width: 10,),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[100],
                      borderRadius: BorderRadius.circular(15), // Adjusted for a 30x30 size to maintain circular shape
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        widget.clearFilter!();
                        _focusNode.unfocus();
                      },
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.blueGrey[900],
                        size: 18, // Adjusted icon size for the new container size
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            )),
        Container(
          height: ScreenAdapter.height(120),
          color: AppColors.white,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: ScreenAdapter.height(90),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppColors.greyColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: widget.selectStatusValue,
                      isExpanded: true,
                      icon: Icon(Icons.keyboard_arrow_down, color: AppColors.darkBlueColor),
                      style: TextStyle(
                        fontFamily: "Roboto-Medium",
                        color: AppColors.themeTextColor1,
                      ),
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
                  ),
                ),
              ),
              SizedBox(width: 20),
              Container(
                width: 1,
                height: ScreenAdapter.height(54.72),
                color: AppColors.greyColor,
              ),
              SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: Container(
                  height: ScreenAdapter.height(90),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppColors.greyColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: widget.selectValue,
                      isExpanded: true,
                      icon: Icon(Icons.keyboard_arrow_down, color: AppColors.darkBlueColor),
                      style: TextStyle(
                        fontFamily: "Roboto-Medium",
                        color: AppColors.themeTextColor1,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _dropdownValue = newValue!;
                        });
                        widget.onSelectChanged(newValue!);
                      },
                      items: <String>['All time', '3 days', '1 week', '1 month']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
