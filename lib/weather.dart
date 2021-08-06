import 'dart:convert';

import 'package:http/http.dart';

/// インスタンス
class Weather {
  int? temp; // 気温
  int? tempMax; // 最高気温
  int? tempMin; //最低気温
  String description; //天気状態
  double? lon; //経度
  double? lat; //緯度
  String icon; //天気情報のアイコン画像
  DateTime? time; //日時
  int? rainyPercent; //降水確率

  /// コンストラクタ
  Weather({
    this.temp, //気温
    this.tempMax, //最高気温
    this.tempMin, //最低気温
    this.description = '', //天気情報
    this.lon, // 経度
    this.lat, // 緯度
    this.icon = '', // 天気アイコン
    this.time, // 時間
    this.rainyPercent, // 降水確率
  });

  /// 郵便番号(緯度経度)から現在の天気取得
  static String publicParameter = '&appid=91de40c1dbf22fc8ef18b994e54478b6&lang=ja&units=metric';
  static Future<Weather?> getCurrentWeather({double? lon, double? lat}) async {
    String url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon$publicParameter';
    try {
      var result = await get(Uri.parse(url));
      Map<String, dynamic> data = jsonDecode(result.body);
      Weather currentWeather = Weather(
        description: data['weather'][0]['description'],
        temp: data['main']['temp'].toInt(),
        tempMax: data['main']['temp_max'].toInt(),
        tempMin: data['main']['temp_min'].toInt(),
      );
      return currentWeather;
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// １時間ごと、日ごとの天気予報取得
  static Future<Map<String, List<Weather>>?> getForecast({double? lon, double? lat}) async {
    Map<String, List<Weather>>? response = {};
    String url = 'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=minutely$publicParameter';
    try {
      var result = await get(Uri.parse(url));
      Map<String, dynamic> data = jsonDecode(result.body);

      /// １時間ごとの天気予報
      List<dynamic> hourlyWeatherData = data['hourly'];
      List<Weather> hourlyWeather = hourlyWeatherData.map((weather) {
        return Weather(
          time: DateTime.fromMillisecondsSinceEpoch(weather['dt'] * 1000),
          temp: weather['temp'].toInt(),
          icon: weather['weather'][0]['icon'],
        );
      }).toList();
      response['hourly'] = hourlyWeather;

      /// 日ごとの天気予報
      List<dynamic> dailyWeatherData = data['daily'];
      List<Weather> dailyWeather = dailyWeatherData.map((weather) {
        return Weather(
          time: DateTime.fromMillisecondsSinceEpoch(weather['dt'] * 1000),
          icon: weather['weather'][0]['icon'],
          tempMax: weather['temp']['max'].toInt(),
          tempMin: weather['temp']['min'].toInt(),
          rainyPercent: weather.containsKey('rain') ? weather['rain'].toInt() : 0,
        );
      }).toList();
      response['daily'] = dailyWeather;
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
