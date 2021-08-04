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
            const SizedBox(height: 10),
            SizedBox(
              width: 150,
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
                  hintText: '郵便番号を入力',
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Text(errorMessage == null ? '' : errorMessage!),
            const SizedBox(height: 10),
            Text(address!, style: const TextStyle(fontSize: 25)),
            Text(currentWeather == null ? 'ー' : currentWeather!.description),
            Text(currentWeather == null ? 'ー' : '${currentWeather!.temp}°', style: const TextStyle(fontSize: 80)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(currentWeather == null ? '最高:ー' : '最高:${currentWeather!.tempMax}°'),
                const SizedBox(width: 10),
                Text(currentWeather == null ? '最低:ー' : '最低:${currentWeather!.tempMin}°'),
              ],
            ),
            const SizedBox(height: 50),
            const Divider(height: 0, color: Colors.white),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: hourlyWeather == null
                  ? Container()
                  : Row(
                      children: hourlyWeather!.map((weather) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                          child: Column(
                            children: [
                              Text('${DateFormat('H').format(weather.time)}時'),
                              if (weather.icon == '01d')
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 14.0),
                                  child: Icon(Icons.wb_sunny_sharp, color: Colors.yellow),
                                )
                              else if (weather.icon == '01n')
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 14.0),
                                  child: Icon(Icons.nightlight_round),
                                )
                              else
                                Image.network('https://openweathermap.org/img/wn/${weather.icon}.png'),
                              Text('${weather.temp}°', style: const TextStyle(fontSize: 18))
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
            const Divider(height: 0, color: Colors.white),
            dailyWeather == null
                ? Container()
                : Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                        child: Column(
                          children: dailyWeather!.map((weather) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: Text('${weekDay[weather.time.weekday - 1]}曜日'),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 35),
                                    if (weather.icon == '01d')
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 5.5, vertical: 5.0),
                                        child: Icon(Icons.wb_sunny_sharp, color: Colors.yellow),
                                      )
                                    else if (weather.icon == '01n')
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 5.5, vertical: 5.0),
                                        child: Icon(Icons.nightlight_round),
                                      )
                                    else
                                      Image.network('https://openweathermap.org/img/wn/${weather.icon}.png', width: 35),
                                    SizedBox(
                                      width: 35,
                                      child: Text(
                                        '${weather.rainyPercent}%',
                                        style: const TextStyle(color: Colors.lightBlue),
                                        textAlign: TextAlign.end,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${weather.tempMax}', style: const TextStyle(fontSize: 16)),
                                      Text('${weather.tempMin}', style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.4)))
                                    ],
                                  ),
                                ),
                              ],
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
