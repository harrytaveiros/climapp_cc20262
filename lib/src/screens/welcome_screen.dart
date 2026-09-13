import 'package:climapp_cc20262/src/controller/region_controller.dart';
import 'package:climapp_cc20262/src/screens/list_city_screen.dart';
import 'package:climapp_cc20262/src/widgets/region_badge_widget.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // Injeção do Controller seguindo o padrão MVC
  final RegionController _regionController = RegionController();

  @override
  void initState() {
    super.initState();
    // Dispara a captura da região logo na inicialização da tela
    _regionController.updateRegion();
  }

  @override
  void dispose() {
    _regionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // CAMADA 1: Conteúdo Principal (Background e Elementos)
          DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[Color(0xFF00457D), Color(0xFF05051F)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 70), // Ajustado para não colidir com o badge
                  Image.asset("assets/logo_climapp.png", width: 200),
                  const SizedBox(height: 40),
                  Image.asset("assets/ilustracao_home.png", width: 250),
                  const SizedBox(height: 40),
                  const Text(
                    'Boas-vindas!',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ListCityScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7693FF),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Entrar',
                            style: TextStyle(color: Colors.black, fontSize: 25),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward,
                              color: Colors.black, size: 25),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),

          // CAMADA 2: Badge de Região Flutuante (UI Reativa)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 20,
            child: ListenableBuilder(
              listenable: _regionController,
              builder: (context, _) {
                return RegionBadgeWidget(emoji: _regionController.countryEmoji);
              },
            ),
          ),
        ],
      ),
    );
  }
}
