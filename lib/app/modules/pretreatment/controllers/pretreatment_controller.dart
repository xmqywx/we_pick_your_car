import 'package:get/get.dart';
import '../../tabs/controllers/tabs_controller.dart';
import '../../../templete/custom_card.dart';
import 'package:flutter/material.dart';
import '../../../controllers/is_loading_controller.dart';

class PretreatmentController extends GetxController {
  //TODO: Implement PretreatmentController
  final TabsController myController = Get.find<TabsController>();

  final IsLoadingController isLoadingController =
      Get.find<IsLoadingController>();

  final count = 0.obs;

  RxBool isLoading = false.obs;

  RxList<Widget> initListView() {
    RxList<Widget> list = RxList<Widget>();
    for (var value in myController.jobListPageData) {
      list.addAll([
        InkWell(
          child: CustomCard(
            pickupAddress: value['pickupAddress'] ?? "--",
            expectedDate: value['expectedDate'] ?? "--",
            engine: value['engine'] ?? "--",
            image: value['image'] ?? "--",
            name: value['name'] ?? "--",
            model: value['model'] ?? "--",
            pickupAddressState: value['pickupAddressState'] ?? "--",
            status: value['status'],
            arguments: value,
          ),
          onTap: () {
            print(1111);
            Get.toNamed(
              "/job-details",
              arguments: {
                ...value,
                "refresh": handleRefresh,
              },
            );
          },
        )
      ]);
    }
    return list;
  }

  // ==============================Refresh
  Future<void> handleRefresh() async {
    myController.getJobListPageData(filterData: searchData);
  }

  // ==============================filter
  final RxMap searchData = {}.obs;
  final Rx<TextEditingController> textEditingController =
      TextEditingController().obs;
  RxString keyWord = "".obs;
  RxString selectValue = "All time".obs;
  RxString selectStatusValue = "Waiting".obs;
  final Map<String, Map<String, dynamic>> timeFrame = {
    'All time': {},
    '3 days': {
      'startDate':
          DateTime.now().subtract(const Duration(days: 3)).millisecondsSinceEpoch,
      'endDate': DateTime.now().add(const Duration(days: 3)).millisecondsSinceEpoch,
    },
    '1 week': {
      'startDate':
          DateTime.now().subtract(const Duration(days: 7)).millisecondsSinceEpoch,
      'endDate': DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch,
    },
    '1 month': {
      'startDate':
          DateTime.now().subtract(const Duration(days: 30)).millisecondsSinceEpoch,
      'endDate': DateTime.now().add(const Duration(days: 30)).millisecondsSinceEpoch,
    },
  };
  onSelectChanged(value) {
    selectValue.value = value;
    searchData.addAll(timeFrame[value]!);
    if (value == "All time") {
      searchData.remove("startDate");
      searchData.remove("endDate");
    }
    myController.initializationJobViewList(filterData: searchData);
  }

  final Map<String, Map<String, dynamic>> statusSelect = {
    'All status': {"status": null},
    'Waiting': {"status": 1},
    'Completed': {"status": 4},
  };
  onSelectStatusChanged(value) {
    selectStatusValue.value = value;
    searchData.addAll(statusSelect[value]!);
    myController.initializationJobViewList(filterData: searchData);
  }

  onSearchChange(value) {
    keyWord.value = value;
  }

  keyWordFilter() {
    print(keyWord.value);
    if (keyWord.value != "") {
      searchData['keyWord'] = keyWord.value;
    } else {
      searchData.remove("keyWord");
    }
    myController.initializationJobViewList(filterData: searchData);
  }

  clearFilter() {
    selectValue.value = "All time";
    selectStatusValue.value = "Waiting";
    keyWord.value = "";
    textEditingController.value.text = "";
    searchData.value = {};
    myController.initializationJobViewList();
  }

  @override
  void onInit() {
    super.onInit();
    myController.initializationJobViewList(filterData: searchData);
  }



  void increment() => count.value++;
}
