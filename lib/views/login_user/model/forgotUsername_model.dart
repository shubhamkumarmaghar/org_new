class ForgotUserNameModel {
  int? userId;
  String? isVerifiedPhone;
  String? otp;
  String? uniqueId;
  String? token;

  ForgotUserNameModel(
      {this.userId, this.isVerifiedPhone, this.otp, this.uniqueId, this.token});

  ForgotUserNameModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    isVerifiedPhone = json['is_verified_phone'];
    otp = json['otp'];
    uniqueId = json['unique_id'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['is_verified_phone'] = this.isVerifiedPhone;
    data['otp'] = this.otp;
    data['unique_id'] = this.uniqueId;
    data['token'] = this.token;
    return data;
  }
}