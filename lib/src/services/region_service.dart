import 'dart:ui';
import 'package:flutter/foundation.dart';

/// RegionService isola a lógica de captura da localidade do sistema.
class RegionService {
  // Singleton
  RegionService._internal();
  static final RegionService instance = RegionService._internal();

  /// Fallback padrão caso a detecção falhe
  static const String _defaultEmoji = '🌍'; // Globo terrestre ou '🇧🇷'
  static const String _defaultCountryCode = 'BR';

  /// Obtém o código do país do dispositivo (ex: 'BR', 'US')
  String getDeviceCountryCode() {
    try {
      // PlatformDispatcher acessa o locale do sistema de forma eficiente
      final Locale locale = PlatformDispatcher.instance.locale;
      final String? code = locale.countryCode;

      if (code == null || code.isEmpty || code.length != 2) {
        debugPrint('RegionService: Código de país inválido ou nulo: $code');
        return _defaultCountryCode;
      }

      return code.toUpperCase();
    } catch (e) {
      debugPrint('RegionService: Erro ao obter locale: $e');
      return _defaultCountryCode;
    }
  }

  /// Converte o código ISO do país (BR, US) para um Emoji de Bandeira
  /// Utiliza a lógica de Unicode Regional Indicator Symbols com tratamento de erro
  String countryCodeToEmoji(String? countryCode) {
    try {
      if (countryCode == null || countryCode.length != 2) {
        return _defaultEmoji;
      }

      final String cleanCode = countryCode.toUpperCase();
      
      // Verifica se são caracteres alfabéticos válidos (A-Z)
      final int firstChar = cleanCode.codeUnitAt(0);
      final int secondChar = cleanCode.codeUnitAt(1);

      if (firstChar < 65 || firstChar > 90 || secondChar < 65 || secondChar > 90) {
        return _defaultEmoji;
      }

      final int firstLetter = firstChar - 0x41 + 0x1F1E6;
      final int secondLetter = secondChar - 0x41 + 0x1F1E6;
      
      return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
    } catch (e) {
      debugPrint('RegionService: Erro na conversão para Emoji: $e');
      return _defaultEmoji;
    }
  }
}
