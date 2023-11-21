import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../org_join_party_details/view/join_party_details.dart';
import '../controllers/book_party_list_controller.dart';
import '../model/book_party_list_model.dart';


class BookPartyListView extends StatelessWidget {
  const BookPartyListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(
        shape: Border(
          bottom: BorderSide(color: const Color(0xFFc4c4c4), width: 1.sp),
        ),
        backgroundColor: Colors.red.shade900,
        // Set the background color to transparent
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 18.sp),
          alignment: Alignment.centerLeft,
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Get.back();
          },
          iconSize: 12.sp,
        ),
        titleSpacing: 0,
        elevation: 0,
        title: Text(
          'Party Booking History',
          style: TextStyle(color: Colors.white, fontSize: 12.sp),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink, Colors.red.shade900],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          /*  Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
              child: Container(
                padding: EdgeInsets.all(5.sp),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                child: Text(
                  'Blocked Users',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),  */
            Container(height: Get.height*0.85,child:
            GetBuilder<BookPartyListController>(
              init: BookPartyListController(),
              builder: (controller) {
                return BookingPartyReport(dataList:controller.partyBookingModel.data ??[]);
              },
            ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingPartyReport extends StatelessWidget {
  BookingPartyReport({
    required this.dataList,
    //required this.blockUnblock
  });

  final List<SingleTicketData> dataList;

  //final Function blockUnblock;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       Row(
         children: [Container(margin: EdgeInsets.only(left: 20,top: 10),
         child: Text('Total Tickets : ${dataList.length}',style: TextStyle(fontSize: 16,
             color: Colors.black,
             fontWeight: FontWeight.w600),
         ),
       ),],),
        ListView.builder(shrinkWrap: true,
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            SingleTicketData data = dataList[index];
            return  GestureDetector(
              onTap: (){
                 Get.to(JoinPartyDetails(),arguments: data.pjId);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                margin: EdgeInsets.symmetric(
                  vertical: 10,horizontal: 10
                ),
                decoration: BoxDecoration(
                // color: data.paymentStatus =='1' ?Colors.red.shade900:Colors.grey.shade500,
              //    border: Border.all(color: data.paymentStatus =='1' ?Colors.red.shade900:Colors.grey.shade500),
                  borderRadius: BorderRadius.circular(2.w),
                /*    gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      /*    Color(0xfff2d5f7),
                          Color(0xffe6acef),
                          Color(0xffd982e6),
                          Color(0xffcd59de),
                          Color(0xffc02fd6),*/

                      /*  Color(0xffd1dce6),
                          Color(0xffa2bace),
                          Color(0xff7497b5),
                          Color(0xff45759d),
                          Color(0xff175284),
*/
                      Color(0xffee216c),
                      Color(0xffee216c),
                      Color(0xffee216c),
                      Color(0xfff14d89),
                      Color(0xfff57aa7),
                      Color(0xfff8a6c4),
                      Color(0xfffcd3e2),
                      // Colors.red.shade800,
                      //Colors.red.shade700,
                      //Colors.red.shade500,
                      // Colors.red.shade400,
                      // Colors.red.shade300,
                      // Colors.black45,
                      //Colors.black54,
                      //   Colors.black87,
                      // Colors.black,
                    ]

                ),
*/
                ),
                child: FittedBox(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // color: Colors.white,
                      boxShadow: [
                        const BoxShadow(
                          color: Color.fromARGB(255, 110, 19, 9),
                          blurRadius: 10,
                          spreadRadius: 3,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(margin: EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: Get.width*0.5,
                                child: Text(
                                  '${data.title.toString().capitalizeFirst}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: const Color(0xFF3c0103),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0.sp,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Username : ${data.fullName}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: const Color(0xFF3c0103),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 10.0.sp,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Created On :  ${dateConvert('${data.createdAt}')}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: const Color(0xFF3c0103),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 9.0.sp,
                                ),
                              ),
                              const SizedBox(height: 10.0),

                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    color: const Color(0xFF3c0103),
                                    size: 13.sp,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.015,
                                  ),
                                  Text(
                                    "${dateConvert('${data.startDate}').split(',')[0]} ${data.startTime}\n${dateConvert('${data.endDate}').split(',')[0]} ${data.endTime}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: MediaQuery.of(context).size.height * 0.12,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            child: Image.network(
                              '${data.coverPhoto}',
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
           /*   Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(15.sp),
                  child: Row(
                    children: [
                      Text(
                         'Transaction Date : ${data.planStartDate}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF434343),
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                   /*   CircleAvatar(
                        radius: 16.sp,
                       // backgroundImage: NetworkImage(data.profilePicture??'https://firebasestorage.googleapis.com/v0/b/party-people-52b16.appspot.com/o/2-2-india-flag-png-clipart.png?alt=media&token=d1268e95-cfa5-4622-9194-1d9d5486bf54'),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 3.sp,
                              child: CircleAvatar(
                                radius: 6.sp,
                                backgroundImage:
                                const NetworkImage("https://firebasestorage.googleapis.com/v0/b/party-people-52b16.appspot.com/o/2-2-india-flag-png-clipart.png?alt=media&token=d1268e95-cfa5-4622-9194-1d9d5486bf54"),
                                //const AssetImage('assets/images/indian_flag.png'),
                              ),
                            ),
                          ],
                        ),
                      ),*/
                   //   SizedBox(width: 12.sp),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      /*    Text(
                           // data.username ??'',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF434343),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                          //  data.date ??'',
                          style: TextStyle(
                            fontSize: 8.sp,
                            color: const Color(0xFF434343),
                          ),
                        ),
                       Text(
                          "profilepic",
                          style: TextStyle(
                              fontSize: 8.sp, color: const Color(0xFFc4c4c4)),
                        ),
                        */
                        ],
                      ),
                    ],
                  ),

                ), Text(
                  'Validity : ${data.planStartDate} to ${data.planEndDate}',
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: const Color(0xFF434343),
                  ),
                ),
                Text(
                  'Type : ${data.name} ',
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: const Color(0xFF434343),
                  ),
                ),
                Container(
                  color: const Color(0xFFc4c4c4),
                  height: 0.4.sp,
                  width: MediaQuery.of(context).size.width * 0.73,
                ),
              ],
            );*/

          },),
      ],
    );
  }

String dateConvert(String date){
  String dateTime;
    if(date.isNotEmpty) {
      DateTime datee = DateTime.parse(date);
      dateTime = DateFormat('dd-MM-yyyy, h:mm a').format(datee);
    }
    else{
      dateTime='NA';
    }
   return dateTime;
}


}
