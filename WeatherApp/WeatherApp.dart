import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//final city = 'Istanbul';
final appId = '68306701fa89e513c79ab4b18de3f2fa';
//final apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=68306701fa89e513c79ab4b18de3f2fa&units=metric';

//styling
TextStyle TempStyle(){
  return TextStyle(
    fontSize: 20.0,
  );
}

void main() => runApp(MyApp()); /* using arrow notation because it's a one-line function*/

class MyApp extends StatelessWidget {

//  void showStuff() async{
//    Map data = await getWeather(apiUrl);
//    print(data.toString()); //for debugging
//  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter', /* This appears above app in "recent apps" window. This value is not used in iOS*/
      home: Scaffold(
        appBar: AppBar(
          title: Text('weather app'), /* this appears on the app bar*/
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              updateTempWidget('Adana'),
            ],
          ),
        ),
      ),
    );
  }
}

//the function that gets info from the api
Future<Map> getWeather(String appId, String city) async
{
  String apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$appId&units=metric'; //the api call that has all the info we need
  http.Response response = await http.get(apiUrl); //perform HTTP GET method (gets data from api), and store the response in a variable
  return jsonDecode(response.body); //return the body of the response as a map object
}

//the function that arranges the info from the api into a widget
Widget updateTempWidget(String city)
{
  return new FutureBuilder(
      future: getWeather(appId, city), //the name of the Future function you want to build a widget for
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot){  //first argument is standard, not sure what AsyncSnapshot does
        if(snapshot.hasData){
          Map content = snapshot.data;
          return Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'City: ' + content['name'],
                      style: TempStyle(),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'rain presence: ' + content['weather'][0]['main'],
                      style: TempStyle(),
                    ),
                    trailing: Icon(Icons.cloud),
                  ),
                  ListTile(
                    title: Text(
                      'Temperature: ' + content['main']['temp'].toString(), //convert the double values to strings to be able to put them in a Text()
                      style: TempStyle(),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'feels like: ' + content['main']['feels_like'].toString(),
                      style: TempStyle(),
                    ),
                  ),
                ],
              ),
          );
        }
        else
          return Container(); //without this line, errors arise. Must provide else block for if statement
      }
  );
}

//to-do
//this function can display corresponding images to weather states (eg: rainy, mist, cloudy, foggy, clear)
// by using if statements and asset images
Widget WeatherIcon(String weather){
  if(weather == 'mist')
    {
      return Image.asset('mist.png'); //usage example
    }
}
