class ProfileModel {
  late int? id;
  late String name;
  late String phone;
  late String email;
  String? image;
  late int status;
  late int orderCount;

  ProfileModel({
    required this.phone,
    required this.email,
    required this.name,
    required this.id,
    required this.orderCount,
    this.image,
    required this.status
  });

  ProfileModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['f_name'];
    phone = json['phone'];
    email = json['email'];
    status = json['status'];
    image = json['image'];
    orderCount = json['order_count'];
  }



}