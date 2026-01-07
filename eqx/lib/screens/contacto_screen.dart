import 'package:flutter/material.dart';
import 'package:eqx/widgets/background.dart';
import 'package:eqx/widgets/sticky_navigation_menu.dart';

class ContactoScreen extends StatefulWidget {
  @override
  _ContactoScreenState createState() => _ContactoScreenState();
}

class _ContactoScreenState extends State<ContactoScreen> {
  final _formKey = GlobalKey<FormState>();
  String nombre = '';
  String ciudad = '';
  String telefono = '';
  String correo = '';
  String mensaje = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Column(
            children: [
              StickyNavigationMenu(),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 420),
                      padding: const EdgeInsets.all(32.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 16,
                            offset: Offset(0, 8),
                          ),
                        ],
                        border: Border.all(color: Colors.white.withOpacity(0.18)),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Contáctenos',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(height: 28),
                            _buildTextField(
                              label: 'Nombre',
                              onSaved: (value) => nombre = value ?? '',
                              validator: (value) => value == null || value.isEmpty ? 'Ingrese su nombre' : null,
                            ),
                            SizedBox(height: 16),
                            _buildTextField(
                              label: 'Ciudad',
                              onSaved: (value) => ciudad = value ?? '',
                              validator: (value) => value == null || value.isEmpty ? 'Ingrese su ciudad' : null,
                            ),
                            SizedBox(height: 16),
                            _buildTextField(
                              label: 'Teléfono',
                              keyboardType: TextInputType.phone,
                              onSaved: (value) => telefono = value ?? '',
                              validator: (value) => value == null || value.isEmpty ? 'Ingrese su teléfono' : null,
                            ),
                            SizedBox(height: 16),
                            _buildTextField(
                              label: 'Correo electrónico',
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (value) => correo = value ?? '',
                              validator: (value) => value == null || value.isEmpty ? 'Ingrese su correo' : null,
                            ),
                            SizedBox(height: 16),
                            _buildTextField(
                              label: 'Mensaje',
                              maxLines: 4,
                              onSaved: (value) => mensaje = value ?? '',
                              validator: (value) => value == null || value.isEmpty ? 'Ingrese su mensaje' : null,
                            ),
                            SizedBox(height: 28),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff40916C),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  _formKey.currentState?.save();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Formulario enviado')),
                                  );
                                }
                              },
                              child: Text('Enviar'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xff40916C), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.redAccent),
        ),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: validator,
    );
  }
}
