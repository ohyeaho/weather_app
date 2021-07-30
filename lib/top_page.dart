import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/weather.dart';

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  Weather currentWeather =
      Weather(temp: 15, description: '晴れ', tempMax: 18, tempMin: 14, time: DateTime(2021));
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
              children: [
                Text('最高:${currentWeather.tempMax}°'),
                const SizedBox(width: 10),
                Text('最低:${currentWeather.tempMin}°')
              ],
            ),
            SizedBox(height: 50),
            Divider(height: 0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: hourlyWeather.map((weather) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                    child: Column(
                      children: [
                        Text('${DateFormat('H').format(weather.time)}時'),
                        Text('${weather.rainyPercent}%', style: TextStyle(color: Colors.lightBlue)),
                        Icon(Icons.wb_sunny_sharp),
                        SizedBox(height: 8),
                        Text('${weather.temp}°', style: TextStyle(fontSize: 18))
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Divider(height: 0)
          ],
        ),
      ),
    );
  }
}
