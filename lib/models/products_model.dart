class Products {

  late final int totalSize;
  late final int typeId;
  late final int offset;
  late final List<ProductsModel> products;

  Products({
    required this.totalSize,
    required this.typeId,
    required this.offset,
    required this.products,
  });

  Products.fromJson(Map<String, dynamic> json){
    totalSize = json['total_size'];
    typeId = json['type_id'];
    offset = json['offset'];
    products = List.from(json['products']).map((e)=>ProductsModel.fromJson(e)).toList();
  }

}

class ProductsModel {

  late final int id;
  late final String name;
  late final String description;
  late final int price;
  late final int stars;
  late final String img;
  late final String location;
  late final String createdAt;
  late final String updatedAt;
  late final int typeId;

  ProductsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stars,
    required this.img,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
    required this.typeId,
  });

  ProductsModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    stars = json['stars'];
    img = json['img'];
    location = json['location'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    typeId = json['type_id'];
  }

  Map<String, dynamic> toJson(){
    return {
      'id' : id,
      'name' : name,
      'price' : price,
      'img' : img,
      'description' : description,
      'stars' : stars,
      'location' : location,
      'created_at' : createdAt,
      'updated_at' : updatedAt,
      'type_id' : typeId,
    };
  }

}