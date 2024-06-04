import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/view_models/weather_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final cityController = TextEditingController(text: "Tashkent");
  final weatherViewmodel = WeatherViewmodel();
  Weather? weather;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    getWeather();
  }

  void getWeather() async {
    setState(() {
      isLoading = true;
    });
    weather = await weatherViewmodel.getWeather(cityController.text);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text("Ob Havo"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          TextField(
            controller: cityController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: "Shahar",
              suffixIcon: IconButton(
                onPressed: getWeather,
                icon: const Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 20),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : weather == null
                  ? const Center(
                      child: Text(
                        "Shahar topilmadi.\nIltimos boshqa shaharni kiriting.",
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Column(
                      children: [
                        Text(
                          weather!.city,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              weather!.temperature.toString(),
                              style: const TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                            const Text(
                              "℃",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              weather!.main,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Image.network(
                              "https://openweathermap.org/img/wn/${weather!.icon}@2x.png",
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress != null) {
                                  return const CircularProgressIndicator();
                                }
                                return child;
                              },
                              width: 40,
                            ),
                          ],
                        ),
                        Text(
                          "Air Quality Index: ${weather!.airQualityIndex ?? 0}",
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    )
        ],
      ),
    );
  }
}
