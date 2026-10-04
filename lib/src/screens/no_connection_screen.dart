import 'package:flutter/material.dart';

/// NoConnectionScreen oferece um feedback visual amigável de tela cheia
/// quando o dispositivo perde a conectividade.
class NoConnectionScreen extends StatelessWidget {
  const NoConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Mantemos o fundo consistente com o resto do app
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFF00457D), Color(0xFF05051F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícone grande e estilizado
            const Icon(
              Icons.wifi_off_rounded,
              size: 120,
              color: Colors.white70,
            ),
            const SizedBox(height: 30),
            const Text(
              'Sem Conexão',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Parece que você está offline. O Climapp precisa de internet para buscar as previsões mais recentes.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 50),
            // Indicador de que o app voltará sozinho
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white24),
              strokeWidth: 2,
            ),
            const SizedBox(height: 10),
            const Text(
              'Aguardando conexão...',
              style: TextStyle(color: Colors.white24, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
