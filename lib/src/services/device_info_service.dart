import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

/// DeviceInfoService centraliza a coleta de dados do hardware e sistema operacional.
/// Útil para telemetria, logs de erro e segmentação de Push Notifications.
class DeviceInfoService {
  // Singleton
  DeviceInfoService._internal();
  static final DeviceInfoService _instance = DeviceInfoService._internal();
  factory DeviceInfoService() => _instance;

  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  
  // Cache para evitar chamadas repetitivas ao hardware
  Map<String, dynamic>? _cachedInfo;

  /// Retorna um mapa com informações básicas do dispositivo
  Future<Map<String, dynamic>> getDeviceInfo() async {
    if (_cachedInfo != null) return _cachedInfo!;

    try {
      if (kIsWeb) {
        final webInfo = await _deviceInfoPlugin.webBrowserInfo;
        _cachedInfo = {
          'platform': 'web',
          'browser': webInfo.browserName.name,
          'userAgent': webInfo.userAgent,
        };
      } else if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        _cachedInfo = {
          'platform': 'android',
          'deviceId': androidInfo.id,
          'model': androidInfo.model,
          'version': androidInfo.version.release,
          'sdk': androidInfo.version.sdkInt,
          'manufacturer': androidInfo.manufacturer,
          'isPhysicalDevice': androidInfo.isPhysicalDevice,
        };
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        _cachedInfo = {
          'platform': 'ios',
          'deviceId': iosInfo.identifierForVendor,
          'model': iosInfo.model,
          'version': iosInfo.systemVersion,
          'name': iosInfo.name,
          'machine': iosInfo.utsname.machine,
          'isPhysicalDevice': iosInfo.isPhysicalDevice,
        };
      }
    } catch (e) {
      debugPrint('Erro ao obter informações do dispositivo: $e');
      _cachedInfo = {'platform': 'unknown'};
    }
    return _cachedInfo!;
  }

  /// Retorna o nome amigável do modelo do dispositivo
  Future<String> getDeviceModel() async {
    final info = await getDeviceInfo();
    return info['model'] ?? 'Unknown Device';
  }

  // --- Lógica de Região Integrada ---

  /// Obtém o código do país configurado no sistema (ex: 'BR')
  String getCountryCode() {
    return PlatformDispatcher.instance.locale.countryCode ?? 'BR';
  }

  /// Converte o código do país para Emoji de Bandeira com Fallback seguro
  String getCountryEmoji() {
    try {
      final String code = getCountryCode().toUpperCase();
      if (code.length != 2) return '🌍';
      
      final int firstLetter = code.codeUnitAt(0) - 0x41 + 0x1F1E6;
      final int secondLetter = code.codeUnitAt(1) - 0x41 + 0x1F1E6;
      
      return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
    } catch (e) {
      return '🌍';
    }
  }
}
