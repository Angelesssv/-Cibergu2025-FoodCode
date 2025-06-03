import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _isEmailVerified = false;
  bool _isTwoFactorEnabled = false;

  void _showConfirmationDialog({
    required String title,
    required String content,
    required String confirmButtonText,
    required VoidCallback onConfirm,
    Color confirmButtonColor = Colors.red,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title, style: TextStyle(color: AppColors.azulOscuro)),
          content: Text(content, style: TextStyle(color: AppColors.azulOscuro.withOpacity(0.8))),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: confirmButtonColor),
              child: Text(confirmButtonText, style: const TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onConfirm();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seguridad de la Cuenta'),
        backgroundColor: AppColors.verdeMedio,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              elevation: 2.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Correo Electrónico', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.azulOscuro)),
                    const SizedBox(height: 8),
                    Text('usuario_fresko@ejemplo.com', style: TextStyle(fontSize: 16, color: AppColors.azulOscuro.withOpacity(0.8))),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          _isEmailVerified ? 'Verificado ' : 'No verificado ',
                          style: TextStyle(fontSize: 14, color: _isEmailVerified ? AppColors.verdeMedio : Colors.orange.shade700),
                        ),
                        Icon(
                          _isEmailVerified ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                          color: _isEmailVerified ? AppColors.verdeMedio : Colors.orange.shade700,
                          size: 18,
                        ),
                        const Spacer(),
                        if (!_isEmailVerified)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Correo de verificación enviado (simulación)')),
                                );
                              });
                            },
                            style: TextButton.styleFrom(
                                foregroundColor: AppColors.verdeClaro,
                                backgroundColor: AppColors.verdeMedio.withOpacity(0.1),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                            ),
                            child: const Text('Verificar'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
                margin: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 12.0),
                elevation: 2.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.lock_outline_rounded, color: AppColors.turquesa, size: 26),
                      title: const Text('Cambiar contraseña', style: TextStyle(fontSize: 16, color: AppColors.azulOscuro)),
                      trailing: Icon(Icons.arrow_forward_ios, color: AppColors.azulOscuro.withOpacity(0.6), size: 16),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ir a Cambiar Contraseña (pendiente)')),
                        );
                      },
                    ),
                    const Divider(height: 0.5, indent: 70, color: Colors.black26),
                    SwitchListTile(
                      title: const Text('Autenticación de Dos Factores (2FA)', style: TextStyle(fontSize: 16, color: AppColors.azulOscuro)),
                      value: _isTwoFactorEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _isTwoFactorEnabled = value;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('2FA ${value ? "activada" : "desactivada"} (simulación)')),
                          );
                        });
                      },
                      secondary: Icon(Icons.phonelink_lock_outlined, color: AppColors.turquesa, size: 26),
                      activeColor: AppColors.verdeMedio,
                    ),
                    const Divider(height: 0.5, indent: 70, color: Colors.black26),
                    ListTile(
                      leading: Icon(Icons.history_toggle_off_outlined, color: AppColors.turquesa, size: 26),
                      title: const Text('Historial de inicio de sesión', style: TextStyle(fontSize: 16, color: AppColors.azulOscuro)),
                      trailing: Icon(Icons.arrow_forward_ios, color: AppColors.azulOscuro.withOpacity(0.6), size: 16),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ver Historial (pendiente)')),
                        );
                      },
                    ),
                  ],
                )
            ),
            Card(
                margin: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 12.0),
                elevation: 2.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.logout_outlined, color: AppColors.turquesa, size: 26),
                      title: const Text('Cerrar sesión', style: TextStyle(fontSize: 16, color: AppColors.azulOscuro)),
                      onTap: () {
                        _showConfirmationDialog(
                            title: 'Cerrar Sesión',
                            content: '¿Estás seguro de que quieres cerrar tu sesión actual?',
                            confirmButtonText: 'Cerrar Sesión',
                            confirmButtonColor: AppColors.turquesa,
                            onConfirm: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Sesión cerrada (simulación)')),
                              );
                            }
                        );
                      },
                    ),
                    const Divider(height: 0.5, indent: 70, color: Colors.black26),
                    ListTile(
                      leading: Icon(Icons.delete_forever_outlined, color: Colors.red.shade400, size: 26),
                      title: Text('Eliminar cuenta', style: TextStyle(fontSize: 16, color: Colors.red.shade700)),
                      onTap: () {
                        _showConfirmationDialog(
                            title: 'Eliminar Cuenta',
                            content: '¡Atención! Esta acción es irreversible y todos tus datos se perderán. ¿Estás completamente seguro?',
                            confirmButtonText: 'Sí, Eliminar',
                            confirmButtonColor: Colors.red.shade700,
                            onConfirm: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Cuenta eliminada (simulación)')),
                              );
                            }
                        );
                      },
                    ),
                  ],
                )
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Consejos de Seguridad:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.azulOscuro)),
                  const SizedBox(height: 8),
                  Text('• Usa contraseñas únicas y fuertes.', style: TextStyle(fontSize: 14, color: AppColors.azulOscuro.withOpacity(0.8))),
                  Text('• Activa la autenticación de dos factores para mayor protección.', style: TextStyle(fontSize: 14, color: AppColors.azulOscuro.withOpacity(0.8))),
                  Text('• No compartas tus credenciales con nadie.', style: TextStyle(fontSize: 14, color: AppColors.azulOscuro.withOpacity(0.8))),
                  Text('• Cuidado con los correos y mensajes de phishing.', style: TextStyle(fontSize: 14, color: AppColors.azulOscuro.withOpacity(0.8))),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}// TODO Implement this library.