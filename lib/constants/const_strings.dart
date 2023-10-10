class API {

 static const String developmentUrl = 'https://65.2.59.129/app/v1';
 static const String productionUrlString = 'https://app.partypeople.in/v1';
 static const String apiUrlString = developmentUrl;

 static const String login = '$apiUrlString/account/login';
 static const String otp = '$apiUrlString/account/otp_verify';


 static const String organizationDetails = '$apiUrlString/party/organization_details';
 static const String addOrganizationDetails = '$apiUrlString/party/add_organization';
 static const String updateOrganization = '$apiUrlString/party/update_organization';
 static const String deleteOrganization = '$apiUrlString/party/delete_organization';
 static const String orgAmenities = '$apiUrlString/party/organization_amenities';

 static const String getAllNotification = '$apiUrlString/notification/get_all_notification';
 static const String readNotification = '$apiUrlString/party/notification_read_status_update';

 static const String partyAdd = '$apiUrlString/party/add';
 static const String partyUpdate = '$apiUrlString/party/update';
 static const String partyAmenities = '$apiUrlString/party/party_amenities';
 static const String getPartyById = '$apiUrlString/party/get_user_organization_party_by_id';
 static const String updateRegularPartiesStatus = '$apiUrlString/order/update_ragular_papular_status';


 static const String getSubscriptionTransactionHistory = '$apiUrlString/Subscription/transaction_history';
 static const String orgUserSubscriptionPurchase = '$apiUrlString/subscription/organiztion_user_subscriptions_purchase';
 static const String userSubscriptionPlanStatusUpdate = '$apiUrlString/subscription/user_subscription_plan_status_update';
 static const String createOrder = '$apiUrlString/order/create_order';
 static const String getStates = '$apiUrlString/home/states';
 static const String getCities = '$apiUrlString/home/cities';

 static const String addImage = '$apiUrlString/party/add_image';
}
