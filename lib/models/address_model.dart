class AddressModel {
  int? id;
  late String addressType;
  String? contactPersonName;
  String? contactPersonNumber;
  late String address;
  late String latitude;
  late String longitude;

  AddressModel({
    this.id,
    required this.addressType,
    this.contactPersonName,
    this.contactPersonNumber,
    required this.address,
    required this.latitude,
    required this.longitude
  });

  AddressModel.fromJson(Map<String, dynamic> json){
    id = json['user_id']??'';
    addressType = json['address_type']??'';
    contactPersonNumber = json['contact_person_number']??'';
    contactPersonName = json['contact_person_name']??'';
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String ,dynamic> toJson(){
    return {
      'user_id': id,
      'address_type': addressType,
      'contact_person_number': contactPersonNumber,
      'contact_person_name': contactPersonName,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

}