import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:eqx/widgets/custom_bottom_navigation.dart';
import 'package:eqx/widgets/background.dart';
import 'dart:async';

class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  LatLng? userLocation;
  LatLng? casaDePazLocation;
  String? error;
  Stream<Position>? _positionStream;
  StreamSubscription<Position>? _positionSubscription;

  @override
  void initState() {
    super.initState();
    _loadLocations();
    _positionStream = Geolocator.getPositionStream(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
    _positionSubscription = _positionStream?.listen((Position position) {
      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
      });
    });
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadLocations() async {
    try {
      // Obtener ubicación inicial del usuario
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
      });
      // Obtener ubicación de la Casa de Paz
      final casa = CustomBottomNavigation.casaDePaz;
      if (casa != null) {
        String address = "${casa['direccion']}, ${casa['ciudad']}, ${casa['pais'] ?? ''}";
        List<Location> locations = await locationFromAddress(address);
        if (locations.isNotEmpty) {
          setState(() {
            casaDePazLocation = LatLng(locations.first.latitude, locations.first.longitude);
          });
        }
      }
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0F3460).withOpacity(0.9),
                Color(0xFF16DB93).withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('Mapa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: Stack(
        children: [
          Background(),
          if (error != null)
            Center(child: Text('Error: $error'))
          else if (userLocation == null && casaDePazLocation == null)
            Center(child: CircularProgressIndicator())
          else
            FlutterMap(
              options: MapOptions(
                initialCenter: casaDePazLocation ?? userLocation!,
                initialZoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                if (userLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 60.0,
                        height: 60.0,
                        point: userLocation!,
                        child: Icon(Icons.person_pin_circle, color: Colors.blue, size: 40),
                      ),
                    ],
                  ),
                if (casaDePazLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 60.0,
                        height: 60.0,
                        point: casaDePazLocation!,
                        child: Icon(Icons.home, color: Colors.red, size: 40),
                      ),
                    ],
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
