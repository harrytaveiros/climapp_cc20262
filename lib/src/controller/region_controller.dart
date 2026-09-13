import 'package:flutter/material.dart';
import '../services/region_service.dart';

/// RegionController gerencia o estado da região para a View.
/// Segue o padrão MVC e utiliza ChangeNotifier para reatividade.
class RegionController extends ChangeNotifier {
  final RegionService _service = RegionService.instance;
  
  String _countryEmoji = '🌐';
  String get countryEmoji => _countryEmoji;

  /// Inicializa a captura da região e atualiza o emoji
  void updateRegion() {
    final code = _service.getDeviceCountryCode();
    _countryEmoji = _service.countryCodeToEmoji(code);
    notifyListeners();
  }
}
