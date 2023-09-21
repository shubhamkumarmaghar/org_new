import 'package:get/get.dart';

import '../controllers/transction_info_controller.dart';

class VisitInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransctionReportController>(
      () => TransctionReportController(),
    );
  }
}
