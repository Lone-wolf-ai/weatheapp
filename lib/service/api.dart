import 'package:weatherapp/consts/strings.dart';
import 'package:http/http.dart' as http;

import 'package:weatherapp/model/forcastmodel.dart';
import 'package:weatherapp/model/weathermodel.dart';

getCurrentWeather(double lat, double lon) async {
  var link =
      "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric";
  var res = await http.get(Uri.parse(link));

  if (res.statusCode == 200) {
    var data = weathemodelFromJson(res.body.toString());
    print("recjived");
    return data;
  }
}

gethourlyWeather(lat, lon) async {
  var link =
      "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=27c0a0ac444d8e24641392f64253b094&units=metric";
  var res = await http.get(Uri.parse(link));

  if (res.statusCode == 200) {
    var data2 = hourlyWeatherDataFromJson(res.body.toString());
    print(data2);
    print("recived");
    return data2;
  }
}
