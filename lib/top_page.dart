import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/weather.dart';
import 'package:weather_app/zip_code.dart';

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  Weather? currentWeather;
  String? address = 'ー';
  String? errorMessage;
  List<Weather>? hourlyWeather;
  List<Weather>? dailyWeather;
  List<String> weekDay = ['月', '火', '水', '木', '金', '土', '日'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// 郵便番号入力フォーム
            SizedBox(
              width: 120,
              child: TextField(
                onSubmitted: (value) async {
                  Map<String, String>? response = {};
                  response = await ZipCode.searchAddressFromZipCode(value);
                  errorMessage = response!['message'];
                  if (response.containsKey('address')) {
                    address = response['address'];
                    currentWeather = await Weather.getCurrentWeather(value);
                    Map<String, List<Weather>>? weatherForecast = await Weather.getForecast(lon: currentWeather!.lon, lat: currentWeather!.lat);
                    hourlyWeather = weatherForecast!['hourly'];
                    dailyWeather = weatherForecast['daily'];
                  }
                  setState(() {});
                },
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  icon: Text('〒', style: TextStyle(fontWeight: FontWeight.bold)),
                  hintText: '郵便番号を入力',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),

            /// 郵便番号入力からのエラーを表示
            errorMessage == null ? Container() : Text(errorMessage!, style: const TextStyle(color: Colors.red)),

            /// 市区町村表示
            Text(address!, style: const TextStyle(fontSize: 28)),

            /// 天気の情報
            Text(currentWeather == null ? 'ー' : currentWeather!.description, style: const TextStyle(fontSize: 20)),

            /// 現在の気温
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                Text(currentWeather == null ? 'ー' : '${currentWeather!.temp}', style: const TextStyle(fontSize: 90, fontWeight: FontWeight.w200)),
                SizedBox(
                  width: 10,
                  child: Text(currentWeather == null ? '' : '°', style: const TextStyle(fontSize: 90, fontWeight: FontWeight.w200)),
                ),
              ],
            ),

            /// 現在の最高気温、最低気温
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(currentWeather == null ? '最高:ー' : '最高:${currentWeather!.tempMax}°', style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Text(currentWeather == null ? '最低:ー' : '最低:${currentWeather!.tempMin}°', style: const TextStyle(fontSize: 20)),
              ],
            ),
            const SizedBox(height: 20),

            /// １時間ごとの予報
            const Divider(height: 0, color: Colors.white),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: hourlyWeather == null
                  ? Container()
                  : Row(
                      children: hourlyWeather!.map((weather) {
                        String hourlyTime = '${DateFormat('H').format(weather.time ??= DateTime(0))}時';
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
                          child: Column(
                            children: [
                              Text(hourlyTime.substring(0, 1) == '0' ? hourlyTime.substring(1) : hourlyTime, style: const TextStyle(fontSize: 20)),
                              if (weather.icon == '01d')
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 14.0),
                                  child: Icon(Icons.wb_sunny_sharp, color: Colors.yellow),
                                )
                              else if (weather.icon == '01n')
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 14.0),
                                  child: Icon(Icons.nightlight_round, color: Colors.white),
                                )
                              else
                                Image.network('https://openweathermap.org/img/wn/${weather.icon}.png'),
                              Text('${weather.temp}°', style: const TextStyle(fontSize: 20))
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
            const Divider(height: 0, color: Colors.white),

            /// 日ごとの予報
            dailyWeather == null
                ? Container()
                : Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: Column(
                          children: dailyWeather!.map((weather) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 60,
                                    child: Text('${weekDay[weather.time!.weekday - 1]}曜日', style: const TextStyle(fontSize: 20)),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(width: 40),
                                      if (weather.icon == '01d')
                                        const SizedBox(height: 30, width: 30, child: Icon(Icons.wb_sunny_sharp, color: Colors.yellow))
                                      else if (weather.icon == '01n')
                                        const SizedBox(height: 30, width: 30, child: Icon(Icons.nightlight_round, color: Colors.white))
                                      else
                                        SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: Image.network(
                                            'https://openweathermap.org/img/wn/${weather.icon}.png',
                                            fit: BoxFit.none,
                                          ),
                                        ),
                                      SizedBox(
                                        width: 40,
                                        child: Text(
                                          '${weather.rainyPercent}%',
                                          style: const TextStyle(color: Colors.lightBlue, fontSize: 17),
                                          textAlign: TextAlign.end,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 60,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${weather.tempMax}', style: const TextStyle(fontSize: 20)),
                                        Text('${weather.tempMin}', style: TextStyle(fontSize: 20, color: Colors.grey.withOpacity(0.9)))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
