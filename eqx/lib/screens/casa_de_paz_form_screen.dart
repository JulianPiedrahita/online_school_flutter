import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:eqx/widgets/background.dart';

/// Para seguridad, NO coloques la API Key de Google Maps directamente en el código fuente.
/// Pásala como parámetro desde un archivo seguro, variable de entorno, o desde el backend.
class CasaDePazFormScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final String googleApiKey;
  const CasaDePazFormScreen({Key? key, required this.onSave, required this.googleApiKey}) : super(key: key);

  @override
  State<CasaDePazFormScreen> createState() => _CasaDePazFormScreenState();
}

class _CasaDePazFormScreenState extends State<CasaDePazFormScreen> {
  Future<void> _obtenerUbicacionActual() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Permiso de ubicación denegado.')),
          );
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permiso de ubicación denegado permanentemente.')),
        );
        return;
      }
      setState(() { _isLoading = true; });
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _direccion = place.street ?? '';
          _ciudad = place.locality ?? place.subAdministrativeArea ?? '';
          _pais = place.country ?? '';
        });
        _formKey.currentState?.reset();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error obteniendo ubicación: ${e.toString()}')),
      );
    } finally {
      setState(() { _isLoading = false; });
    }
  }
  /// Usa widget.googleApiKey para acceder a la clave de Google Maps.
  String _pais = '';

  Future<List<double>?> _googleGeocode(String direccion, String ciudad, String pais) async {
    final fullAddress = '$direccion, $ciudad, $pais';
    final url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(fullAddress)}&key=${widget.googleApiKey}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['status'] == 'OK' && decoded['results'].isNotEmpty) {
        final loc = decoded['results'][0]['geometry']['location'];
        return [loc['lat'] * 1.0, loc['lng'] * 1.0];
      }
    }
    return null;
  }
  final _formKey = GlobalKey<FormState>();
  String _responsable = '';
  String _direccion = '';
  String _ciudad = '';

  bool _isLoading = false;

  Future<void> _guardarCasaDePaz() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState?.save();
    if (_direccion.isEmpty || _ciudad.isEmpty || _pais.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor ingresa dirección, ciudad y país.')),
      );
      return;
    }
    setState(() { _isLoading = true; });
    try {
      final coords = await _googleGeocode(_direccion, _ciudad, _pais);
      if (coords == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo encontrar la ubicación. Verifica dirección, ciudad y país.')),
        );
        setState(() { _isLoading = false; });
        return;
      }
      widget.onSave({
        'responsable': _responsable,
        'direccion': _direccion,
        'ciudad': _ciudad,
        'pais': _pais,
        'lat': coords[0],
        'lng': coords[1],
      });
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
        title: const Text(
          'Casa de Paz',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Stack(
        children: [
          Background(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Row(
                    children: [
                      Expanded(child:
                        Text('Completa los campos o usa el GPS para autocompletar tu ubicación.', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ),
                      IconButton(
                        icon: Icon(Icons.my_location, color: Color(0xFF16DB93)),
                        tooltip: 'Usar mi ubicación',
                        onPressed: _isLoading ? null : _obtenerUbicacionActual,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nombre del responsable',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) => value == null || value.isEmpty ? 'Ingrese el nombre' : null,
                    onSaved: (value) => _responsable = value ?? '',
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Dirección',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.white),
                      helperText: 'Ejemplo: Calle 123 #45-67, Barrio',
                      helperStyle: TextStyle(color: Colors.white70),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) => value == null || value.isEmpty ? 'Ingrese la dirección' : null,
                    onSaved: (value) => _direccion = value ?? '',
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Ciudad',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) => value == null || value.isEmpty ? 'Ingrese la ciudad' : null,
                    onSaved: (value) => _ciudad = value ?? '',
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'País',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.white),
                      helperText: 'Ejemplo: Colombia',
                      helperStyle: TextStyle(color: Colors.white70),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) => value == null || value.isEmpty ? 'Ingrese el país' : null,
                    onSaved: (value) => _pais = value ?? '',
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text('Guardar', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF16DB93),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _isLoading ? null : _guardarCasaDePaz,
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
