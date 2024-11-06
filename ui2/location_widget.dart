import 'dart:async'; // For Timer
import 'dart:convert'; // For jsonDecode
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // For fetching location
import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:shared_preferences/shared_preferences.dart'; // For saving user location

class LocationWidget extends StatefulWidget {
  const LocationWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  String? villageOrCity; // To store the user's village or city
  String? district; // To store the user's district
  String? state; // To store the user's state
  Timer? _timer; // Timer for updating location every 10 seconds

  @override
  void initState() {
    super.initState();
    _startLocationUpdates(); // Start the periodic location updates
  }

  Future<void> _startLocationUpdates() async {
    // Fetch location initially
    await _fetchLocation();

    // Set timer to update location every 10 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      _fetchLocation();
    });
  }

  Future<void> _fetchLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        setState(() {
          villageOrCity = "Location permissions denied";
        });
        return;
      }

      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      //print('Lat: ${position.latitude}, Lon: ${position.longitude}');

      final response = await http.get(
        Uri.parse(
            'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${position.latitude}&longitude=${position.longitude}&localityLanguage=en'),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        villageOrCity = data['locality'] ?? data['city'] ?? 'Unknown Village/Town';
        district = data['localityInfo']?['administrative'][2]?['name'] ?? 'Unknown District';
        state = data['principalSubdivision'] ?? 'Unknown State';

        setState(() {});

        // Save the location in SharedPreferences
        await _saveLocationToPreferences();
      } else {
        setState(() {
          villageOrCity = 'India';
          district = null;
          state = null;
        });
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        villageOrCity = 'Unable to fetch';
        district = null;
        state = null;
      });
      //print('Error fetching location: $error');
    }
  }

  Future<void> _saveLocationToPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('villageOrCity', villageOrCity ?? 'Unknown Village/Town');
    await prefs.setString('district', district ?? 'Unknown District');
    await prefs.setString('state', state ?? 'Unknown State');

    //print('Location saved to SharedPreferences: $villageOrCity, $district, $state');
    _loadLocationFromPreferences();
  }

  Future<void> _loadLocationFromPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      villageOrCity = prefs.getString('villageOrCity') ?? 'Unknown Village/Town';
      district = prefs.getString('district') ?? 'Unknown District';
      state = prefs.getString('state') ?? 'Unknown State';
    });

    //print('🆘 Location loaded from SharedPreferences: $villageOrCity, $district, $state');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on,
                  size: 30, color: Color.fromARGB(255, 255, 88, 5)),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    villageOrCity ?? 'Fetching location...',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'AfacadFlux',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    (district != null && state != null)
                        ? '$district, $state'
                        : 'Fetching location...',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontFamily: 'AfacadFlux',
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Menu Button to Open Drawer
          IconButton(
            icon: const Icon(Icons.menu, size: 30, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openEndDrawer(); // Open the end drawer (menu)
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Stop the timer when the widget is disposed
    super.dispose();
  }
}
