class CartOrderModel {
  late String name;
  late String price;
  late String quantity;
  late String image;

  CartOrderModel({
    required this.name,
    required this.quantity,
    required this.price,
    required this.image
  });

  CartOrderModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
    price = json['price'];
    quantity = json['quantity'];
    image = json['img'];
  }

  Map<String, dynamic> toJson(){
    return {
      'name':name,
      'price':price,
      'quantity':quantity,
      'img': image,
    };
  }
}