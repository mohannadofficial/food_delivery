import 'package:dio/dio.dart';
import '../../../utils/app_constant.dart';

class DioHelper {

  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: APP_URL,
        receiveDataWhenStatusError: true,
      ),
    );
  }


  static Future<Response> getData({
    required String uri,
    String? token,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,

    }) async{
      dio?.options.headers = {
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${token??''}",
      };
      return await dio!.get(
        uri,
        queryParameters: query,
      ).catchError((onError){
        print('test Error ${onError.toString()}');
      });
  }

  static Future<Response> postData({
    required String uri,
    Map<String, dynamic>? query,
    String? token,
    required Map<String, dynamic> data,
}) async {
    dio?.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${token??''}"
    };
      return await dio!.post(
        uri,
        queryParameters: query,
        data: data,
      ).catchError((onError){
        print(onError.toString());
      });
  }


}