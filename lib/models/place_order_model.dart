import 'package:food_delivery/models/carts_model.dart';

class PlaceOrderBody {
  List<CartsModel>? _cart;
  late dynamic _orderAmount;
  late String _orderNote;
  double? _distance;
  String? _address;
  String? _latitude;
  String? _longitude;
  String? _contactPersonName;
  String? _contactPersonNumber;
  int? _id;
  String? _createdTime;

  PlaceOrderBody(
      {required List<CartsModel> cart,
        required double orderAmount,
        required double distance,
        required String scheduleAt,
        required String orderNote,
        required String address,
        required String latitude,
        required String longitude,
        required String contactPersonName,
        required String contactPersonNumber,
        int? id,
        String? createdTime,

      }){
    _cart = cart;
    _orderAmount = orderAmount;
    _orderNote = orderNote;
    _distance = distance;
    _address = address;
    _latitude = latitude;
    _longitude = longitude;
    _contactPersonName = contactPersonName;
    _contactPersonNumber = contactPersonNumber;
  }

  List<CartsModel> get cart => _cart!;

  dynamic get orderAmount => _orderAmount;

  String get orderNote => _orderNote;

  double? get distance => _distance;

  String? get address => _address;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get contactPersonName => _contactPersonName;
  String? get contactPersonNumber => _contactPersonNumber;
  int? get id => _id;
  String? get createdTime => _createdTime;

  PlaceOrderBody.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      _cart = [];
      json['cart'].forEach((v) {
        _cart!.add(CartsModel.fromJson(v));
      });
    }

    _orderAmount = json['order_amount'];

    _orderNote = json['order_note'];

    _distance = json['distance'];
    _id = json['id']??'';
    _createdTime = json['created_at']??'';

    _address = json['address'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _contactPersonName = json['contact_person_name'];
    _contactPersonNumber = json['contact_person_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (_cart != null) {
      data['cart'] = _cart!.map((v) => v.toJson()).toList();
    }
    data['order_amount'] = _orderAmount;
    data['order_note'] = _orderNote;
    data['distance'] = _distance;
    data['address'] = _address;
    data['latitude'] = _latitude;
    data['longitude'] = _longitude;
    data['contact_person_name'] = _contactPersonName;
    data['contact_person_number'] = _contactPersonNumber;
    data['id'] = _id;
    data['created_at'] = _createdTime;
    return data;
  }

}

