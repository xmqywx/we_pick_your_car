import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../home/views/home_view.dart';
import '../../user/views/user_view.dart';
// import '../../Wrecking/views/wrecking_view.dart';
import '../../Components/views/components_view.dart';
import '../../../services/https_client.dart';
import '../../../services/storage.dart';
import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';
import '../../user/controllers/user_controller.dart';
import '../../../templete/event.dart';
import '../../NoRole/views/no_role_view.dart';
import '../../dismantlers/views/dismantlers_view.dart';
import '../../dismantlers_stats/views/dismantlers_stats_view.dart';

class TabsController extends GetxController {
  RxInt currentIndex = 0.obs; //可改变，需要给obs
  PageController pageController = Get.arguments != null
      ? PageController(initialPage: Get.arguments["initialPage"])
      : PageController(initialPage: 0);
  RxList jobsList = [].obs;
  RxList jobListPageData = [].obs;
  RxList orderList = [].obs;
  HttpsClient httpsClient = HttpsClient();
  UserController userController = Get.find();

  final count = 0.obs;
  RxList<Widget> pages = [
    // HomeView(),
    // TaskListView(),
    // WreckingView(),
    const NoRoleView(),
    const UserView(),
  ].obs;
  RxList<BottomNavigationBarItem> bottomNavigationBarItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: "My"),
  ].obs;
  // RxList<BottomNavigationBarItem> bottomNavigationBarItems =
  //     <BottomNavigationBarItem>[].obs;
// bottomNavigationBarItems.addAll([
//   BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//   BottomNavigationBarItem(icon: Icon(Icons.task), label: "Job"),
// ]);
  //不可改变，final，不需要obs

  RxMap<DateTime, List<Event>> kEvents = RxMap<DateTime, List<Event>>({});

  getUserInfo() async {
    var response = await httpsClient.get('/admin/base/comm/person');
    if (response != null && response.data['message'] == 'success') {
      await Storage.setData('userinfo', response.data['data']);
      print('Response userinfo saved successfully');
    } else {
      print('Token expired or network error');
    }
    return response;
  }

  getJobList() async {
    final userinfo = await Storage.getData('userinfo');
    Map searchData = {"driverID": userinfo['id']};

    print(searchData);
    if (true) {
      var response =
          await httpsClient.post('/admin/job/info/list', data: searchData);
      if (response != null && response.data['message'] == 'success') {
        jobsList.value = response.data['data'];
        initializeEvents(response.data['data']);
        print(response.data['data'].length);
        update();
        print("jobs list finish");
      } else {
        print('Token expired or network error');
      }
    }
  }

  RxMap filterDataCopy = {}.obs;
  getJobListPageData({Map? filterData}) async {
    if (filterData != null) {
      filterDataCopy.value = filterData;
    }
    final userinfo = await Storage.getData('userinfo');
    Map searchData = {"driverID": userinfo['id'], "status": 1};
    if (filterData != null) {
      searchData.addAll(filterData);
    } else {
      searchData.addAll(filterDataCopy.value);
    }
    print(searchData);
    jobListIsLoading.value = true;
    var response =
        await httpsClient.post('/admin/job/info/list', data: searchData);
    if (response != null && response.data['message'] == 'success') {
      jobListPageData.value = response.data['data'];
      print('OK');
    } else {}
    jobListIsLoading.value = false;
  }

  getOrderList() async {
    final userinfo = await Storage.getData('userinfo');
    if (true) {
      var response = await httpsClient
          .post('/admin/order/info/list', data: {"driverID": userinfo['id']});
      if (response != null && response.data['message'] == 'success') {
        orderList.value = response.data['data'];
        print("jobsOrder finish");
      } else {
        print('Token expired or network error');
      }
    }
  }

  initializationList() async {
    await getUserInfo();
    await userController.getUserInfo();
    await getJobList();
    await getOrderList();
    update();
  }

  RxBool jobListIsLoading = false.obs;

  initializationJobViewList({Map? filterData}) async {
    // await getUserInfo();
    jobListIsLoading.value = true;
    await userController.getUserInfo();
    await getJobListPageData(filterData: filterData);
    jobListIsLoading.value = false;
  }

  initTabs() async {
    final userinfo = await Storage.getData('userinfo');

    if (userinfo == null) {
      userController.loginOut();
      return;
    }
    if (userinfo['roleName'] != null &&
        containsRoles(
            userinfo['roleName'], ['Driver', 'Container', 'Dismantlers'])) {
      // 如果添加Wrecker角色的话需要添加Wrecker
      bottomNavigationBarItems.value = [
        const BottomNavigationBarItem(icon: Icon(Icons.person), label: "My"),
      ];
      List<Widget> pagesCopy = [];
      // 如果添加Wrecker角色的话
      if (userinfo['roleName'].contains('Container')) {
        List<StatelessWidget> pagesToAdd = const [ComponentsView()];
        pagesCopy.insertAll(0, pagesToAdd.cast<StatelessWidget>());

        bottomNavigationBarItems.value = [
          const BottomNavigationBarItem(
              icon: Icon(Icons.hotel_class_sharp), label: "Container"),
          ...bottomNavigationBarItems
        ];
        pages.refresh();
      }
      if (userinfo['roleName'].contains('Driver')) {
        List<StatelessWidget> pagesToAdd = const [
          HomeView(), /* TaskListView() */
        ];
        pagesCopy.insertAll(0, pagesToAdd.cast<StatelessWidget>());
        // List<BottomNavigationBarItem> items = [
        //   BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        //   BottomNavigationBarItem(icon: Icon(Icons.task), label: "Job"),
        // ];
        bottomNavigationBarItems.value = [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          // const BottomNavigationBarItem(icon: Icon(Icons.task), label: "Job"),
          ...bottomNavigationBarItems
        ];
        pages.refresh();
      }
      // 如果添加Dismantlers角色的话
      if (userinfo['roleName'].contains('Dismantlers')) {
        List<StatelessWidget> pagesToAdd = const [
          DismantlersView(),
          DismantlersStatsView()
        ];
        pagesCopy.insertAll(0, pagesToAdd.cast<StatelessWidget>());
        bottomNavigationBarItems.value = [
          const BottomNavigationBarItem(
              icon: Icon(Icons.build), label: "Dismantlers"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.countertops), label: "Stats"),
          ...bottomNavigationBarItems
        ];
        pages.refresh();
      }

      pages.value = [...pagesCopy, const UserView()].cast<StatelessWidget>();
      print(pages);
    } else {}
  }

  @override
  void onInit() async {
    await initTabs();
    super.onInit();
    if (Get.arguments != null) {
      currentIndex.value = Get.arguments["initialPage"];
    }
    // initializationList();
    // if (!userController.isLogin.value) {
    //   Get.offNamed('/pass_login');
    // }
  }

  List<Map<dynamic, dynamic>> initJobsList(data) {
    List<Map<dynamic, dynamic>> newJobsList = [];
    for (final item in data) {
      var exitItem = newJobsList.firstWhere(
        // (v) => v['expectedDate'] == item['expectedDate'],
        (v) {
          // 将字符串类型的时间戳转换成DateTime类型
          if (v['schedulerStart'] == null || item['schedulerStart'] == null) {
            return false;
          }
          DateTime dateTime1 = DateTime.fromMillisecondsSinceEpoch(
              int.parse(v['schedulerStart']));
          DateTime dateTime2 = DateTime.fromMillisecondsSinceEpoch(
              int.parse(item['schedulerStart']));
          // 比较日期是否相同
          if (dateTime1.year == dateTime2.year &&
              dateTime1.month == dateTime2.month &&
              dateTime1.day == dateTime2.day) {
            // 日期相同
            return true;
          } else {
            // 日期不同
            return false;
          }
        },
        orElse: () => {},
      );
      if (exitItem.isNotEmpty) {
        int index = newJobsList.indexOf(exitItem);
        newJobsList[index]['event'].add(Event(
            title: item['pickupAddress'],
            id: item['id'],
            color: item['color'],
            image: item['image'],
            status: item['status'],
            expectedDate: item['expectedDate'],
            schedulerStart: item['schedulerStart'],
            schedulerEnd: item['schedulerEnd']));
      } else {
        newJobsList.add({
          'schedulerStart': item['schedulerStart'],
          'event': [
            Event(
                title: item['pickupAddress'],
                id: item['id'],
                color: item['color'],
                image: item['image'],
                status: item['status'],
                expectedDate: item['expectedDate'],
                schedulerStart: item['schedulerStart'],
                schedulerEnd: item['schedulerEnd'])
          ]
        });
      }
    }

    return newJobsList;
  }

  void initializeEvents(data) {
    var handleJobsList = initJobsList(data);
    final Map<DateTime, List<Event>> kEventSource = {
      for (var item in handleJobsList)
        if (item['schedulerStart'] != null)
          DateTime.fromMillisecondsSinceEpoch(int.parse(item['schedulerStart']))
              .subtract(const Duration(hours: 0)): item['event']
    };
    kEvents.value = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(kEventSource);
  }


  void setCurrentIndex(index) {
    currentIndex.value = index;
  }
}

bool containsRoles(String str, List<String> role) {
  return role.any((substring) => str.contains(substring));
}
