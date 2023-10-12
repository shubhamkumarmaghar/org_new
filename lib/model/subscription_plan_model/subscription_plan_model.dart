class SubscriptionPlanModel {
  SubscriptionPlanModel({
    this.status,
    this.message,
    required this.subsData,
  });
  int? status;
  String? message;
  List<SubscriptionData> subsData = [];

  SubscriptionPlanModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    subsData = List.from(json['data']).map((e)=>SubscriptionData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = subsData.map((e)=>e.toJson()).toList();
    return _data;
  }

}

class SubscriptionData {
  SubscriptionData({
    required this.id,
    required this.subType,
    required this.name,
    required this.description,
    required this.day,
    required this.amount,
    required this.status,
    required this.isPopular
  });
  late final String id;
  late final String subType;
  late final String name;
  late final String description;
  late final String day;
  late final String amount;
  late final String status;
  late final String isPopular;

  SubscriptionData.fromJson(Map<String, dynamic> json){
    id = json['id'];
    subType = json['sub_type'];
    name = json['name'];
    description = json['description'];
    day = json['day'];
    amount = json['amount'];
    status = json['status'];
    isPopular = json['is_popular'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['description'] = description;
    _data['day'] = day;
    _data['amount'] = amount;
    _data['status'] = status;
    _data['is_popular'] = isPopular;
    return _data;
  }
}