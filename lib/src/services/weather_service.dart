import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/weather_forecast_model.dart';
import '../enums/enviroments_enum.dart';

/// WeatherService responsável pelo consumo da API de clima.
/// Implementa resiliência com timeout e tratamento de exceções de rede.
class WeatherService {
  final http.Client client;

  WeatherService({http.Client? client}) : client = client ?? http.Client();

  /// Busca a previsão do tempo para uma cidade específica.
  /// Lança exceções personalizadas para falhas de rede ou timeout.
  Future<WeatherForecastModel> fetchForecast(String cityName) async {
    final enumEnv = EnviromentEnum.constants;
    final url = Uri.parse(
      '${enumEnv.API_BASE_URL}?key=${enumEnv.API_KEY}&city_name=$cityName',
    );

    try {
      final response = await client.get(url).timeout(
            const Duration(seconds: 5),
          );

      if (response.statusCode == 200) {
        final jsonDecoded = jsonDecode(response.body)['results'];
        return WeatherForecastModel.fromJson(jsonDecoded);
      } else {
        throw Exception('Erro ao carregar dados: Status ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Sem ligação à internet. Verifique a sua conexão.');
    } on TimeoutException {
      throw Exception('Tempo limite de ligação excedido. Tente novamente.');
    } catch (e) {
      throw Exception('Ocorreu um erro inesperado: $e');
    }
  }
}
