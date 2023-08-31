class StateCityModel {
StateCityModel({
  required this.status,
  required this.message,
  required this.data,
});
late final int status;
late final String message;
late final List<StateName> data;

StateCityModel.fromJson(Map<String, dynamic> json){
status = json['status'];
message = json['message'];
data = List.from(json['data']).map((e)=>StateName.fromJson(e)).toList();
}

Map<String, dynamic> toJson() {
final _data = <String, dynamic>{};
_data['status'] = status;
_data['message'] = message;
_data['data'] = data.map((e)=>e.toJson()).toList();
return _data;
}
}

class StateName {
  StateName({
required this.id,
required this.name,
required this.countryId,
required this.countryCode,
this.fipsCode,
required this.iso2,
required this.type,
required this.latitude,
required this.longitude,
required this.createdAt,
required this.updatedAt,
required this.flag,
required this.wikiDataId,
});
late final String id;
late final String name;
late final String countryId;
late final String countryCode;
late final dynamic fipsCode;
late final dynamic iso2;
late final dynamic type;
late final String latitude;
late final String longitude;
late final String createdAt;
late final String updatedAt;
late final String flag;
late final String wikiDataId;

  StateName.fromJson(Map<String, dynamic> json){
id = json['id'];
name = json['name'];
countryId = json['country_id'];
countryCode = json['country_code'];
fipsCode = json['fips_code'];
iso2 = json['iso2'];
type = json['type'];
latitude = json['latitude'];
longitude = json['longitude'];
createdAt = json['created_at'];
updatedAt = json['updated_at'];
flag = json['flag'];
wikiDataId = json['wikiDataId'];
}

Map<String, dynamic> toJson() {
final _data = <String, dynamic>{};
_data['id'] = id;
_data['name'] = name;
_data['country_id'] = countryId;
_data['country_code'] = countryCode;
_data['fips_code'] = fipsCode;
_data['iso2'] = iso2;
_data['type'] = type;
_data['latitude'] = latitude;
_data['longitude'] = longitude;
_data['created_at'] = createdAt;
_data['updated_at'] = updatedAt;
_data['flag'] = flag;
_data['wikiDataId'] = wikiDataId;
return _data;
}
}