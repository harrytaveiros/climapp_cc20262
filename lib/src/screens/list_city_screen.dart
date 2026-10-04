import 'package:climapp_cc20262/src/controller/list_city_controller.dart';
import 'package:climapp_cc20262/src/screens/weather_city_screen.dart';
import 'package:climapp_cc20262/src/widgets/city_tile_widget.dart';
import 'package:climapp_cc20262/src/screens/no_connection_screen.dart';
import 'package:flutter/material.dart';

class ListCityScreen extends StatefulWidget {
  const ListCityScreen({super.key});

  @override
  _ListCityScreenState createState() => _ListCityScreenState();
}

class _ListCityScreenState extends State<ListCityScreen> {
  final TextEditingController textController = TextEditingController();

  final ListCityController controller = ListCityController();

  @override
  void initState() {
    super.initState();
    controller.loadCities();
  }

  @override
  void dispose() {
    textController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        // REQUISITO: Se o dispositivo estiver offline, retorna diretamente a NoConnectionScreen
        // Isso garante a recuperação automática, pois o controller notificará o rebuild ao voltar online.
        if (controller.isOffline) {
          return const NoConnectionScreen();
        }

        return Scaffold(
          body: DecoratedBox(
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
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 25),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: textController,
                    onChanged: controller.filterCities,
                    decoration: const InputDecoration(
                      fillColor: Color(0xff15ffffff),
                      filled: true,
                      hintText: 'Digite uma cidade',
                      hintStyle: TextStyle(color: Colors.white),
                      suffixIcon: Icon(Icons.search, color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: _buildMainContent(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Constrói o conteúdo principal (Carregamento, Erro de API ou Lista)
  Widget _buildMainContent() {
    // 1. CARREGAMENTO
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2. ERRO DE API (Caso haja internet, mas a requisição falhou)
    if (controller.errorMessage != null && controller.errorMessage!.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white70,
              size: 80,
            ),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => controller.loadCities(),
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    // 3. ESTADO DE SUCESSO: Lista de cidades
    return ListView.builder(
      itemCount: controller.filteredCities.length,
      itemBuilder: (context, index) {
        final city = controller.filteredCities[index];
        return CityTileWidget(
          cityName: city.cityName,
          icon: city.conditionSlug,
          temperature: city.temp,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WeatherCityScreen(
                  weatherForecastModel: city,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
