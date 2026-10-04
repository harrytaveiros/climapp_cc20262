import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

/// NetworkService gerencia o estado da conectividade em tempo real.
/// Segue o padrão Singleton para ser acessível globalmente.
class NetworkService {
  NetworkService._internal();
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;

  final Connectivity _connectivity = Connectivity();
  
  /// ValueNotifier que transmite o estado da conexão (true = online, false = offline)
  final ValueNotifier<bool> isOnline = ValueNotifier<bool>(true);

  /// Inicializa o listener de conectividade.
  void initialize() {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      // Verifica se há alguma conexão ativa (Wifi, Mobile, etc.)
      final bool hasConnection = results.any((result) => result != ConnectivityResult.none);
      isOnline.value = hasConnection;
      debugPrint('NetworkService: Conexão alterada. Online: $hasConnection');
    });
  }

  /// Realiza uma verificação pontual da conexão.
  Future<bool> checkConnection() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }
}
