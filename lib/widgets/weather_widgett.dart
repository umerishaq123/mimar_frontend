import 'package:flutter/material.dart';
import 'package:mimar/widgets/shimmer_widget.dart';
import '../models/weather_model.dart';
import '../providers/location_provider.dart'; // Import your location provider
import 'package:provider/provider.dart';

class WeatherWidget extends StatefulWidget {
  final WeatherModel? weather;
  final bool isLoading;
  final Function(String) onCityChanged;

  const WeatherWidget({
    Key? key,
    required this.weather,
    required this.isLoading,
    required this.onCityChanged,
  }) : super(key: key);

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  @override
  void initState() {
    super.initState();
    // Initialize location when the widget loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);
      locationProvider.initializeLocation().then((_) {
        // When location is fetched, update the weather with current city
        if (locationProvider.currentCity != "Unknown") {
          widget.onCityChanged(locationProvider.currentCity);
        }
      });
    });
  }

  // Helper method to get weather icon
  IconData _getWeatherIcon(String condition) {
    condition = condition.toLowerCase();
    if (condition.contains('sun') || condition.contains('clear')) {
      return Icons.wb_sunny;
    } else if (condition.contains('cloud')) {
      return Icons.cloud;
    } else if (condition.contains('rain')) {
      return Icons.water_drop;
    } else if (condition.contains('snow')) {
      return Icons.ac_unit;
    } else if (condition.contains('thunder') || condition.contains('storm')) {
      return Icons.thunderstorm;
    } else {
      return Icons.cloud;
    }
  }

  @override
  Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final height = size.height;
  final width = size.width;
    // Get location provider
    final locationProvider = Provider.of<LocationProvider>(context);
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.isLoading || locationProvider.isLoading
            ? SizedBox(
        height: height * 0.2, // You can adjust height based on your layout
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                children: [
                  ShimmerWidget.rectangular(
                    width: width * 0.8,
                    height: height * 0.05,
                  ),
 ShimmerWidget.rectangular(
                    width: width * 0.8,
                    height: height * 0.05,
                  ),

                  Row(
                    children: [
                      ShimmerWidget.rectangular(
                    width: width * 0.2,
                    height: height * 0.06,
                  ), 
                 SizedBox(width: width*0.02,),
                   ShimmerWidget.rectangular(
                    width: width * 0.4,
                    height: height * 0.07,
                  ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      )
           
           
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Weather',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          // Refresh both location and weather
                          locationProvider.refreshLocation().then((_) {
                            if (locationProvider.currentCity != "Unknown") {
                              widget.onCityChanged(locationProvider.currentCity);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Current city display (no dropdown)
                  Consumer<LocationProvider>(builder: (context,daata,child){
                    return   Row(
                    children: [
                      const Icon(Icons.my_location, color: Colors.blue),
                      const SizedBox(width: 8),
                      daata.currentCity != "Unknown"
                          ? Text(
                              daata.currentCity,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : daata.error.isNotEmpty
                              ? Text(
                                  'Location unavailable',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                )
                              : const Text('Getting location...'),
                    ],
                  );
                  

                  

                      }

                    ),
                
                  const SizedBox(height: 16),
                  
                  // Weather details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getWeatherIcon(widget.weather?.description??""),
                            size: 60,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.weather?.temperature.toStringAsFixed(1)}°C',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.weather?.description??"",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.water_drop, size: 16, color: Colors.blue),
                              const SizedBox(width: 4),
                              Text('${widget.weather?.humidity??""}%'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.air, size: 16, color: Colors.blue),
                              const SizedBox(width: 4),
                              Text('${widget.weather?.windSpeed??""} km/h'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}