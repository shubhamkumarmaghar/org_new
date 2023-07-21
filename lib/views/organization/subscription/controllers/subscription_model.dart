// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Subscriptions? welcomeFromJson(String str) =>
    Subscriptions.fromJson(json.decode(str));

String welcomeToJson(Subscriptions? data) => json.encode(data!.toJson());

class Subscriptions {
  Subscriptions({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  Data? data;

  factory Subscriptions.fromJson(Map<String, dynamic> json) => Subscriptions(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.postSubscriptions,
    this.viewSubscriptions,
  });

  List<Subscription?>? postSubscriptions;
  List<Subscription?>? viewSubscriptions;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        postSubscriptions: json["post_subscriptions"] == null
            ? []
            : List<Subscription?>.from(json["post_subscriptions"]!
                .map((x) => Subscription.fromJson(x))),
        viewSubscriptions: json["view_subscriptions"] == null
            ? []
            : List<Subscription?>.from(json["view_subscriptions"]!
                .map((x) => Subscription.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "post_subscriptions": postSubscriptions == null
            ? []
            : List<dynamic>.from(postSubscriptions!.map((x) => x!.toJson())),
        "view_subscriptions": viewSubscriptions == null
            ? []
            : List<dynamic>.from(viewSubscriptions!.map((x) => x!.toJson())),
      };
}

class Subscription {
  Subscription({
    this.id,
    this.name,
    this.day,
    this.amount,
    this.status,
  });

  String? id;
  String? name;
  String? day;
  String? amount;
  String? status;

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        id: json["id"],
        name: json["name"],
        day: json["day"],
        amount: json["amount"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "day": day,
        "amount": amount,
        "status": status,
      };
}
