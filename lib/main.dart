import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

import 'package:weatherapp/controller/maincontroller.dart';
import 'package:weatherapp/customtheme.dart';

import 'package:weatherapp/model/forcastmodel.dart';
import 'package:weatherapp/model/weathermodel.dart';

import 'consts/images.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: Customthemes.ligthTheme,
      darkTheme: Customthemes.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const WeatherApp(),
      title: "weatherapp",
    );
  }
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    var date = DateFormat("yMMMd").format(DateTime.now());
    var theme = Theme.of(context);
    var controller = Get.put(MainController());
    return Scaffold(
      appBar: AppBar(
        title: date.text.color(theme.primaryColor).make(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Obx(
            () => IconButton(
                onPressed: () {
                  controller.changeTheme();
                },
                icon: Icon(
                  controller.isDark.value
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  color: theme.iconTheme.color,
                )),
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color: theme.iconTheme.color,
              ))
        ],
      ),
      body: Obx(
        () => controller.isloaded.value == true
            ? Container(
                padding: const EdgeInsets.all(12),
                child: FutureBuilder(
                  future: controller.currentweatherdata,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      Weathemodel data = snapshot.data;
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            data.name.text
                                .fontFamily("poppin_bold")
                                .bold
                                .color(theme.primaryColor)
                                .size(32)
                                .letterSpacing(3)
                                .make(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'assets/weather/${data.weather[0].icon}.png',
                                  width: 80,
                                  height: 80,
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "${data.main.temp.toInt()}°",
                                        style: TextStyle(
                                            fontFamily: 'poppins',
                                            fontSize: 64,
                                            color: theme.primaryColor),
                                      ),
                                      TextSpan(
                                        text: data.weather[0].main,
                                        style: TextStyle(
                                            fontFamily: 'poppins_light',
                                            fontSize: 14,
                                            color: theme.primaryColor),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  label: "${data.main.tempMin.toInt()}°"
                                      .text
                                      .color(theme.primaryColor)
                                      .make(),
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.expand_less_rounded,
                                    color: theme.primaryColor,
                                  ),
                                ),
                                TextButton.icon(
                                  label: "${data.main.tempMax.toInt()}°"
                                      .text
                                      .color(theme.primaryColor)
                                      .make(),
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.expand_more_rounded,
                                    color: theme.primaryColor,
                                  ),
                                )
                              ],
                            ),
                            10.heightBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(3, (index) {
                                var iconllist = [clouds, humidity, windspeed];
                                var values = [
                                  "${data.clouds.all}",
                                  "${data.main.humidity}%",
                                  "${data.wind.speed}km/h"
                                ];
                                return Column(children: [
                                  Image.asset(
                                    iconllist[index],
                                    width: 60,
                                    height: 60,
                                  )
                                      .box
                                      .gray200
                                      .padding(const EdgeInsets.all(8))
                                      .roundedSM
                                      .make(),
                                  10.heightBox,
                                  values[index]
                                      .text
                                      .color(theme.primaryColor)
                                      .make()
                                ]);
                              }),
                            ),
                            10.heightBox,
                            const Divider(),
                            10.heightBox,
                            FutureBuilder(
                              future: controller.hourlyforcast,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  HourlyWeatherData data2 = snapshot.data;
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: data2.list!.length > 6
                                          ? 6
                                          : data2.list?.length,
                                      itemBuilder: (context, index) {
                                        var time = DateFormat.jm().format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                data2.list![index].dt!.toInt() *
                                                    1000));

                                        return Container(
                                          padding: const EdgeInsets.all(8),
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          decoration: BoxDecoration(
                                              color: Vx.gray300,
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Column(
                                            children: [
                                              time.text.make(),
                                              Image.asset(
                                                "assets/weather/${data2.list![index].weather![0].icon}.png",
                                                width: 80,
                                              ),
                                              "${data2.list![index].main!.temp}°"
                                                  .text
                                                  .make(),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                            10.heightBox,
                            const Divider(),
                            10.heightBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                "Next 5 Days"
                                    .text
                                    .semiBold
                                    .size(16)
                                    .color(theme.primaryColor)
                                    .make(),
                                TextButton(
                                    onPressed: () {},
                                    child: "view all"
                                        .text
                                        .blue300
                                        .semiBold
                                        .size(14)
                                        .make()),
                              ],
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: 7,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var day = DateFormat("EEEE").format(
                                    DateTime.now().add(
                                      Duration(days: 1 + index),
                                    ),
                                  );
                                  return Card(
                                    color: theme.cardColor,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: day.text
                                                  .color(theme.primaryColor)
                                                  .bold
                                                  .make()),
                                          Expanded(
                                            child: TextButton.icon(
                                              onPressed: () {},
                                              label: "24°"
                                                  .text
                                                  .color(theme.iconTheme.color)
                                                  .make(),
                                              icon: Image.asset(
                                                  "assets/weather/50n.png",
                                                  width: 40),
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "37 /",
                                                  style: TextStyle(
                                                    color: theme.primaryColor,
                                                    fontFamily: 'poppins',
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: "26",
                                                  style: TextStyle(
                                                    color: theme.primaryColor,
                                                    fontFamily: 'poppins',
                                                    fontSize: 16,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                })
                          ],
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
