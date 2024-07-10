import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/Hourly_forecast_item.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';
import 'package:intl/intl.dart';



class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
 late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather () async{
    String cityName = "London";
    
    try{
      
      final res = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$openWeatherAPI')
    );
    final data = jsonDecode(res.body);

    if(data['cod']!='200'){
      throw 'An unexpected error occured';
    }

    
      return data;
      
    

    }catch(e){
      throw e.toString();
    }
    
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,

          ),
        ),
        centerTitle: true,

        actions:[
          IconButton(
            onPressed: (){
              setState(() {
                weather = getCurrentWeather();
              });
            }, 
            icon: const Icon(Icons.refresh))
        ],
      ), 

      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final pressure = currentWeatherData['main']['pressure'];
          final windSpeed = currentWeatherData['wind']['speed'];
          final humidity = currentWeatherData['main']['humidity'];
          return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //main Card
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Text(
                            "$currentTemp K",
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold
                            ),
                            ),
                              const SizedBox(height: 20),
                            Icon(
                              currentSky == 'Clouds' || currentSky == 'Rain' ? Icons.cloud : Icons.sunny,
                              size: 60,
                            ),
                              const  SizedBox(height: 20),
                              Text(
                              '$currentSky',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //Weather forcast cards
              const SizedBox(
                height: 20,
              ),
              const Text("Weather Forcast",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              ),
              const SizedBox(
                height: 10,
              ),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //     for(int i = 0; i < 5; i++)
              //     HourlyForecastItem(
              //       time: data['list'][i+1]['dt'].toString(),
              //       icon: data['list'][i+1]['weather'][0]['main'] == 'Clouds' || data['list'][i+1]['weather'][0]['main'] == 'Rain' ? Icons.cloud : Icons.sunny,
              //       temperature: data['list'][i+1]['main']['temp'].toString(),
              //     ),                
                                     
              //     ],
              //   ),
              // ),

              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index){
                    final hourlyForecast = data['list'][index+1];
                    final hourlySky = data['list'][index+1]['weather'][0]['main'];
                    final hourlyTemp = hourlyForecast['main']['temp'].toString();
                    final time = DateTime.parse(hourlyForecast['dt'].toString());
                    return HourlyForecastItem(
                      time: DateFormat.j().format(time), 
                      icon: hourlySky=='Clouds' || hourlySky ==  'Rain' ? Icons.cloud : Icons.sunny, 
                      temperature: hourlyTemp
                    );
                  }
                ),
              ),
              //Other details
              const SizedBox(height: 20),
              const Text("Additional Information",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(255, 242, 0, 1),
                fontSize: 25,
              ),
              ),
        
              const SizedBox(height: 20),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AdditionalInfoItem(
                    icon: Icons.water_drop,
                    label: 'Humidity',
                    value: humidity.toString(),
                  ),
                  AdditionalInfoItem(
                    icon: Icons.air,
                    label: "Wind Speed",
                    value: windSpeed.toString(),
                  ),
                  AdditionalInfoItem(
                    icon: Icons.umbrella,
                    label: "Pressure",
                    value: pressure.toString(),
                  ),
                ],
              ),
            ],
          ),
        );
        },
      ),
    );
  }
}



