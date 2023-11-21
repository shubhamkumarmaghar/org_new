class PartyBookingList {
  int? status;
  String? message;
  List<SingleTicketData>? data;

  PartyBookingList({this.status, this.message, this.data});

  PartyBookingList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SingleTicketData>[];
      json['data'].forEach((v) {
        data!.add(new SingleTicketData.fromJson(v));
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

class SingleTicketData {
  String? pjId;
  String? noOfPeople;
  String? organizationName;
  String? organizationPic;
  String? fullName;
  String? id;
  String? userId;
  String? userType;
  String? phoneNumber;
  String? organizationId;
  String? title;
  String? description;
  String? coverPhoto;
  String? imageB;
  String? imageBStatus;
  String? imageCStatus;
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
  dynamic status;
  String? active;
  String? createdAt;
  String? updatedAt;
  String? isDeleted;
  String? like;
  String? others;
  String? view;
  String? ongoing;
  String? offers;
  String? discountType;
  String? discountAmount;
  String? billAmount;
  String? discountDescription;
  String? ladies;
  String? stag;
  String? couples;
  String? papularStatus;
  String? papularTime;
  String? subscriotionType;
  String? partyAmenitieId;
  String? imageStatus;
  String? approvalStatus;
  String? qr;
  String? pjApprovalStatus;
  SingleTicketData(
      {this.pjId,
        this.noOfPeople,
        this.organizationName,
        this.organizationPic,
        this.fullName,
        this.id,
        this.userId,
        this.userType,
        this.phoneNumber,
        this.organizationId,
        this.title,
        this.description,
        this.coverPhoto,
        this.imageB,
        this.imageBStatus,
        this.imageCStatus,
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
        this.discountType,
        this.discountAmount,
        this.billAmount,
        this.discountDescription,
        this.ladies,
        this.stag,
        this.couples,
        this.papularStatus,
        this.papularTime,
        this.subscriotionType,
        this.partyAmenitieId,
        this.imageStatus,
        this.approvalStatus,
        this.qr,
        this.pjApprovalStatus
      });

  SingleTicketData.fromJson(Map<String, dynamic> json) {
    pjId = json['pj_id'];
    noOfPeople = json['no_of_people'];
    organizationName = json['organization_name'];
    organizationPic = json['organization_pic'];
    fullName = json['full_name'];
    id = json['id'];
    userId = json['user_id'];
    userType = json['user_type'];
    phoneNumber = json['phone_number'];
    organizationId = json['organization_id'];
    title = json['title'];
    description = json['description'];
    coverPhoto = json['cover_photo'];
    imageB = json['image_b'];
    imageBStatus = json['image_b_status'];
    imageCStatus = json['image_c_status'];
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
    discountType = json['discount_type'];
    discountAmount = json['discount_amount'];
    billAmount = json['bill_amount'];
    discountDescription = json['discount_description'];
    ladies = json['ladies'];
    stag = json['stag'];
    couples = json['couples'];
    papularStatus = json['papular_status'];
    papularTime = json['papular_time'];
    subscriotionType = json['subscriotion_type'];
    partyAmenitieId = json['party_amenitie_id'];
    imageStatus = json['image_status'];
    approvalStatus = json['approval_status'];
    qr = json['qr_image'];
    pjApprovalStatus = json['pj_approval_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pj_id'] = this.pjId;
    data['no_of_people'] = this.noOfPeople;
    data['organization_name'] = this.organizationName;
    data['organization_pic'] = this.organizationPic;
    data['full_name'] = this.fullName;
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['user_type'] = this.userType;
    data['phone_number'] = this.phoneNumber;
    data['organization_id'] = this.organizationId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['cover_photo'] = this.coverPhoto;
    data['image_b'] = this.imageB;
    data['image_b_status'] = this.imageBStatus;
    data['image_c_status'] = this.imageCStatus;
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
    data['discount_type'] = this.discountType;
    data['discount_amount'] = this.discountAmount;
    data['bill_amount'] = this.billAmount;
    data['discount_description'] = this.discountDescription;
    data['ladies'] = this.ladies;
    data['stag'] = this.stag;
    data['couples'] = this.couples;
    data['papular_status'] = this.papularStatus;
    data['papular_time'] = this.papularTime;
    data['subscriotion_type'] = this.subscriotionType;
    data['party_amenitie_id'] = this.partyAmenitieId;
    data['image_status'] = this.imageStatus;
    data['approval_status'] = this.approvalStatus;
    data['qr_image']=this.qr;
    data['pjApprovalStatus'] = this.pjApprovalStatus;
    return data;
  }
}