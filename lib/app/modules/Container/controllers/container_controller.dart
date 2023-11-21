import 'package:get/get.dart';
import '../../../api/wrecker.dart';
import 'package:flutter/material.dart';
import '../templete/container_card.dart';

class ContainerController extends GetxController {
  //TODO: Implement ContainerController
  RxInt currentPage = 1.obs;
  RxInt totalPage = 1.obs;
  RxList containerList = [].obs;
  RxBool canLoadMore = false.obs;
  var text = 'aaaa'.obs;
  ScrollController listScrollController = ScrollController();
  void scrollListener() {
    listScrollController.addListener(() {
      if (listScrollController.position.pixels ==
          listScrollController.position.maxScrollExtent) {
        // 执行加载更多的操作
        handleToLoadMore();
      }
    });
  }

  @override
  void onInit() async {
    super.onInit();
    await toRefresh();
    scrollListener();
  }

  RxList<Widget> initListView() {
    RxList<Widget> list = RxList<Widget>();
    containerList.forEach((value) {
      list.addAll([
        InkWell(
            child: ContainerCard(
              containerNumber: value['containerNumber'] ?? '----',
              sealNumber: value['sealNumber'] ?? '----',
              status: value['status'] ?? 0,
              startDeliverTime: value['startDeliverTime'] ?? '----',
            ),
            onTap: () => Get.toNamed("/components",
                arguments: {"containerValue": value, "refresh": handleRefresh}))
      ]);
    });
    return list;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getContainerPage() async {
    var response =
        await apiGetContainerPage({"page": currentPage.value, "size": 10});
    if (response != null && response.data['message'] == 'success') {
      totalPage.value =
          (response.data['data']['pagination']['total'] / 10).toInt() + 1;
      canLoadMore.value = currentPage.value <= totalPage.value;
      return response.data['data']['list'];
    } else {
      return [];
    }
  }

  toRefresh() async {
    var response = await getContainerPage();
    containerList.value = response;
  }

  Future<void> handleRefresh() async {
    currentPage.value = 1;
    toRefresh();
  }

  Future<void> handleToLoadMore() async {
    if (!canLoadMore.value) {
      return;
    }
    currentPage.value = currentPage.value + 1;

    var response = await getContainerPage();
    containerList.value.addAll(response);
    containerList.refresh();
  }
}
