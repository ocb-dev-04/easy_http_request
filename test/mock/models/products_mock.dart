import 'package:easy_http_request/core/parser/http_parser.dart';

class ProductsModel implements HttpDataParser<ProductsModel> {
  ProductsModel({this.id, this.email, this.username, this.password, this.phone});

  int? id;
  String? email;
  String? username;
  String? password;
  String? phone;

  @override
  ProductsModel fromJson(Map<String, dynamic> json) =>
      ProductsModel(id: json['id'], email: json['email'], username: json['username'], password: json['password'], phone: json['phone']);

  @override
  Map<String, dynamic> toJson() => {'id': id, 'email': email, 'username': username, 'password': password, 'phone': phone};
}
