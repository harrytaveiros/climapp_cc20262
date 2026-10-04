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

  /// Inicializa o listener de conectividade com uma verificação inicial.
  Future<void> initialize() async {
    // 1. Verificação inicial imediata do estado da rede para evitar atrasos no build inicial
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);

    // 2. Escuta mudanças subsequentes em tempo real
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateStatus(results);
    });
  }

  /// Lógica centralizada para atualizar o ValueNotifier apenas quando o estado mudar.
  void _updateStatus(List<ConnectivityResult> results) {
    final bool hasConnection = results.any((result) => result != ConnectivityResult.none);
    
    if (isOnline.value != hasConnection) {
      isOnline.value = hasConnection;
      debugPrint('NetworkService: Status de rede alterado. Conectado: $hasConnection');
    }
  }

  /// Realiza uma verificação pontual da conexão.
  Future<bool> checkConnection() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }
}
