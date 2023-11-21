import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:partypeoplebusiness/views/login_user/login_screen.dart';

import '../../views/login_user/user_country_type.dart';

class OnBoardingController extends GetxController {
  final pageCount = 0.obs;

  @override
  void onClose() {}

  void increment() {
    if (pageCount < 2) {
      pageCount.value++;
    } else {
      GetStorage().write('onboarding', '1');
      Get.to(SelectUserCountry());
      //Get.to(LoginView());
    }
  }

  void decrement() {
    if (pageCount > 0) {
      pageCount.value--;
    }
  }
}
