import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/tabs_controller.dart';
import '../../../color/colors.dart';

class TabsView extends GetView<TabsController> {
  // int _currentIndex = 0;
  // List<Widget> _pages = [HomePage(), JobsPage(), UserPage()];
  const TabsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        // appBar: AppBar(
        //   title: const Text('TabsView'),
        //   centerTitle: true,
        // ),
        backgroundColor: AppColors.background,
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey,
            unselectedLabelStyle: TextStyle(color: Colors.grey),
            selectedIconTheme: IconThemeData(color: AppColors.primary),
            unselectedIconTheme: IconThemeData(color: Colors.grey),
            currentIndex: controller.currentIndex.value,
            onTap: (index) {
              controller.setCurrentIndex(index);
            },
            items: controller.bottomNavigationBarItems.value),
        body: controller.pages[controller.currentIndex.value]));
  }
}
