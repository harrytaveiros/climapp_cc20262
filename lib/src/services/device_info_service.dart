import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

/// DeviceInfoService centraliza a coleta de dados do hardware e sistema operacional.
/// Útil para telemetria, logs de erro e segmentação de Push Notifications.
class DeviceInfoService {
  // Singleton
  DeviceInfoService._internal();
  static final DeviceInfoService instance = DeviceInfoService._internal();

  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  /// Retorna um mapa com informações básicas do dispositivo
  Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      if (kIsWeb) {
        final webInfo = await _deviceInfoPlugin.webBrowserInfo;
        return {
          'platform': 'web',
          'browser': webInfo.browserName.name,
          'userAgent': webInfo.userAgent,
        };
      } else if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        return {
          'platform': 'android',
          'model': androidInfo.model,
          'version': androidInfo.version.release,
          'sdk': androidInfo.version.sdkInt,
          'manufacturer': androidInfo.manufacturer,
        };
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        return {
          'platform': 'ios',
          'model': iosInfo.model,
          'version': iosInfo.systemVersion,
          'name': iosInfo.name,
          'machine': iosInfo.utsname.machine,
        };
      }
    } catch (e) {
      debugPrint('Erro ao obter informações do dispositivo: $e');
    }
    return {'platform': 'unknown'};
  }

  /// Retorna o nome amigável do modelo do dispositivo
  Future<String> getDeviceModel() async {
    final info = await getDeviceInfo();
    return info['model'] ?? 'Unknown Device';
  }
}
