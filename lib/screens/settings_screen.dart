import 'package:flutter/material.dart';
import '../config/app_colors.dart'; // Nuestros colores
// Importaremos las sub-pantallas cuando las creemos
import 'accessibility_settings_screen.dart';
import 'security_settings_screen.dart';
// import 'support_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    required Color iconColor,
    required Color textColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor, size: 26),
      title: Text(title, style: TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12)) : null,
      trailing: onTap != null
          ? Icon(Icons.arrow_forward_ios, color: textColor.withOpacity(0.6), size: 16)
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color headerBackgroundColor = AppColors.verdeMuyClaro.withOpacity(0.6);
    final Color headerTextColor = AppColors.azulOscuro;
    final Color listTileTextColor = AppColors.azulOscuro;
    final Color iconColor = AppColors.turquesa;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        backgroundColor: AppColors.verdeMedio,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
              color: headerBackgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: AppColors.turquesa.withOpacity(0.8),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 65,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Usuario Fresko',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: headerTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@usuario_fresko',
                    style: TextStyle(
                      fontSize: 16,
                      color: headerTextColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Card(
              margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              elevation: 1.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _buildSettingsTile(
                    context: context,
                    icon: Icons.account_box_outlined,
                    title: 'Datos personales',
                    subtitle: 'Edita tu información de perfil',
                    iconColor: iconColor,
                    textColor: listTileTextColor,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Navegar a Datos Personales (pendiente)')),
                      );
                    },
                  ),
                  const Divider(height: 0.5, indent: 70, color: Colors.black26),
                  _buildSettingsTile(
                    context: context,
                    icon: Icons.shield_outlined,
                    title: 'Seguridad',
                    subtitle: 'Gestiona tu contraseña y seguridad',
                    iconColor: iconColor,
                    textColor: listTileTextColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SecuritySettingsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),

            Card(
              margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              elevation: 1.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _buildSettingsTile(
                    context: context,
                    icon: Icons.visibility_outlined,
                    title: 'Accesibilidad',
                    subtitle: 'Opciones de visualización y tema',
                    iconColor: iconColor,
                    textColor: listTileTextColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AccessibilitySettingsScreen()),
                      );
                    },
                  ),
                  const Divider(height: 0.5, indent: 70, color: Colors.black26),
                  _buildSettingsTile(
                    context: context,
                    icon: Icons.help_outline_rounded,
                    title: 'Soporte',
                    subtitle: 'Contacta con nosotros y FAQs',
                    iconColor: iconColor,
                    textColor: listTileTextColor,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Navegar a Soporte (pendiente)')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class SecuritySettingsScreen {
  const SecuritySettingsScreen();
}