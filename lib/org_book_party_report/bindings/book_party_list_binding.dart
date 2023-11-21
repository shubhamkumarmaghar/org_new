import 'package:get/get.dart';

import '../controllers/book_party_list_controller.dart';

class BookingLIstInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookPartyListController>(
      () => BookPartyListController(),
    );
  }
}
