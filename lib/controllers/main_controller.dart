import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather_app/services/api_service.dart';

class MainController extends GetxController{

  @override
  void onInit() async{
    await getUserLocation();
    getWeatherData = currentWeather(latitude.value.toDouble(),longitude.value.toDouble());
    getHourlyWeatherData = currentHourlyWeather();
    super.onInit();
  }
  var isDark = false.obs;
  var getWeatherData;
  var getHourlyWeatherData;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  changeTheme() {
    isDark.value = !isDark.value;
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  }


  getUserLocation() async{
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission userPermission;
    if(!isLocationEnabled){
      return Future.error("Location is not enabled");
    }
    userPermission = await Geolocator.checkPermission();
    if(userPermission == LocationPermission.deniedForever){
      return Future.error("Permission is denied forever");
    }
    else if(userPermission == LocationPermission.denied){
      userPermission = await Geolocator.requestPermission();
    if(userPermission == LocationPermission.denied){
      return Future.error("Permission is denied");
    }
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value) {
      latitude.value = latitude.value;
      longitude.value = longitude.value;
    });
  }

}