import 'dart:convert';

import 'package:http/http.dart';

/// 郵便番号から情報取得
class ZipCode {
  static Future<Map<String, String>?> searchAddressFromZipCode(String zipCode) async {
    String url = 'https://geoapi.heartrails.com/api/json?method=searchByPostal&postal=$zipCode';
    try {
      var result = await get(Uri.parse(url));
      Map<String, dynamic> data = jsonDecode(result.body);
      Map<String, String> response = {};
      if (data['response']['location'] == null) {
        response['message'] = '正しい郵便番号を入力してください。'; // エラーメッセージ
      } else {
        response['address'] = data['response']['location'][0]['city']; // 市区町村取得
        response['address2'] = data['response']['location'][0]['town']; // 町名取得
        response['lon'] = data['response']['location'][0]['x']; // 経度取得
        response['lat'] = data['response']['location'][0]['y']; // 緯度取得
      }
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
