import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:weatherapp/service/api.dart';

class MainController extends GetxController {
  @override
  void onInit() async {
    await getuserlocation();

    currentweatherdata = getCurrentWeather(lattitude.value, longitude.value);
    hourlyforcast = gethourlyWeather(lattitude.value, longitude.value);
    super.onInit();
  }

  var currentweatherdata;
  var hourlyforcast;
  var isDark = false.obs;
  var lattitude = 0.0.obs;
  var longitude = 0.0.obs;
  var isloaded = false.obs;
  changeTheme() {
    isDark.value = !isDark.value;
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  }

  getuserlocation() async {
    bool islocationenabled;
    LocationPermission userPermission;
    islocationenabled = await Geolocator.isLocationServiceEnabled();
    if (!islocationenabled) {
      return Future.error("Permisson denied");
    }
    userPermission = await Geolocator.checkPermission();
    if (userPermission == LocationPermission.deniedForever) {
      return Future.error("Permission denied for forever");
    } else if (userPermission == LocationPermission.denied) {
      userPermission = await Geolocator.requestPermission();
      if (userPermission == LocationPermission.denied) {
        return Future.error("permission denied");
      }
    }
    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      longitude.value = value.longitude;
      lattitude.value = value.latitude;
      isloaded.value = true;
    });
  }
}
