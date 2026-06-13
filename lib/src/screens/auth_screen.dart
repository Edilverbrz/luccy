import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/luccy_controller.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<LuccyController>();
    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Text('Luccy', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  ToggleButtons(
                    isSelected: [ctrl.authState == AuthState.login, ctrl.authState == AuthState.register],
                    onPressed: (i) {
                      ctrl.setAuthState(i == 0 ? AuthState.login : AuthState.register);
                    },
                    children: const [Padding(padding: EdgeInsets.all(8.0), child: Text('Iniciar Sesión')), Padding(padding: EdgeInsets.all(8.0), child: Text('Registrarse'))],
                  ),
                  const SizedBox(height: 16),
                  if (ctrl.authState == AuthState.register)
                    TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
                  const SizedBox(height: 8),
                  TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Correo')),
                  const SizedBox(height: 8),
                  TextField(controller: _passwordCtrl, decoration: const InputDecoration(labelText: 'Contraseña'), obscureText: true),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ctrl.submitAuth(name: _nameCtrl.text);
                    },
                    child: Text(ctrl.authState == AuthState.login ? 'Entrar a mi cuenta' : 'Crear mi cuenta'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
