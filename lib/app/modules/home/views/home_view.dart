import 'package:flutter/material.dart';
import '../../../services/screen_adapter.dart';
import 'package:get/get.dart';
import '../../../services/keep_alive_wrapper.dart';
import '../controllers/home_controller.dart';
import '../../../templete/scheduling.dart';
import '../../../services/handle_status.dart';
import '../../../services/format_date.dart';
import '../../../widget/no_login.dart';
import '../../../color/colors.dart';
import '../../../widget/license_plate.dart';
import '../../../widget/loading.dart';
import '../../scheduling/views/scheduling_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  Widget _NoLogin() {
    return Column(
      children: [
        SizedBox(
          height: ScreenAdapter.height(230),
        ),
        NoLogin(),
        Text("You haven't signed yet"),
        TextButton(
          child: Text("To login"),
          onPressed: () {
            Get.toNamed("/pass_login");
          },
        )
      ],
    );
  }

  Widget _appBar() {
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      child: Container(
          height: ScreenAdapter.height(383),
          decoration: BoxDecoration(
            color: AppColors.logoBgc,
            image: DecorationImage(
              image: AssetImage('assets/images/top_bar_bgk.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                top: ScreenAdapter.height(121), left: ScreenAdapter.height(66)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Apexpoint',
                  style: TextStyle(fontSize: ScreenAdapter.fontSize(63)),
                ),
                SizedBox(
                  height: ScreenAdapter.height(6),
                ),
                Text(
                  'CASH-FOR-CARS',
                  style: TextStyle(fontSize: ScreenAdapter.fontSize(40)),
                ),
              ],
            ),
          )
          // centerTitle: true,
          // elevation: 0,
          // backgroundColor: Colors.transparent,
          ),
    );
  }

  Widget _HomeContent() {
    return ListView(
      // physics : AlwaysScrollableScrollPhysics(),
      controller: controller.scrollController,
      children: [
        SizedBox(
          // height: ScreenAdapter.height(800),
          child: Stack(
            children: [
              // Container(
              //   height: ScreenAdapter.height(450),
              //   width: ScreenAdapter.width(1080),
              //   decoration: const BoxDecoration(
              //     borderRadius: BorderRadius.only(
              //       bottomLeft: Radius.circular(20),
              //       bottomRight: Radius.circular(20),
              //     ),
              //     color: AppColors.darkBlueColor,
              //   ),
              // ),
              // _currentTask(),
              Container(
                margin: EdgeInsets.only(top: ScreenAdapter.height(185)),
                height: ScreenAdapter.height(1975),
                width: ScreenAdapter.width(1080),
                child: TableComplexExample(refresh: controller.handleRefresh),
              ),
              controller.changFlag.value ? Text("") : Text("")
            ],
          ),
        ),
        // TableComplexExample()
      ],
    );
  }

  Widget _currentTask() {
    List jobList = controller.myController.jobsList.value;
    return Positioned(
        left: 0,
        top: ScreenAdapter.height(200),
        right: 0,
        child: Container(
            padding: EdgeInsets.fromLTRB(
                ScreenAdapter.width(40), 0, ScreenAdapter.width(40), 0),
            child: Opacity(
                opacity: 1,
                child: LicensePlate(
                  widget: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                                height: ScreenAdapter.height(192),
                                width: ScreenAdapter.width(860),
                                // color: Colors.blue.withOpacity(_opacity),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      ScreenAdapter.width(25)),
                                  // gradient: const LinearGradient(
                                  //   begin: Alignment.topLeft,
                                  //   end: Alignment.bottomRight,
                                  //   colors: [
                                  //     Color.fromRGBO(240, 115, 49, 1),
                                  //     Colors.red
                                  //   ],
                                  // ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: ScreenAdapter.width(44),
                                          right: ScreenAdapter.width(44)),
                                      alignment: Alignment.centerLeft,
                                      height: ScreenAdapter.height(96),
                                      decoration: const BoxDecoration(
                                          // border: Border(
                                          //   bottom: BorderSide(
                                          //     color: AppColors.darkBlueColor,
                                          //     width: 1,
                                          //   ),
                                          // ),
                                          ),
                                      child: Text(
                                        "${jobList.isNotEmpty ? jobList[0]['pickupAddress'] : "Waiting"}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize:
                                                ScreenAdapter.fontSize(70),
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.logoTxtc),
                                        overflow: TextOverflow.ellipsis,
                                        // style: const TextStyle(color: Colors.blueGrey),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: ScreenAdapter.width(44),
                                          right: ScreenAdapter.width(44)),
                                      alignment: Alignment.centerLeft,
                                      height: ScreenAdapter.height(96),
                                      child: Text(
                                        "${jobList.isNotEmpty ? jobList[0]['name'] : ""}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize:
                                                ScreenAdapter.fontSize(55),
                                            color: AppColors.logoTxtc),
                                        overflow: TextOverflow.ellipsis,
                                        // style: const TextStyle(color: Colors.blueGrey),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                          jobList.isNotEmpty
                              ? Container(
                                  width: ScreenAdapter.width(140),
                                  alignment: Alignment.center,
                                  child: TextButton(
                                    child: Icon(Icons.arrow_right),
                                    onPressed: () {
                                      Get.toNamed("/pretreatment-detail",
                                          arguments: jobList[0]);
                                    },
                                  ))
                              : Text("")
                        ],
                      ),
                      jobList.isNotEmpty
                          ? NewJob(
                              time: jobList.isNotEmpty
                                  ? handleFormatDateDDMMYYYY(
                                      jobList[0]['schedulerStart'])
                                  : "",
                              start_position: jobList.isNotEmpty
                                  ? jobList[0]['pickupAddress']
                                  : "",
                              end_position:
                                  "Michael Wenden Aquatic Leisure Centre",
                              status: jobList.isNotEmpty
                                  ?
                                  // handleStatus(
                                  //     jobList[0]['schedulerStart'],
                                  //     jobList[0]['schedulerEnd'],
                                  //     jobList[0]['expectedDate'])
                                  handleStatus(jobList[0]['status'])
                                  : "",
                              pickupAddressState:
                                  "${jobList.isNotEmpty ? jobList[0]['pickupAddressState'] : ""}",
                            )
                          : NoJob()
                      // const SizedBox(height: 10,),
                    ],
                  ),
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return KeepAliveWrapper(
        child: Scaffold(
            backgroundColor: AppColors.background,
            body: Obx(
              () {
                return Stack(
                  children: [
                    _appBar(),
                    !controller.isLoading.value
                        ? (controller.userController.isLogin.value
                            ? _HomeContent()
                            : _NoLogin())
                        : Loading(),

                    // Obx(() => Visibility(
                    //       visible: controller.visiFlag.value,
                    //       child: _currentTask(),
                    //     ))
                  ],
                );
              },
            )));
  }
}

class NewJob extends StatefulWidget {
  final String time;
  final String start_position;
  final String end_position;
  final String status;
  final String pickupAddressState;
  const NewJob(
      {super.key,
      this.time = "-",
      this.end_position = "-",
      this.start_position = "-",
      this.pickupAddressState = "-",
      this.status = "-"});

  @override
  State<NewJob> createState() => _NewJobState();
}

class _NewJobState extends State<NewJob> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          ScreenAdapter.width(20),
          ScreenAdapter.height(30),
          ScreenAdapter.width(20),
          ScreenAdapter.height(20)),
      child: Column(
        children: [
          SizedBox(
            height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Time",
                  style: TextStyle(fontSize: ScreenAdapter.fontSize(50)),
                ),
                Text(
                  widget.time,
                  style: TextStyle(
                      color: AppColors.darkGreyColor,
                      fontSize: ScreenAdapter.fontSize(50)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    "Status",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: ScreenAdapter.fontSize(50)),
                  ),
                ),
                Flexible(
                  child: Text(
                    widget.status,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppColors.darkGreyColor,
                        fontSize: ScreenAdapter.fontSize(50)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    "Pickup address state",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: ScreenAdapter.fontSize(50)),
                  ),
                ),
                Flexible(
                  child: Text(
                    widget.pickupAddressState,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppColors.darkGreyColor,
                        fontSize: ScreenAdapter.fontSize(50)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NoJob extends StatefulWidget {
  const NoJob({super.key});

  @override
  State<NoJob> createState() => _NoJobState();
}

class _NoJobState extends State<NoJob> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          ScreenAdapter.width(20),
          ScreenAdapter.height(30),
          ScreenAdapter.width(20),
          ScreenAdapter.height(20)),
      child: Column(
        children: [
          SizedBox(
            height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Please wait for your first job",
                  style: TextStyle(fontSize: ScreenAdapter.fontSize(40)),
                ),
                Text(
                  "",
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: ScreenAdapter.fontSize(40)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "",
                  style: TextStyle(fontSize: ScreenAdapter.fontSize(40)),
                ),
                Text(
                  "",
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: ScreenAdapter.fontSize(40)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "",
                  style: TextStyle(fontSize: ScreenAdapter.fontSize(40)),
                ),
                Text(
                  "",
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: ScreenAdapter.fontSize(40)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
