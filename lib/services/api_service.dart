import 'package:http/http.dart' as http;
import 'package:weather_app/consts/strings.dart';
import 'package:weather_app/models/current_weather_model.dart';
import 'package:weather_app/models/hourly_weather_model.dart';


var hourlyLinks = "https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric";

Future<CurrentWeatherData?> currentWeather(lat,long) async{
    var links = "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$apiKey&units=metric";
    var res = await http.get(Uri.parse(links));
    if(res.statusCode == 200){
      var data = currentWeatherDataFromJson(res.body.toString());
      print('Data is received:');
      return data;
    }
    return null;
  }

Future<HourlyWeatherData?> currentHourlyWeather() async{
  var res = await http.get(Uri.parse(hourlyLinks));
  if(res.statusCode == 200){
    var data = hourlyWeatherDataFromJson(res.body.toString());
    print('Hourly Data is received:');
    return data;
  }
  return null;
}