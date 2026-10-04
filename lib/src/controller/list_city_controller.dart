import 'package:flutter/material.dart';
import '../models/weather_forecast_model.dart';
import '../services/weather_service.dart';
import '../services/network_service.dart';

/// ListCityController gerencia a lógica de busca e filtragem de cidades.
/// Agora integra o NetworkService para monitorar a conexão em tempo real.
class ListCityController extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final NetworkService _networkService = NetworkService();

  List<WeatherForecastModel> allCities = [];
  List<WeatherForecastModel> filteredCities = [];
  bool isLoading = true;
  String? errorMessage;

  /// Getter para expor o estado de conexão
  bool get isOffline => !_networkService.isOnline.value;

  final listCitySearch = [
    'Aracaju,SE',
    'Itabaiana,SE',
    'Salvador,BA',
    'Curitiba,PR',
  ];

  ListCityController() {
    _initNetworkListener();
  }

  /// Escuta mudanças na conexão e reage automaticamente
  void _initNetworkListener() {
    _networkService.isOnline.addListener(() {
      if (_networkService.isOnline.value) {
        // Se voltou a ficar online e a lista está vazia ou com erro, tenta carregar
        if (allCities.isEmpty || errorMessage != null) {
          loadCities();
        }
      } else {
        errorMessage = 'Você está offline. Verifique sua conexão.';
      }
      notifyListeners();
    });
  }

  /// Carrega a previsão do tempo para a lista pré-definida de cidades.
  Future<void> loadCities() async {
    if (isOffline) {
      errorMessage = 'Sem conexão com a internet.';
      isLoading = false;
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final List<WeatherForecastModel> fetchedCities = [];
      for (var city in listCitySearch) {
        final model = await _weatherService.fetchForecast(city);
        fetchedCities.add(model);
      }
      allCities = fetchedCities;
      filteredCities = List.from(allCities);
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Filtra a lista de cidades com base na consulta do usuário.
  void filterCities(String query) {
    if (query.isEmpty) {
      filteredCities = List.from(allCities);
    } else {
      filteredCities = allCities
          .where(
            (city) => city.cityName.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    // Importante: remover listeners se necessário, mas o NetworkService é Singleton
    super.dispose();
  }
}
