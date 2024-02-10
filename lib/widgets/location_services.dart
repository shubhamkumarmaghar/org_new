import 'dart:developer';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get_storage/get_storage.dart';

class LocationService {
  static final GeolocatorPlatform _geolocatorPlatform =
      GeolocatorPlatform.instance;

  static Future<Position> getCurrentPosition() async {
    final Position position = await _geolocatorPlatform.getCurrentPosition();
    return position;
  }

  static Future<PermissionStatus> requestInitialLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    return status;
  }

  static Future<bool?> checkPermission({required BuildContext context}) async {
    PermissionStatus permissionStatus =
    await requestInitialLocationPermission();
    log(permissionStatus.toString());
    if (Platform.isAndroid) {
      if (permissionStatus.isGranted) {
        return true;
      } else if (permissionStatus.isDenied) {
        await requestInitialLocationPermission();
      } else if (permissionStatus.isPermanentlyDenied) {
        await locationPermissionDialog(context: context);
      }
    } else if (Platform.isIOS) {
      if (permissionStatus.isGranted) {
        return true;
      } else if (permissionStatus.isDenied ||
          permissionStatus.isPermanentlyDenied) {
        await locationPermissionDialog(context: context);
      }
    }

    return null;
  }
  static Future<bool?> checkPermissionForLocation() async {
    PermissionStatus permissionStatus =
    await requestInitialLocationPermission();
    log(permissionStatus.toString());
    if (Platform.isAndroid) {
      if (permissionStatus.isGranted) {
        return true;
      } else if (permissionStatus.isDenied) {
        await requestInitialLocationPermission();
      } else if (permissionStatus.isPermanentlyDenied) {
        await openAppSettings();
      }
    } else if (Platform.isIOS) {
      if (permissionStatus.isGranted) {
        return true;
      } else if (permissionStatus.isDenied ||
          permissionStatus.isPermanentlyDenied) {
        await openAppSettings();
      }
    }

    return null;
  }

  static Future<String> getCurrentPlace() async {
    Position position = await LocationService.getCurrentPosition();

    List<Placemark> placeMarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    log('Address :: '+placeMarks[0].toString());
    String currentAddress =
        '${placeMarks[0].name} ${placeMarks[0].subThoroughfare} ${placeMarks[0].thoroughfare}  ${placeMarks[0].subLocality?.replaceAll(' ', '-')}-${placeMarks[0].locality?.replaceAll(' ', '-')}-${placeMarks[0].administrativeArea?.replaceAll(' ', '-')}-${placeMarks[0].country?.replaceAll(' ', '-')}  ${placeMarks[0].postalCode} ';
    // currentAddress = '${placeMarks[0].name}  ${placeMarks[1].name}';
    return currentAddress;
  }
  static Future locationPermissionDialog({required BuildContext context}) async {
    return Platform.isAndroid
        ? await showDialog(
        barrierDismissible:false ,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Location Permission'),
          content: const Text(
              'This app needs Location Permission to detect Location.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Deny'),
              onPressed: () {
                // Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Settings'),
              onPressed: () async {
                bool isSettingOpened = await openAppSettings();
                if (isSettingOpened) Navigator.of(context).pop();
                //  Navigator.of(context).pop();
              },
            ),
          ],
        ))
        : await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Location Permission'),
          content: const Text(
              'This app needs Location Permission to detect Location.'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Deny'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Settings'),
              onPressed: () async {
                bool isSettingOpened = await openAppSettings();
                if (isSettingOpened) Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }
}
