import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../controller/single_ticket_details.dart';

class BookingLIstInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookSinglePartyTicketController>(
          () => BookSinglePartyTicketController(),
    );
  }
}
