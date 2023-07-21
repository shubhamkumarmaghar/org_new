import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:partypeoplebusiness/controller/organisation/dashboard/organization_dashboard.dart';
import 'package:partypeoplebusiness/views/login_user/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  TextStyle headingStyle = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red);

  OrganizationDashboardController organizationDashboardController = Get.find();

  deleteAccountAPICall() async {
    http.Response response = await http.post(
        Uri.parse('http://app.partypeople.in/v1/party/delete_organization'),
        headers: {
          'x-access-token': '${GetStorage().read('token')}'
        },
        body: {
          'organization_id':
              organizationDashboardController.organisationID.value
        });
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['status'] == 1) {
        Get.snackbar(
            'You\'r request for account deactivation has successfully saved',
            '',
            colorText: Colors.white);

        Get.offAll(LoginView());
        GetStorage().write('token', '');
      }
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Request"),
      onPressed: () {
        deleteAccountAPICall();
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Delete Account"),
      content: const Text("Are you sure, you want to delete your account ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  final Uri paramsForMail = Uri(
    scheme: 'mailto',
    path: 'partypeople03112022@gmail.com',
    query:
        'subject=Contact Party People&body=App Version 3.23', //add subject and body here
  );

  final Uri linkForTerms = Uri.parse('https://www.partypeople.in/');
  final Uri linkForAbout = Uri.parse('https://www.partypeople.in/');
  final Uri linkForPrivacy = Uri.parse('https://www.partypeople.in/');

  bool lockAppSwitchVal = true;
  bool like = true;
  bool partyPosted = true;
  bool postApproved = false;
  bool fingerprintSwitchVal = false;
  bool changePassSwitchVal = true;

  TextStyle headingStyleIOS = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: CupertinoColors.inactiveGray,
  );
  TextStyle descStyleIOS = const TextStyle(color: CupertinoColors.inactiveGray);

  @override
  Widget build(BuildContext context) {
    return (Platform.isAndroid)
        ? MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: Colors.redAccent,
                secondary: Colors.redAccent,
              ),
            ),
            home: Scaffold(
              appBar: AppBar(
                title: const Text("Settings"),
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Post Approval", style: headingStyle),
                        ],
                      ),
                      ListTile(
                        onTap: () {
                          showAlertDialog(context);
                        },
                        leading: const Icon(
                          Icons.account_box,
                          color: Colors.red,
                        ),
                        title: const Text(
                          "Delete Account",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Misc", style: headingStyle),
                        ],
                      ),
                      ListTile(
                        onTap: () async {
                          var url = linkForTerms.toString();
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        leading: const Icon(Icons.file_open_outlined),
                        title: const Text("Terms of Service"),
                      ),
                      const Divider(),
                      ListTile(
                        onTap: () async {
                          var url = paramsForMail.toString();
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        leading: const Icon(Icons.file_copy_outlined),
                        title: const Text("Contact Us"),
                      ),
                      const Divider(),
                      ListTile(
                        onTap: () async {
                          var url = linkForAbout.toString();
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        leading: const Icon(Icons.file_open_outlined),
                        title: const Text("About us"),
                      ),
                      const Divider(),
                      ListTile(
                        onTap: () async {
                          var url = linkForPrivacy.toString();
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        leading: const Icon(Icons.file_copy_outlined),
                        title: const Text("Privacy Policy"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : CupertinoApp(
            debugShowCheckedModeBanner: false,
            home: CupertinoPageScaffold(
              navigationBar: const CupertinoNavigationBar(
                backgroundColor: CupertinoColors.destructiveRed,
                middle: Text("Settings UI"),
              ),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: CupertinoColors.extraLightBackgroundGray,
                child: Column(
                  children: [
                    //Common
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 12),
                        Text(
                          "Common",
                          style: headingStyleIOS,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      color: CupertinoColors.white,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 38,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.language,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 12),
                                const Text("Language"),
                                const Spacer(),
                                Text(
                                  "English",
                                  style: descStyleIOS,
                                ),
                                const SizedBox(width: 5),
                                const Icon(
                                  CupertinoIcons.right_chevron,
                                  color: CupertinoColors.inactiveGray,
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                          const Divider(),
                          Container(
                            width: double.infinity,
                            height: 38,
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.cloud,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 12),
                                const Text("Environment"),
                                const Spacer(),
                                Text(
                                  "Production",
                                  style: descStyleIOS,
                                ),
                                const SizedBox(width: 5),
                                const Icon(
                                  CupertinoIcons.right_chevron,
                                  color: CupertinoColors.inactiveGray,
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Account
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 12),
                        Text(
                          "Account",
                          style: headingStyleIOS,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      color: CupertinoColors.white,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 38,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SizedBox(width: 12),
                                Icon(
                                  Icons.phone,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 12),
                                Text("Phone Number"),
                                Spacer(),
                                Icon(
                                  CupertinoIcons.right_chevron,
                                  color: CupertinoColors.inactiveGray,
                                ),
                                SizedBox(width: 8),
                              ],
                            ),
                          ),
                          const Divider(),
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 38,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SizedBox(width: 12),
                                Icon(
                                  Icons.mail,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 12),
                                Text("Email"),
                                Spacer(),
                                Icon(
                                  CupertinoIcons.right_chevron,
                                  color: CupertinoColors.inactiveGray,
                                ),
                                SizedBox(width: 8),
                              ],
                            ),
                          ),
                          const Divider(),
                          // Container(
                          //   alignment: Alignment.center,
                          //   width: double.infinity,
                          //   height: 38,
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: const [
                          //       SizedBox(width: 12),
                          //       Icon(
                          //         Icons.exit_to_app,
                          //         color: Colors.grey,
                          //       ),
                          //       SizedBox(width: 12),
                          //       Text("Sign Out"),
                          //       Spacer(),
                          //       Icon(
                          //         CupertinoIcons.right_chevron,
                          //         color: CupertinoColors.inactiveGray,
                          //       ),
                          //       SizedBox(width: 8),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    //Security
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 12),
                        Text(
                          "Security",
                          style: headingStyleIOS,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      color: CupertinoColors.white,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 38,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.phonelink_lock_outlined,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 12),
                                const Text("Lock app in Background"),
                                const Spacer(),
                                CupertinoSwitch(
                                    value: lockAppSwitchVal,
                                    activeColor: CupertinoColors.destructiveRed,
                                    onChanged: (val) {
                                      setState(() {
                                        lockAppSwitchVal = val;
                                      });
                                    }),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                          const Divider(),
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 38,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.fingerprint,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 12),
                                const Text("Use Fingerprint"),
                                const Spacer(),
                                CupertinoSwitch(
                                  value: fingerprintSwitchVal,
                                  onChanged: (val) {
                                    setState(() {
                                      fingerprintSwitchVal = val;
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                          const Divider(),
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 38,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 12),
                                const Text("Change Password"),
                                const Spacer(),
                                CupertinoSwitch(
                                  value: changePassSwitchVal,
                                  activeColor: CupertinoColors.destructiveRed,
                                  onChanged: (val) {
                                    setState(() {
                                      changePassSwitchVal = val;
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Misc
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 12),
                        Text(
                          "Misc",
                          style: headingStyleIOS,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      color: CupertinoColors.white,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 38,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SizedBox(width: 12),
                                Icon(
                                  Icons.file_open_sharp,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 12),
                                Text("Terms of Service"),
                                Spacer(),
                                Icon(
                                  CupertinoIcons.right_chevron,
                                  color: CupertinoColors.inactiveGray,
                                ),
                                SizedBox(width: 8),
                              ],
                            ),
                          ),
                          const Divider(),
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 38,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SizedBox(width: 12),
                                Icon(
                                  Icons.file_copy_sharp,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 12),
                                Text("Open Source Licenses"),
                                Spacer(),
                                Icon(
                                  CupertinoIcons.right_chevron,
                                  color: CupertinoColors.inactiveGray,
                                ),
                                SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
