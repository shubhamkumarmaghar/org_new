class partyDataModel {
  int? status;
  String? message;
  List<Party>? data;

  partyDataModel({this.status, this.message, this.data});

  partyDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Party>[];
      json['data'].forEach((v) {
        data!.add(new Party.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Party {
  String? id;
  String? userId;
  dynamic userType;
  String? phoneNumber;
  String? organizationId;
  String? title;
  String? description;
  String? coverPhoto;
  String? imageB;
  String? imageC;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? prStartDate;
  String? prEndDate;
  String? latitude;
  String? longitude;
  String? country;
  String? state;
  String? city;
  String? type;
  String? pincode;
  String? gender;
  String? startAge;
  String? endAge;
  String? personLimit;
  String? status;
  String? active;
  String? createdAt;
  String? updatedAt;
  String? isDeleted;
  String? like;
  String? others;
  String? view;
  String? ongoing;
  String? offers;
  String? ladies;
  String? stag;
  String? couples;
  String? papularStatus;
  String? papularTime;
  String? subscriotionType;
  String? partyAmenitieId;
  String? imageStatus;
  String? approvalStatus;
  String? organization;
  dynamic fullName;
  dynamic profilePicture;
  String?  discountType;
  String?  discountAmount;
  String?  billMaxAmount;
  String?  discountDescription;
  List<PartyAmenitie>? partyAmenitie;

  Party(
      {this.id,
        this.userId,
        this.userType,
        this.phoneNumber,
        this.organizationId,
        this.title,
        this.description,
        this.coverPhoto,
        this.imageB,
        this.imageC,
        this.startDate,
        this.endDate,
        this.startTime,
        this.endTime,
        this.prStartDate,
        this.prEndDate,
        this.latitude,
        this.longitude,
        this.country,
        this.state,
        this.city,
        this.type,
        this.pincode,
        this.gender,
        this.startAge,
        this.endAge,
        this.personLimit,
        this.status,
        this.active,
        this.createdAt,
        this.updatedAt,
        this.isDeleted,
        this.like,
        this.others,
        this.view,
        this.ongoing,
        this.offers,
        this.ladies,
        this.stag,
        this.couples,
        this.papularStatus,
        this.papularTime,
        this.subscriotionType,
        this.partyAmenitieId,
        this.imageStatus,
        this.approvalStatus,
        this.organization,
        this.fullName,
        this.profilePicture,
        this.discountDescription,
        this.discountAmount,
        this.billMaxAmount,
        this.discountType,
        this.partyAmenitie});

  Party.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userType = json['user_type'];
    phoneNumber = json['phone_number'];
    organizationId = json['organization_id'];
    title = json['title'];
    description = json['description'];
    coverPhoto = json['cover_photo'];
    imageB = json['image_b'];
    imageC = json['image_c'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    prStartDate = json['pr_start_date'];
    prEndDate = json['pr_end_date'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    type = json['type'];
    pincode = json['pincode'];
    gender = json['gender'];
    startAge = json['start_age'];
    endAge = json['end_age'];
    personLimit = json['person_limit'];
    status = json['status'];
    active = json['active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isDeleted = json['is_deleted'];
    like = json['like'];
    others = json['others'];
    view = json['view'];
    ongoing = json['ongoing'];
    offers = json['offers'];
    ladies = json['ladies'];
    stag = json['stag'];
    couples = json['couples'];
    papularStatus = json['papular_status'];
    papularTime = json['papular_time'];
    subscriotionType = json['subscriotion_type'];
    partyAmenitieId = json['party_amenitie_id'];
    imageStatus = json['image_status'];
    approvalStatus = json['approval_status'];
    organization = json['organization'];
    fullName = json['full_name'];
    profilePicture = json['profile_picture'];
    discountAmount =json['discount_amount'];
    discountDescription= json['discount_description'];
    discountType= json['discount_type'];
    billMaxAmount= json['bill_amount'];

    if (json['party_amenitie'] != null) {
      partyAmenitie = <PartyAmenitie>[];
      json['party_amenitie'].forEach((v) {
        partyAmenitie!.add(new PartyAmenitie.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['user_type'] = this.userType;
    data['phone_number'] = this.phoneNumber;
    data['organization_id'] = this.organizationId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['cover_photo'] = this.coverPhoto;
    data['image_b'] = this.imageB;
    data['image_c'] = this.imageC;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['pr_start_date'] = this.prStartDate;
    data['pr_end_date'] = this.prEndDate;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['type'] = this.type;
    data['pincode'] = this.pincode;
    data['gender'] = this.gender;
    data['start_age'] = this.startAge;
    data['end_age'] = this.endAge;
    data['person_limit'] = this.personLimit;
    data['status'] = this.status;
    data['active'] = this.active;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_deleted'] = this.isDeleted;
    data['like'] = this.like;
    data['others'] = this.others;
    data['view'] = this.view;
    data['ongoing'] = this.ongoing;
    data['offers'] = this.offers;
    data['ladies'] = this.ladies;
    data['stag'] = this.stag;
    data['couples'] = this.couples;
    data['papular_status'] = this.papularStatus;
    data['papular_time'] = this.papularTime;
    data['subscriotion_type'] = this.subscriotionType;
    data['party_amenitie_id'] = this.partyAmenitieId;
    data['image_status'] = this.imageStatus;
    data['approval_status'] = this.approvalStatus;
    data['organization'] = this.organization;
    data['full_name'] = this.fullName;
    data['discount_type'] = this.discountType;
    data['discount_amount'] = this.discountAmount;
    data['bill_amount'] = this.billMaxAmount;
    data['discount_description'] = this.discountDescription;

    data['profile_picture'] = this.profilePicture;
    if (this.partyAmenitie != null) {
      data['party_amenitie'] =
          this.partyAmenitie!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PartyAmenitie {
  String? id;
  String? name;

  PartyAmenitie({this.id, this.name});

  PartyAmenitie.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}