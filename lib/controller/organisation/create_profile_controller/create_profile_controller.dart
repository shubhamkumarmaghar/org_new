import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:partypeoplebusiness/constants/const_strings.dart';
import 'package:partypeoplebusiness/controller/organisation/create_profile_controller/select_photo_options_screen.dart';
import 'package:partypeoplebusiness/views/organization/dashboard/organisation_dashboard.dart';

class CreteOrganisationProfileController extends GetxController {
  //TODO: Implement AddOrganizationsEventController
  RxBool isLoading = false.obs;
  final description = TextEditingController();
  final fullAddress = TextEditingController();
  final name = TextEditingController();
  final branches = TextEditingController();
  RxString timeline = ''.obs;
  RxString profile = ''.obs;
  var county = ''.obs;
  RxString organisationID = ''.obs;
  var state = ''.obs;
  var city = ''.obs;
  RxList selectedAmenitiesListID = [].obs;

  Future<String?> savePhotoToFirebase(
      String tokenId, File photo, String imageName) async {
    isLoading.value = true;
    try {
      await FirebaseAuth.instance.signInAnonymously();

      // Initialize Firebase Storage
      FirebaseStorage storage = FirebaseStorage.instance;

      // Create a reference to the photo in Firebase Storage
      Reference photoRef =
          storage.ref().child('$tokenId/organization/$imageName.jpg');

      // Upload the photo to Firebase Storage
      await photoRef.putFile(photo);

      // Get the download URL for the photo
      String downloadURL = await photoRef.getDownloadURL();

      isLoading.value = false;

      return downloadURL;
    } catch (e) {
      return null;
    }
  }

  _pickImageTimeLine(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);

      savePhotoToFirebase('${GetStorage().read('token')}', img!, 'timeLine')
          .then((value) {
        timeline.value = value!;
        isLoading.value = false;
      });

      Get.back();
    } on PlatformException {
      Get.back();
    }
  }

  _pickImageProfile(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source,imageQuality: 50);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);

      isLoading.value = true;
      savePhotoToFirebase('${GetStorage().read('token')}', img!, 'profileImage')
          .then((value) {
        profile.value = value!;
      });
      Get.back();
    } on PlatformException {
      Get.back();
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  void showSelectPhotoOptionsTimeline(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsScreen(
                onTap: _pickImageTimeLine,
              ),
            );
          }),
    );
  }

  void showSelectPhotoOptionsProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsScreen(
                onTap: _pickImageProfile,
              ),
            );
          }),
    );
  }

  var jsonAddAmenitiesData;
  List<MultiSelectCard> ameList = [];

  Future<void> newAmenities() async {
    isLoading.value = true;

    // Get organization details
    final organizationResponse = await http.post(
      Uri.parse('https://app.partypeople.in/v1/party/organization_details'),
      headers: {
        'x-access-token': '${GetStorage().read('token')}',
      },
    );
    final organizationData = await jsonDecode(organizationResponse.body)['data']
        [0]['organization_amenities'];

    // Add amenities from organizationData to selectedAmenitiesListID and ameList
    for (final amenityData in organizationData) {
      final amenityId = amenityData['id'];
      if (!selectedAmenitiesListID.contains(amenityId)) {
        selectedAmenitiesListID.add(amenityId);
      }
      if (!ameList.any((ameItem) => ameItem.value == amenityId)) {
        ameList.add(
          MultiSelectCard(
            value: amenityId,
            enabled: true,
            selected: true,
            label: amenityData['name'],
          ),
        );
      }
    }

    isLoading.value = false;
  }

  RxBool editingOrg = false.obs;

  Future<void> getAmenities() async {
    // Get organization details
    if (editingOrg.value == true) {
      await newAmenities();
    }

    print("Token From Shared Preference :=> '${GetStorage().read('token')}");
    // Get all amenities
    final amenitiesResponse = await http.get(
      Uri.parse('https://app.partypeople.in/v1/party/organization_amenities'),
      headers: {
        'x-access-token': '${GetStorage().read('token')}',
      },
    );
    final amenitiesData = await jsonDecode(amenitiesResponse.body)['data'];

    // Add amenities from amenitiesData to ameList
    for (final amenityData in amenitiesData) {
      final amenityId = amenityData['id'];
      if (!ameList.any((ameItem) => ameItem.value == amenityId)) {
        ameList.add(
          MultiSelectCard(
            value: amenityId,
            label: amenityData['name'],
          ),
        );
      }
    }

    isLoading.value = false;
    print('Checking amenities bool ::: ${editingOrg.value}');
  }

  Future<void> addOrganization() async {
    isLoading.value = true;
    var headers = {
      'x-access-token': '${GetStorage().read('token')}',
      // 'Cookie': 'ci_session=53748e98d26cf6811eb0a53be37158bf0cbe5b4b'
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse('${apiUrlString}party/add_organization'));
    request.fields.addAll({
      'organization_amenitie_id': selectedAmenitiesListID
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', ''),
      'city_id': '${fullAddress.text}, $city, $state, $county',
      'country' : county.value,
      'city' :  city.value,
      'state' : state.value,
      'description': description.text,
      'branch': branches.text == '' ? "No Branches" : branches.text,
      'name': name.text.toUpperCase(),
      'latitude': '${fullAddress.text}',
      'longitude': '${fullAddress.text}, $city, $state, $county',
      'type': '1',
      'profile_pic': '$profile',
      'timeline_pic': '$timeline',
    });

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(await response.stream.bytesToString());
      isLoading.value = false;
      if (jsonResponse['message'] == 'Organization Create Successfully.') {
        GetStorage().write('loggedIn', '1');

        Get.offAll(const OrganisationDashboard());
      } else if (jsonResponse['message'] == 'Organization Already Created.') {
        GetStorage().write('loggedIn', '1');

        Get.offAll(const OrganisationDashboard());
      }

      //jsonResponse = json.decode(await response.stream.bytesToString());
    } else {}
  }

  getAPIOverview() async {
    http.Response response = await http.post(
        Uri.parse('https://app.partypeople.in/v1/party/organization_details'),
        headers: {'x-access-token': '${GetStorage().read('token')}'});
    organisationID.value = jsonDecode(response.body)['data'][0]['id'];
    if (jsonDecode(response.body)['data'] != null) {
      GetStorage().write('loggedIn', '1');
      name.text = jsonDecode(response.body)['data'][0]['name'];
      branches.text = jsonDecode(response.body)['data'][0]['branch'] ?? '';
      description.text = jsonDecode(response.body)['data'][0]['description'];
      fullAddress.text = jsonDecode(response.body)['data'][0]['latitude'];
      timeline.value =
          "${jsonDecode(response.body)['data'][0]['timeline_pic']}";
      profile.value = "${jsonDecode(response.body)['data'][0]['profile_pic']}";
      update();
      refresh();
    }

    update();
    refresh();
  }

  Future<void> updateOrganisation() async {
    isLoading.value = true;

    var headers = {'x-access-token': '${GetStorage().read('token')}'};

    var request = http.MultipartRequest('POST',
        Uri.parse('https://app.partypeople.in/v1/party/update_organization'));
    request.fields.addAll({
      'organization_amenitie_id': selectedAmenitiesListID
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', ''),
      'city_id': '${fullAddress.text}',
      'country' : county.value,
      'city' :  city.value,
      'state' : state.value,
      'description': description.text,
      'branch': branches.text,
      'name': name.text.toUpperCase(),
      'latitude': '${fullAddress.text}, $city, $state, $county',
      'longitude': '${fullAddress.text}, $city, $state, $county',
      'organization_id': organisationID.value,
      'type': '1',
      'profile_pic': profile.value,
      'timeline_pic': timeline.value,
    });
    try {
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(await response.stream.bytesToString());
        if (jsonResponse['message'] == 'Organization Update Successfully.') {
          Get.offAll(const OrganisationDashboard());
        }
      } else {
        Get.offAll(const OrganisationDashboard());
      }
    } catch (e) {
      // handle the error here
    }

    isLoading.value = false;
    update();
  }
}
