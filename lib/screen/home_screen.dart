import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/consts/colors.dart';
import 'package:weather_app/models/current_weather_model.dart';
import 'package:weather_app/models/hourly_weather_model.dart';
import 'package:weather_app/services/api_service.dart';

import '../consts/images.dart';
import '../consts/strings.dart';
import 'package:get/get.dart';

import '../controllers/main_controller.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
   var date = DateFormat('yMMMMd').format(DateTime.now());
   var theme = Theme.of(context);
   var controller = Get.put(MainController());
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(date,style: TextStyle(
          color:theme.primaryColor
        ),),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [

          Obx(
          ()=> IconButton(onPressed: (){
              controller.changeTheme();

            }, icon: Icon(controller.isDark.value ? Icons.light_mode : Icons.dark_mode,color: theme.iconTheme.color)),
          ),
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert,color: theme.iconTheme.color,)),

        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child:  FutureBuilder(
          future:controller.getWeatherData,
          builder: (context,snapshot) {
            if(snapshot.hasData){
              CurrentWeatherData data = snapshot.data as CurrentWeatherData;
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.name!.toUpperCase(),style: TextStyle(
                      color: theme.primaryColor,
                      fontFamily: 'poppin_bold',
                      fontWeight: FontWeight.bold,
                      fontSize: 32,

                    ),
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('assets/images/${data.weather![0].icon}.png',
                          height: 80,
                          width: 80,),
                        RichText(text: TextSpan(
                            children: [
                              TextSpan(
                                  text: '${data.main!.temp}$degree',style: TextStyle(
                                  color: theme.primaryColor,
                                  fontSize: 64
                              )
                              ),
                              TextSpan(
                                  text: '${data.weather![0].main}',style: TextStyle(
                                color: theme.primaryColor,
                                fontSize: 14,

                              )
                              )
                            ]
                        ))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.expand_less_rounded,color: theme.iconTheme.color,),
                          label:Text('${data.main!.tempMax}$degree',style: TextStyle(fontSize: 14,color: theme.iconTheme.color),),
                        ),
                        TextButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.expand_more_rounded,color: theme.iconTheme.color,),
                          label: Text('${data.main!.tempMin}$degree',style: TextStyle(fontSize: 14,color: theme.iconTheme.color),),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(3, (index) {
                        var iconsList = [clouds,humidity,windspeed];
                        var values = ['${data.clouds!.all}','${data.main!.humidity}','${data.wind!.speed} km/h'];
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration:BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey.shade300
                              ),
                              child: Image.asset(
                                iconsList[index],
                                width: 60,
                                height: 60,
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Text(values[index].toString(),style: TextStyle(color: theme.primaryColor),)
                          ],
                        );
                      }),
                    ),
                    const SizedBox(height: 10,),
                    const Divider(),
                    const SizedBox(height: 10,),
                    FutureBuilder(
                    future: controller.getHourlyWeatherData,
                    builder: (context,snapshot){
                      if(snapshot.hasData){
                        HourlyWeatherData hourlyData = snapshot.data as HourlyWeatherData;
                        return SizedBox(
                          height: 150,
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: hourlyData.list!.length > 6 ? 6 : hourlyData.list!.length ,
                              itemBuilder: (context,index){
                                var time = DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(hourlyData.list![index].dt!.toInt() * 1000));
                                return Container(
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.only(right: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(time,style: TextStyle(
                                        color: Colors.grey.shade900,

                                      ),),
                                      Image.asset('assets/images/${hourlyData.list![index].weather![0].icon}.png',width: 80,),
                                      Text('${hourlyData.list![index].main!.temp}$degree',style: TextStyle(
                                        color: Colors.grey.shade900,

                                      ),),

                                    ],
                                  ),
                                );
                              }),
                        );
                      }
                      else{
                        return const Center(child: CircularProgressIndicator(),);
                      }
            }),
                    const SizedBox(height: 10,),
                    const Divider(),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Next 7 Days',style: TextStyle(
                          fontSize: 16,
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),),
                        TextButton(onPressed: (){}, child: const Text('View All')),
                      ],
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 7,
                        itemBuilder: (context,index){
                          var day = DateFormat('EEEE').format(DateTime.now().add(Duration(days: index+1),),);
                          return Card(
                            color: theme.cardColor,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(day,style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: theme.primaryColor
                                    ),),
                                  ),
                                  Expanded(child: TextButton.icon(onPressed: null,
                                    icon: Image.asset('assets/images/50n.png',width: 40,),
                                    label: Text('26$degree',style: TextStyle(color: theme.primaryColor),),),),
                                  RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(text: '37$degree /',style: TextStyle(
                                            color: theme.primaryColor,
                                            fontFamily: 'poppin',
                                            fontSize: 16,
                                          ),),
                                          TextSpan(text: '26$degree',style: TextStyle(
                                            color: theme.iconTheme.color,
                                            fontFamily: 'poppin',
                                            fontSize: 16,
                                          ))
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          );
                        })
                  ],
                ),
              );
            }
            else{
              return const Center(child: CircularProgressIndicator(),);
            }
          }
          ),
      ),
    );
  }
}
