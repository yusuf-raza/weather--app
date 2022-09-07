import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/intl.dart';
import 'package:weather_forecast/model/weather_forecast_model.dart';
import 'package:weather_forecast/network/weather_forecast_network_class.dart';
import 'package:weather_forecast/ui/middle_view_ui.dart';

import 'model/weather_forecast_model.dart';

class WeatherForecast extends StatefulWidget {
  const WeatherForecast({Key? key}) : super(key: key);

  @override
  State<WeatherForecast> createState() => _WeatherForecastState();
}

class _WeatherForecastState extends State<WeatherForecast> {
  late Future<WeatherForecastModel> weatherForecastModelObject;

  String selectedCity = "karachi";
  WeatherView weatherView = new WeatherView();

  @override
  void initState() {
    weatherForecastModelObject =
        WeatherForecastNetwork().getForecast(selectedCity);
    FlutterNativeSplash.remove();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('asset/images/night.png'),
                fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: FutureBuilder<WeatherForecastModel>(
          future: weatherForecastModelObject,
              builder: (BuildContext context,
              AsyncSnapshot<WeatherForecastModel> snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textFieldView(),
                  weatherView.createWeatherView(snapshot),
                  weatherView.createExtraMetricsView(snapshot),
                  weatherView.createBottomView(snapshot)
                ],
              );
            } else {
              return Center(
                  child: CircularProgressIndicator());
            }
          }),
        ),
      ),
    );
  }

  Widget textFieldView() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        child: TextField(
          keyboardType: TextInputType.text,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
            ],
          decoration: InputDecoration(
            hintText: "change the city...",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.all(8),
          ),
          onSubmitted: (value) => {
            setState(() {
              selectedCity = value;
              weatherForecastModelObject =
                  WeatherForecastNetwork().getForecast(selectedCity);
            })
          },
        ),
      ),
    );
  }
}
