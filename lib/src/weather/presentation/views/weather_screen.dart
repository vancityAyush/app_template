import 'package:app_template/src/authentication/presentation/widgets/loading_column.dart';
import 'package:app_template/src/weather/presentation/bloc/weather_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController cityNameController = TextEditingController();

  void fetchWeather() {
    context
        .read<WeatherBloc>()
        .add(const FetchLocationWeatherEvent(lat: "12.9716", long: "77.5946"));
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeatherBloc, WeatherState>(
      listener: (context, state) {
        if (state is WeatherError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        } else if (state is WeatherLoaded) {
          // getUsers();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: state is WeatherInitial || state is FetchingWeather
              ? const LoadingColumn(message: "Fetching weather")
              : state is WeatherLoaded
                  ? SafeArea(
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.weather.name),
                            Text(state.weather.main),
                            Text(state.weather.description),
                            Text(state.weather.temp.toString()),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (context) => Dialog(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: cityNameController,
                                decoration: const InputDecoration(
                                  hintText: "Enter city name",
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  context.read<WeatherBloc>().add(
                                        FetchCityWeatherEvent(
                                          cityName: cityNameController.text,
                                        ),
                                      );
                                },
                                child: const Text("Fetch"),
                              ),
                            ],
                          ),
                        ),
                      ));
            },
            child: const Icon(Icons.search),
          ),
        );
      },
    );
  }
}
