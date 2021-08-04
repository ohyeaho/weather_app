import 'dart:convert';

import 'package:http/http.dart';

class Weather {
  int? temp; // 気温
  int? tempMax; // 最高気温
  int? tempMin; //最低気温
  String description; //天気状態
  double? lon; //経度
  double? lat; //緯度
  String icon; //天気情報のアイコン画像
  DateTime time; //日時
  int? rainyPercent; //降水確率

  Weather({
    this.temp,
    this.tempMax,
    this.tempMin,
    this.description = '',
    this.lon,
    this.lat,
    this.icon = '',
    required this.time,
    // DateTime? time,
    // this.time = DateTime(),
    this.rainyPercent,
  });
  // }) : this.time = time ?? DateTime();

  static String publicParameter = '&appid=91de40c1dbf22fc8ef18b994e54478b6&lang=ja&units=metric';
  static Future<Weather?> getCurrentWeather(String zipCode) async {
    String? _zipCode;
    if (zipCode.contains('-')) {
      _zipCode = zipCode;
    } else {
      _zipCode = zipCode.substring(0, 3) + '-' + zipCode.substring(3);
    }
    String url = 'https://api.openweathermap.org/data/2.5/weather?zip=$_zipCode,JP$publicParameter';
    try {
      var result = await get(Uri.parse(url));
      Map<String, dynamic> data = jsonDecode(result.body);
      Weather currentWeather = Weather(
          time: DateTime.now(),
          description: data['weather'][0]['description'],
          temp: data['main']['temp'].toInt(),
          tempMax: data['main']['temp_max'].toInt(),
          tempMin: data['main']['temp_min'].toInt(),
          lon: data['coord']['lon'],
          lat: data['coord']['lat']);
      return currentWeather;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<Weather>?> getHourlyWeather({double? lon, double? lat}) async {
    String url = 'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=minutely$publicParameter';
    try {
      var result = await get(Uri.parse(url));
      Map<String, dynamic> data = jsonDecode(result.body);
      List<dynamic> hourlyWeatherData = data['hourly'];
      List<Weather> hourlyWeather = hourlyWeatherData.map((weather) {
        return Weather(
          time: DateTime.fromMillisecondsSinceEpoch(weather['dt'] * 1000),
          temp: weather['temp'].toInt(),
          icon: weather['weather'][0]['icon'],
        );
      }).toList();
      return hourlyWeather;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
