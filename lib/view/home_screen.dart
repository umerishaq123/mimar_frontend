import 'package:flutter/material.dart';
import 'package:mimar/models/weather_model.dart';
import 'package:mimar/providers/location_provider.dart';
import 'package:mimar/providers/quotes_provider.dart';
import 'package:mimar/providers/user_provider.dart';
import 'package:mimar/widgets/shimmer_widget.dart';
import 'package:mimar/widgets/table_widgets.dart';
import 'package:mimar/widgets/weather_widgett.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/quote_widget.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String city = "";
  bool _isInitialized = false;

@override
void didChangeDependencies() {
  super.didChangeDependencies();

  if (!_isInitialized) {
    _isInitialized = true;

    // Schedule the provider updates to happen AFTER build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);
      final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
      final quoteProvider = Provider.of<QuoteProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // Wait for location to be initialized
      await locationProvider.initializeLocation();

      final newCity = locationProvider.currentCity;

      if (mounted) {
        setState(() {
          city = newCity;
        });
      }

      // Fetch other data
      weatherProvider.fetchWeatherData(city);
      quoteProvider.fetchRandomQuote();
      userProvider.fetchUsers();
    });
  }
}

  void _onCityChanged(String city) {
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    weatherProvider.fetchWeatherData(city);
  }

  void _refreshQuote() {
    final quoteProvider = Provider.of<QuoteProvider>(context, listen: false);
    quoteProvider.fetchRandomQuote();
  }

  void _refreshUsers() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUsers();
  }

  void _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    final weatherProvider = Provider.of<WeatherProvider>(context);
    final quoteProvider = Provider.of<QuoteProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather & Motivation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RefreshIndicator(
            onRefresh: () async {
              _onCityChanged(city.isNotEmpty ? city : 'New York');
              _refreshQuote();
              _refreshUsers();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Weather Widget
                  WeatherWidget(
                    weather: weatherProvider.weather,
                    isLoading: weatherProvider.isLoading,
                    onCityChanged: _onCityChanged,
                  ),

                  const SizedBox(height: 16),

                  // Quote Widget or Shimmer
                  quoteProvider.isLoading
                      ? SizedBox(
                          height: height * 0.2,
                          child: ListView.builder(
                            itemCount: 2,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: ShimmerWidget.rectangular(
                                  width: width * 0.8,
                                  height: height * 0.05,
                                ),
                              );
                            },
                          ),
                        )
                      : QuoteWidget(
                          quote: quoteProvider.quote,
                          isLoading: quoteProvider.isLoading,
                          onRefresh: _refreshQuote,
                        ),

                  const SizedBox(height: 16),

                  // Users Table Widget
                  UsersTableWidget(
                    users: userProvider.users,
                    isLoading: userProvider.isLoading,
                    onRefresh: _refreshUsers,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
