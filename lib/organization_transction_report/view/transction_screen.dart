
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../controllers/transction_info_controller.dart';
import '../model/transction_info_model.dart';


class TransctionReportedUsersView extends StatelessWidget {
  const TransctionReportedUsersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transaction History',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red.shade900,
        elevation: 0,
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
            GetBuilder<TransctionReportController>(
              init: TransctionReportController(),
              builder: (controller) {
                return TransctionReport(dataList:controller.transctionModel.data ??[]);
              },),),
           /* Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return BlockedReportedUserItem(
                    userName: 'Blocked User $index',
                    reason: 'Blocked Reason $index',
                    isBlocked: true,
                  );
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
              child: Container(
                padding: EdgeInsets.all(5.sp),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                child: Text(
                  'Reported Users',
                  style: TextStyle(
                    fontSize: 14.sp,
                    //fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
           */
           /* Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return BlockedReportedUserItem(
                    userName: 'Reported User $index',
                    reason: 'Reported Reason $index',
                    isBlocked: false,
                  );
                },
              ),
            ), */
          ],
        ),
      ),
    );
  }
}

class TransctionReport extends StatelessWidget {
 // APIService apiService = APIService();
  TransctionReport({
    required this.dataList,
    //required this.blockUnblock
  });

  final List<Data> dataList;

  //final Function blockUnblock;


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        Data data = dataList[index];
        return  Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          margin: EdgeInsets.symmetric(
            vertical: 10,horizontal: 10
          ),
          decoration: BoxDecoration(
           color: data.paymentStatus =='1' ?Colors.red.shade900:Colors.grey.shade500,
            border: Border.all(color: data.paymentStatus =='1' ?Colors.red.shade900:Colors.grey.shade500),
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Party Name : ${data.name} ',
                            style:
                            TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400,color: Colors.white),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            children: [
                              Text(
                                'Validity Start : ',
                                style: TextStyle(fontSize: 10.sp,color:Colors.white),
                              ),
                             Text(
                               dateConvert(data.planStartDate),
                                style: TextStyle(
                                    fontSize: 11.sp, fontWeight: FontWeight.w500,color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            children: [
                              Text(
                                'Validity End: ',
                                style: TextStyle(fontSize: 10.sp,color:Colors.white),
                              ),
                              Text(dateConvert(data.planEndDate)
                                ,
                                style: TextStyle(
                                    fontSize: 11.sp, fontWeight: FontWeight.w500,color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            children: [
                              Text(
                                'Transaction ID  :  ',
                                style: TextStyle(fontSize: 10.sp,color:Colors.white),
                              ),
                              Text(
                                '${data.orderId}',
                                style: TextStyle(
                                    fontSize: 11.sp, fontWeight: FontWeight.w500,color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),

                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 25.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                     /*   Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.currency_rupee,
                              size: 2.5.h,
                            ),
                            Flexible(
                              child: Text(
                                'Plan',
                                style: TextStyle(
                                    fontSize: 14.sp, fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                          ],
                        ),*/
                       SizedBox(
                          height: 0.5.h,
                        ),
                        Text(
                          '₹${data.amount}',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: data.paymentStatus == '3'
                                  ? Colors.red
                                  : Colors.green),
                        ),
                        Image.network(data.paymentStatus =='3' ? 'https://firebasestorage.googleapis.com/v0/b/party-people-52b16.appspot.com/o/default_images%2Ffailed.png?alt=media&token=ceec68a2-0ff4-4bd1-9d7c-93f9e3bb07be':
                        'https://firebasestorage.googleapis.com/v0/b/party-people-52b16.appspot.com/o/default_images%2Fsuccess.png?alt=media&token=67e29649-23fd-4b2d-8961-bffeaeda5495',
                            height: Get.width*0.2,
                            width: Get.width*0.2,)
                      ],
                    ),
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible:data.paymentStatus !='3' ,
                    child: Container(child: Row(children: [Text(
                      'Current Status : ',
                      style: TextStyle(fontSize: 10.sp,color: Colors.white),
                    ),
                      Text( data.planExpiredStatus == 'No' ?'Active' : 'Expired',
                        style: TextStyle(
                            fontSize: 11.sp, fontWeight: FontWeight.w500,color:Colors.white),
                      ),]),),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Text(
                          'Payment Status : ',
                          style: TextStyle(fontSize: 10.sp,color:Colors.white),
                        ),
                        Text( data.paymentStatus =='1' ? 'Success' :'Failed',
                          style: TextStyle(
                              fontSize: 11.sp, fontWeight: FontWeight.w500,color:Colors.white),
                        ),
                      ],
                    ),
                  ),

                ],
              ),

            ],
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

      },);
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
