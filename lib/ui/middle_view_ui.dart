import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model/weather_forecast_model.dart';
import '../network/weather_forecast_network_class.dart';

class WeatherView {
  Widget createWeatherView(AsyncSnapshot<WeatherForecastModel> snapshot) {
    String city = snapshot.data!.location!.name.toString();
    String country = snapshot.data!.location!.country.toString();

    //splitting the decimal temperature into non decimal output
    var tempCSplit = snapshot.data!.current!.tempC.toString().split('.');
    String tempC = tempCSplit[0]; //tempC = tempC.split(".");

    String weatherCondition =
        snapshot.data!.current!.condition!.text.toString();
    print(weatherCondition);

    //formating date to desried format
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(
        snapshot.data!.location!.localtime.toString()); // <-- dd/MM 24H format

    //formating time to desried format  H:MM AM/PM
    var dateOutputFormat = DateFormat('MMMMEEEEd'); //Friday ,September 3
    var outputDate = dateOutputFormat.format(inputDate);
    print(outputDate);

    var timeOutputFormat = DateFormat('h:mm a'); //Friday ,September 3
    var outputTime = timeOutputFormat.format(inputDate);
    print(outputTime);

    return Container(
      child: createTopView(
          outputDate, outputTime, city, country, weatherCondition, tempC),
    );
  }

  Column createTopView(String outputDate, String outputTime, String city,
      String country, String weatherCondition, String tempC) {
    return Column(
      children: [
        Text(
          outputDate,
          style: TextStyle(fontSize: 25),
        ),
        Text(
          outputTime,
          style: TextStyle(fontSize: 25),
        ),
        Text("$city, $country",
          style: TextStyle(fontSize: 20),
        ),
        Container(
          child: getWeatherIcon(weatherCondition, 130),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$tempCº",
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            Text(weatherCondition, style: TextStyle(fontSize: 30)),
          ],
        ),

      ],
    );
  }

  Icon getWeatherIcon(String weatherCondition, double size) {
    switch (weatherCondition.toLowerCase()) {
      case "sunny":
        return Icon(
          FontAwesomeIcons.solidSun,
          size: size,
        );
      case "clear":
        return Icon(
          FontAwesomeIcons.sun,
          size: size,
        );

      case "partly cloudy":
        return Icon(
          FontAwesomeIcons.cloudSun,
          size: size,
        );

      case "mist":
        return Icon(
          FontAwesomeIcons.cloudflare,
          size: size,
        );

      case "cloudy":
        return Icon(
          FontAwesomeIcons.cloud,
          size: size,
        );

      case 'overcast':
        return Icon(
          FontAwesomeIcons.cloud,
          size: size,
        );

      //rain cases
      case "moderate or heavy rain with thunder":
        return Icon(
          FontAwesomeIcons.cloudRain,
          size: size,
        );

      case "rain":
        return Icon(
          FontAwesomeIcons.cloudRain,
          size: size,
        );

      case "light rain":
        return Icon(
          FontAwesomeIcons.cloudShowersWater,
          size: size,
        );

      case "patchy rain possible":
        return Icon(
          FontAwesomeIcons.cloudShowersWater,
          size: size,
        );

      //snow cases
      case "snow":
        return Icon(
          FontAwesomeIcons.snowflake,
          size: size,
        );

      case "patchy light snow":
        return Icon(FontAwesomeIcons.snowflake);

      default:
        return Icon(FontAwesomeIcons.sun);
    }
  }

  Widget createExtraMetricsView(AsyncSnapshot<WeatherForecastModel> snapshot) {
    String maxTemp =
        snapshot.data!.forecast!.forecastday![0].day!.maxtempC.toString();
    String minTemp =
        snapshot.data!.forecast!.forecastday![0].day!.mintempC.toString();
    String humidity = snapshot.data!.current!.humidity!.toStringAsFixed(0);
    String windSpeed = snapshot.data!.current!.windKph!.toString();

    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                maxTemp + "º",
                style: TextStyle(fontSize: 18),
              ),
              Icon(
                FontAwesomeIcons.temperatureArrowUp,
                size: 25,
              ),
            ],
          ),
          Column(
            children: [
              Text(
                minTemp + "º",
                style: TextStyle(fontSize: 18),
              ),
              Icon(
                FontAwesomeIcons.temperatureArrowDown,
                size: 25,
              ),
            ],
          ),
          Column(
            children: [
              Text(
                humidity + " %",
                style: TextStyle(fontSize: 18),
              ),
              Icon(
                FontAwesomeIcons.temperatureHigh,
                size: 25,
              ),
            ],
          ),
          Column(
            children: [
              Text(
                windSpeed + " KM/H",
                style: TextStyle(fontSize: 18),
              ),
              Icon(
                FontAwesomeIcons.wind,
                size: 25,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget createBottomView(AsyncSnapshot<WeatherForecastModel> snapshot) {
    var hourlyForecastList = snapshot.data!.forecast!.forecastday![0].hour;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text("24 hours weather forcast for today",style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              Container(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: hourlyForecastList!.length,
                  separatorBuilder: (context, index) => SizedBox(width: 7),
                  itemBuilder: (context, index) => ClipRRect(
                      // borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    height: 150,
                    width: MediaQuery.of(context).size.width / 2.6,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                        // color: Colors.blue
                        ),
                    child: forecastCard(snapshot, index),
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  forecastCard(AsyncSnapshot<WeatherForecastModel> snapshot, int index) {
    //setting the date format that we are receiving from api
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(
        snapshot.data!.forecast!.forecastday![0].hour![index].time.toString()); // <-- dd/MM 24H format
    
    var timeOutputFormat = DateFormat('h:mm a'); //Friday ,September 3
    var outputTime = timeOutputFormat.format(inputDate);
   // print(outputTime);

    var tempC = snapshot.data!.forecast!.forecastday![0].hour![index].tempC;
    var humidity =
        snapshot.data!.forecast!.forecastday![0].hour![index].humidity;
    var windSpeed =
        snapshot.data!.forecast!.forecastday![0].hour![index].windKph;
    var weatherDetail =
        snapshot.data!.forecast!.forecastday![0].hour![index].condition!.text;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(outputTime),
        Text(weatherDetail.toString()),
        getWeatherIcon(weatherDetail!, 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(FontAwesomeIcons.temperatureArrowUp),
            Text(tempC.toString() + "º")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(FontAwesomeIcons.temperatureHigh),
            Text(humidity!.toStringAsFixed(0) + "%")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(FontAwesomeIcons.wind),
            Text(windSpeed.toString() + " KM/H")
          ],
        ),
        //Row(),
      ],
    );
  }
}
