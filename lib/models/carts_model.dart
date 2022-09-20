import 'package:food_delivery/models/products_model.dart';

class CartsModel {

  late final int id;
  late final String name;
  late final int price;
  late final String img;
  late final int quantity;
  late final bool isExist;
  late final String description;
  late String time;
  late final ProductsModel product;

  CartsModel({
    required this.id,
    required this.name,
    required this.price,
    required this.img,
    required this.quantity,
    required this.isExist,
    required this.time,
    required this.product,
    required this.description
  });

  CartsModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    price = json['price'];
    img = json['img'];
    quantity = json['quantity'];
    isExist = json['isExist'];
    time = json['time'];
    description = json['description'];
    product = ProductsModel.fromJson(json['product']);
  }

  Map<String, dynamic> toJson(){
    return {
    'id' : id,
    'name' : name,
    'price' : price,
    'img' : img,
    'quantity' : quantity,
    'isExist' : isExist,
    'time' : time,
    'description':description,
    'product' : product.toJson()
    };
  }

}