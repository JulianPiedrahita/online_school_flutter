import 'package:flutter/material.dart';

import 'package:eqx/widgats/background.dart';
import 'package:eqx/widgats/card_table_responsive.dart';
import 'package:eqx/widgats/custom_bottom_navigation.dart';
import 'package:eqx/widgats/page_title.dart';
import 'package:eqx/controllers/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  final AuthController authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildSecureAppBar(context),
      body: Stack(
        children: [
          // Background
          Background(),
          // Home Body
          _HomeBody()
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(),
   );
  }

  /// AppBar seguro con información del usuario y botón de logout
  PreferredSizeWidget _buildSecureAppBar(BuildContext context) {
    return AppBar(
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
      title: Row(
        children: [
          Icon(
            Icons.home,
            color: Colors.white,
            size: 24,
          ),
          SizedBox(width: 8),
          Text(
            'Home',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        // Información del usuario
        _buildUserInfo(context),
        // Botón de logout
        _buildSecureLogoutButton(context),
        SizedBox(width: 8),
      ],
    );
  }

  /// Widget con información del usuario actual
  Widget _buildUserInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Color(0xFF0F3460),
              size: 18,
            ),
          ),
          SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authController.currentUser?.firstName ?? 'Usuario',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'En línea',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Botón de logout seguro con confirmación
  Widget _buildSecureLogoutButton(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person, color: Color(0xFF0F3460), size: 20),
              SizedBox(width: 12),
              Text(
                'Mi Perfil',
                style: TextStyle(
                  color: Color(0xFF0F3460),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings, color: Color(0xFF0F3460), size: 20),
              SizedBox(width: 12),
              Text(
                'Configuración',
                style: TextStyle(
                  color: Color(0xFF0F3460),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.red, size: 20),
              SizedBox(width: 12),
              Text(
                'Cerrar Sesión',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (value) => _handleMenuAction(context, value),
    );
  }

  /// Maneja las acciones del menú con seguridad
  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'profile':
        _showUserProfile(context);
        break;
      case 'settings':
        _showSettings(context);
        break;
      case 'logout':
        _showSecureLogoutConfirmation(context);
        break;
    }
  }

  /// Muestra el perfil del usuario
  void _showUserProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.person, color: Color(0xFF16DB93)),
            SizedBox(width: 8),
            Text('Mi Perfil'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileField('Nombre', authController.currentUser?.fullName ?? 'N/A'),
            _buildProfileField('Email', authController.currentUser?.email ?? 'N/A'),
            _buildProfileField('Teléfono', authController.currentUser?.phone ?? 'N/A'),
            _buildProfileField('Ciudad', authController.currentUser?.city ?? 'N/A'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F3460),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Muestra configuraciones
  void _showSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Configuración - Próximamente'),
        backgroundColor: Color(0xFF16DB93),
      ),
    );
  }

  /// Diálogo de confirmación de logout con mejores prácticas de seguridad
  void _showSecureLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // No se puede cerrar tocando afuera (seguridad)
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.logout,
              color: Colors.red,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              'Cerrar Sesión',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Estás seguro que deseas cerrar sesión?',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF0F3460),
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.security,
                    color: Colors.orange,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tu sesión será cerrada de forma segura y tendrás que iniciar sesión nuevamente.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Botón Cancelar
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[600],
            ),
            child: Text(
              'Cancelar',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          // Botón Cerrar Sesión
          ElevatedButton(
            onPressed: () => _performSecureLogout(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Cerrar Sesión',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  /// Ejecuta el logout seguro siguiendo mejores prácticas
  Future<void> _performSecureLogout(BuildContext context) async {
    try {
      // Cerrar diálogo de confirmación
      Navigator.pop(context);
      
      // Mostrar indicador de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF16DB93)),
                ),
                SizedBox(height: 16),
                Text(
                  'Cerrando sesión de forma segura...',
                  style: TextStyle(
                    color: Color(0xFF0F3460),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Realizar logout seguro
      await authController.logout();
      
      // Pequeña pausa para UX (opcional)
      await Future.delayed(Duration(seconds: 1));
      
      // Cerrar indicador de carga
      Navigator.pop(context);
      
      // Navegar al login de forma segura (limpiar stack completo)
      Navigator.pushNamedAndRemoveUntil(
        context,
        'login_screen',
        (route) => false, // Remover todas las rutas anteriores por seguridad
      );
      
      // Mostrar confirmación de logout exitoso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Sesión cerrada correctamente'),
            ],
          ),
          backgroundColor: Color(0xFF16DB93),
          duration: Duration(seconds: 2),
        ),
      );
      
    } catch (e) {
      // Manejar errores durante el logout
      Navigator.pop(context); // Cerrar loading si está abierto
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Text('Error al cerrar sesión. Inténtalo de nuevo.'),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}

class _HomeBody extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        // Titulos (fijo, siempre visible)
        PageTitle(),

        // Card Table (con scroll)
        Expanded(
          child: SingleChildScrollView(
            child: CardTableResponsive(),
          ),
        ),
      
      ],
    );
  }
}