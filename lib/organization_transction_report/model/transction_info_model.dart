class TransctionModel {
  TransctionModel({
    this.status,
     this.message,
    this.data,
  });
   int? status;
   String? message;
   List<Data>? data;

  TransctionModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    if (this.data != null) {
      _data['data'] = data!.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.subscriptionId,
    required this.userId,
    required this.name,
    required this.description,
    required this.day,
    required this.amount,
    required this.paymentStatus,
    required this.planStartDate,
    required this.planEndDate,
    required this.paymentResponse,
    required this.paymentId,
    required this.planExpiredStatus,
    required this.planActiveStatus,
    required this.orderId
  });
  late final String id;
  late final String subscriptionId;
  late final String userId;
  late final String name;
  late final String description;
  late final String day;
  late final String amount;
  late final String paymentStatus;
  late final String planStartDate;
  late final String planEndDate;
  late final dynamic paymentResponse;
  late final dynamic paymentId;
  late final String planExpiredStatus;
  late final String planActiveStatus;
  late final String orderId;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    subscriptionId = json['subscription_id'];
    userId = json['user_id'];
    name = json['name'];
    description = json['description'];
    day = json['day'];
    amount = json['amount'];
    paymentStatus = json['payment_status'];
    planStartDate = json['plan_start_date'];
    planEndDate = json['plan_end_date'];
    paymentResponse = json['payment_response'];
    paymentId = json['payment_id'];
    planExpiredStatus = json['plan_expired_status'];
    planActiveStatus = json['plan_active_status'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['subscription_id'] = subscriptionId;
    _data['user_id'] = userId;
    _data['name'] = name;
    _data['description'] = description;
    _data['day'] = day;
    _data['amount'] = amount;
    _data['payment_status'] = paymentStatus;
    _data['plan_start_date'] = planStartDate;
    _data['plan_end_date'] = planEndDate;
    _data['payment_response'] = paymentResponse;
    _data['payment_id'] = paymentId;
    _data['plan_expired_status'] = planExpiredStatus;
    _data['plan_active_status'] = planActiveStatus;
    _data['order_id']= orderId;
    return _data;
  }
}