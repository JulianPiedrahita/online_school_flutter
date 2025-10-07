import 'package:flutter/material.dart';

import 'package:eqx/widgets/background.dart';

class EventoFormScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  const EventoFormScreen({Key? key, required this.onSave}) : super(key: key);

  @override
  State<EventoFormScreen> createState() => _EventoFormScreenState();
}

class _EventoFormScreenState extends State<EventoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _nombre = '';
  String _descripcion = '';
  DateTime? _fecha;

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
        title: const Text(
          'Nuevo Evento',
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
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nombre del evento',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) => value == null || value.isEmpty ? 'Ingrese el nombre' : null,
                    onSaved: (value) => _nombre = value ?? '',
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                    maxLines: 3,
                    onSaved: (value) => _descripcion = value ?? '',
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      _fecha == null
                          ? 'Seleccionar fecha'
                          : 'Fecha: \\${_fecha!.day}/\\${_fecha!.month}/\\${_fecha!.year}',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: const Icon(Icons.calendar_today, color: Colors.white),
                    onTap: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: now,
                        firstDate: DateTime(now.year - 5),
                        lastDate: DateTime(now.year + 5),
                      );
                      if (picked != null) {
                        setState(() {
                          _fecha = picked;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text('Guardar Evento', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF16DB93),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        if (_fecha == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Seleccione una fecha')),
                          );
                          return;
                        }
                        widget.onSave({
                          'nombre': _nombre,
                          'descripcion': _descripcion,
                          'fecha': _fecha,
                        });
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
