import 'package:flutter/material.dart';
import '../services/device_info_service.dart';

/// RegionController gerencia o estado da região para a View.
/// Segue o padrão MVC e utiliza ChangeNotifier para reatividade.
class RegionController extends ChangeNotifier {
  final DeviceInfoService _deviceInfoService = DeviceInfoService();
  
  String _countryEmoji = '🌐';
  String get countryEmoji => _countryEmoji;

  /// Inicializa a captura da região e atualiza o emoji
  void updateRegion() {
    _countryEmoji = _deviceInfoService.getCountryEmoji();
    notifyListeners();
  }
}
