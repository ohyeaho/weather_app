import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/weather.dart';

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  Weather currentWeather = Weather(temp: 15, description: '晴れ', tempMax: 18, tempMin: 14, time: DateTime(2021));
  List<Weather> hourlyWeather = [
    Weather(temp: 30, description: '晴れ', time: DateTime(2021, 7, 30, 10), rainyPercent: 0),
    Weather(temp: 24, description: '雨', time: DateTime(2021, 7, 30, 11), rainyPercent: 90),
    Weather(temp: 25, description: '曇り', time: DateTime(2021, 7, 30, 12), rainyPercent: 10),
    Weather(temp: 28, description: '晴れ', time: DateTime(2021, 7, 30, 13), rainyPercent: 0),
    Weather(temp: 30, description: '晴れ', time: DateTime(2021, 7, 30, 10), rainyPercent: 0),
    Weather(temp: 24, description: '雨', time: DateTime(2021, 7, 30, 11), rainyPercent: 90),
    Weather(temp: 25, description: '曇り', time: DateTime(2021, 7, 30, 12), rainyPercent: 10),
    Weather(temp: 28, description: '晴れ', time: DateTime(2021, 7, 30, 13), rainyPercent: 0),
  ];

  List<Weather> dailyWeather = [
    Weather(tempMax: 30, tempMin: 25, rainyPercent: 10, time: DateTime(2021, 7, 30)),
    Weather(tempMax: 25, tempMin: 20, rainyPercent: 80, time: DateTime(2021, 7, 31)),
    Weather(tempMax: 32, tempMin: 27, rainyPercent: 0, time: DateTime(2021, 8, 1)),
    Weather(tempMax: 30, tempMin: 25, rainyPercent: 10, time: DateTime(2021, 7, 30)),
    Weather(tempMax: 25, tempMin: 20, rainyPercent: 80, time: DateTime(2021, 7, 31)),
    Weather(tempMax: 32, tempMin: 27, rainyPercent: 0, time: DateTime(2021, 8, 1)),
    Weather(tempMax: 30, tempMin: 25, rainyPercent: 10, time: DateTime(2021, 7, 30)),
    Weather(tempMax: 25, tempMin: 20, rainyPercent: 80, time: DateTime(2021, 7, 31)),
    Weather(tempMax: 32, tempMin: 27, rainyPercent: 0, time: DateTime(2021, 8, 1)),
    Weather(tempMax: 30, tempMin: 25, rainyPercent: 10, time: DateTime(2021, 7, 30)),
    Weather(tempMax: 25, tempMin: 20, rainyPercent: 80, time: DateTime(2021, 7, 31)),
    Weather(tempMax: 32, tempMin: 27, rainyPercent: 0, time: DateTime(2021, 8, 1)),
  ];

  List<String> weekDay = ['月', '火', '水', '木', '金', '土', '日'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Text('横浜市', style: TextStyle(fontSize: 25)),
            Text(currentWeather.description),
            Text('${currentWeather.temp}°', style: const TextStyle(fontSize: 80)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('最高:${currentWeather.tempMax}°'), const SizedBox(width: 10), Text('最低:${currentWeather.tempMin}°')],
            ),
            const SizedBox(height: 50),
            const Divider(height: 0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: hourlyWeather.map((weather) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                    child: Column(
                      children: [
                        Text('${DateFormat('H').format(weather.time)}時'),
                        Text('${weather.rainyPercent}%', style: const TextStyle(color: Colors.lightBlue)),
                        const Icon(Icons.wb_sunny_sharp, color: Colors.yellow),
                        const SizedBox(height: 8),
                        Text('${weather.temp}°', style: const TextStyle(fontSize: 18))
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const Divider(height: 0),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                  child: Column(
                    children: dailyWeather.map((weather) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 50,
                            child: Text('${weekDay[weather.time.weekday - 1]}曜日'),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.wb_sunny_sharp, color: Colors.yellow),
                              Text('${weather.rainyPercent}%', style: const TextStyle(color: Colors.lightBlue))
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
