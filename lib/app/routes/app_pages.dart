import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../modules/ComponentDetail/bindings/component_detail_binding.dart';
import '../modules/ComponentDetail/views/component_detail_view.dart';
import '../modules/Components/views/components_view.dart';
import '../modules/Container/views/container_view.dart';
import '../modules/NoRole/bindings/no_role_binding.dart';
import '../modules/NoRole/views/no_role_view.dart';
import '../modules/Wrecking/views/wrecking_view.dart';
import '../modules/completed/bindings/completed_binding.dart';
import '../modules/completed/views/completed_view.dart';
import '../modules/containerDetail/bindings/container_detail_binding.dart';
import '../modules/containerDetail/views/container_detail_view.dart';
import '../modules/dismantlers/bindings/dismantlers_binding.dart';
import '../modules/dismantlers/views/dismantlers_view.dart';
import '../modules/dismantlers_stats/bindings/dismantlers_stats_binding.dart';
import '../modules/dismantlers_stats/views/dismantlers_stats_view.dart';
import '../modules/generate_signature/bindings/generate_signature_binding.dart';
import '../modules/generate_signature/views/generate_signature_view.dart';
import '../modules/have_in_hand/bindings/have_in_hand_binding.dart';
import '../modules/have_in_hand/views/have_in_hand_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/job_details/bindings/job_details_binding.dart';
import '../modules/job_details/views/job_details_view.dart';
import '../modules/passLogin/bindings/pass_login_binding.dart';
import '../modules/passLogin/views/pass_login_view.dart';
import '../modules/personal_center/bindings/personal_center_binding.dart';
import '../modules/personal_center/views/personal_center_view.dart';
import '../modules/pretreatment/bindings/pretreatment_binding.dart';
import '../modules/pretreatment/views/pretreatment_view.dart';
import '../modules/pretreatment_detail/bindings/pretreatment_detail_binding.dart';
import '../modules/pretreatment_detail/views/pretreatment_detail_view.dart';
import '../modules/scheduling/bindings/scheduling_binding.dart';
import '../modules/scheduling/views/scheduling_view.dart';
import '../modules/submit_taskinfo/bindings/submit_taskinfo_binding.dart';
import '../modules/submit_taskinfo/views/submit_taskinfo_view.dart';
import '../modules/tabs/bindings/tabs_binding.dart';
import '../modules/tabs/views/tabs_view.dart';
import '../modules/task_info_finish/bindings/task_info_finish_binding.dart';
import '../modules/task_info_finish/views/task_info_finish_view.dart';
import '../modules/task_list/views/task_list_view.dart';
import '../modules/trailer_info/bindings/trailer_info_binding.dart';
import '../modules/trailer_info/views/trailer_info_view.dart';
import '../modules/unaccomplished/bindings/unaccomplished_binding.dart';
import '../modules/unaccomplished/views/unaccomplished_view.dart';
import '../modules/user/controllers/user_controller.dart';
import '../modules/user/views/user_view.dart';

// import '../modules/Components/bindings/components_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.TABS;

  static final routes = [
    GetPage(
        name: _Paths.TABS,
        page: () => const TabsView(),
        binding: TabsBinding(),
        middlewares: middlewares),
    GetPage(
        name: _Paths.PassLogin,
        page: () => const PassLoginView(),
        binding: PassLoginBinding(),
        middlewares: middlewares),
    GetPage(
        name: _Paths.HAVE_IN_HAND,
        page: () => HaveInHandView(),
        binding: HaveInHandBinding(),
        middlewares: middlewares),
    GetPage(
        name: _Paths.PRETREATMENT,
        page: () => const PretreatmentView(),
        binding: PretreatmentBinding(),
        middlewares: middlewares),
    GetPage(
        name: _Paths.COMPLETED,
        page: () => CompletedView(),
        binding: CompletedBinding(),
        middlewares: middlewares),
    GetPage(
        name: _Paths.UNACCOMPLISHED,
        page: () => const UnaccomplishedView(),
        binding: UnaccomplishedBinding(),
        middlewares: middlewares),
    GetPage(
        name: _Paths.TRAILER_INFO,
        page: () => TrailerInfoView(
              arguments: Get.arguments,
            ),
        binding: TrailerInfoBinding(),
        middlewares: middlewares),
    GetPage(
        name: _Paths.GENERATE_SIGNATURE,
        page: () => const GenerateSignatureView(),
        binding: GenerateSignatureBinding(),
        middlewares: middlewares),
    GetPage(
        name: _Paths.PRETREATMENT_DETAIL,
        page: () => PretreatmentDetailView(),
        binding: PretreatmentDetailBinding(),
        middlewares: middlewares),
    GetPage(
        name: _Paths.SCHEDULING,
        page: () => const SchedulingView(),
        binding: SchedulingBinding(),
        middlewares: middlewares),
    GetPage(
        name: _Paths.PERSONAL_CENTER,
        page: () => const PersonalCenterView(),
        binding: PersonalCenterBinding(),
        middlewares: middlewares),
    GetPage(
        name: _Paths.SUBMIT_TASKINFO,
        page: () => const SubmitTaskinfoView(),
        binding: SubmitTaskinfoBinding(),
        middlewares: middlewares),
    GetPage(
        name: _Paths.TASK_INFO_FINISH,
        page: () => const TaskInfoFinishView(),
        binding: TaskInfoFinishBinding(),
        middlewares: middlewares),
    GetPage(
      name: _Paths.NO_ROLE,
      page: () => const NoRoleView(),
      binding: NoRoleBinding(),
    ),
    GetPage(
      name: _Paths.CONTAINER_DETAIL,
      page: () => const ContainerDetailView(),
      binding: ContainerDetailBinding(),
    ),
    // GetPage(
    //   name: _Paths.COMPONENTS,
    //   page: () => const ComponentsView(),
    //   binding: ComponentsBinding(),
    // ),
    GetPage(
      name: _Paths.COMPONENT_DETAIL,
      page: () => const ComponentDetailView(),
      binding: ComponentDetailBinding(),
    ),
    GetPage(
      name: _Paths.JOB_DETAILS,
      page: () => const JobDetailsView(),
      binding: JobDetailsBinding(),
    ),
    // GetPage(
    //   name: _Paths.DISMANTLERS,
    //   page: () => const DismantlersView(),
    //   binding: DismantlersBinding(),
    // ),
    // GetPage(
    //   name: _Paths.DISMANTLERS_STATS,
    //   page: () => const DismantlersStatsView(),
    //   binding: DismantlersStatsBinding(),
    // ),
  ];
}

List<GetMiddleware> middlewares = [];

class AuthMiddleware extends GetMiddleware {
  UserController userController = Get.put(UserController());
  @override
  RouteSettings? redirect(String? route) {
    print("AuthMiddleware ");
    // 检查用户是否已登录，如果未登录，则重定向到登录页面。
    if (!userController.isLogin.value && route != '/pass_login') {
      return RouteSettings(name: '/pass_login');
    }
    return null;
  }
}
