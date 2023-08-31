import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var data;
  bool isNotification = false;

  getAllNotification() async {
    http.Response response = await http.post(
        Uri.parse(
            'https://app.partypeople.in/v1/notification/get_all_notification'),
        headers: {"x-access-token": '${GetStorage().read('token')}'});

    print(response.body);

    setState(() {
      data = jsonDecode(response.body);
      if (data['message'] == 'Notification Not Found.') {
        setState(() {
          isNotification = false;
        });
      } else {
        setState(() {
          isNotification = true;
        });
      }

      print(data['data'].length);
    });
  }

  @override
  void initState() {
    getAllNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(fontSize: 13.sp, color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
      body: data == null
          ? Center(
              child: CupertinoActivityIndicator(
                color: Colors.black,
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              itemBuilder: (BuildContext context, int index) {
                DateTime notificationCreatedOn = DateTime.parse(
                    data['data'][index]['notification_created_on']);

                String formattedDateTime = DateFormat('h:mm a, EEE, d/MM/y').
                format(notificationCreatedOn
                    //.add(Duration(hours: 5, minutes: 30)
                );

                return data['data'] != null
                    ? Container(
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.grey[800],
                              child: Icon(
                                Icons.notifications,
                                size: 22.0,
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${data['data'][index]['notification_title']}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontFamily: 'malgun',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    SizedBox(height: 5.0),
                                    Text(
                                      '${data['data'][index]['notification_message']}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontFamily: 'malgun',
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    SizedBox(height: 5.0),
                                    Text(
                                      '$formattedDateTime',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontFamily: 'malgun',
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container();
              },
              separatorBuilder: (BuildContext context, int index) =>
                  SizedBox(height: 16.0),
              itemCount: data['data'].length,
            ),
    );
  }
}
