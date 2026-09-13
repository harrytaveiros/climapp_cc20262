import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

/// PushNotificationService isola a lógica do Firebase Cloud Messaging (FCM).
/// Segue o padrão Singleton e o princípio da Responsabilidade Única (SOLID).
class NotificationService {
  // Instância singleton para acesso global
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // Chave global para permitir navegação sem BuildContext
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Inicializa as configurações de notificação e solicita permissões
  Future<void> initialize() async {
    // 1. Solicitar permissões (Obrigatório para iOS e Android 13+)
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('Permissão concedida pelo usuário.');

      // 2. Obter o FCM Token (Útil para enviar para o backend)
      String? token = await _fcm.getToken();
      debugPrint('====================================');
      debugPrint('FCM TOKEN: $token');
      debugPrint('====================================');

      // Escuta caso o token seja renovado pelo Firebase
      _fcm.onTokenRefresh.listen((newToken) {
        debugPrint('FCM Token atualizado: $newToken');
      });

      // 3. Configurar os listeners de eventos (Foreground, Background, Terminated)
      _setupMessageHandlers();
    } else {
      debugPrint('Permissão negada ou não configurada.');
    }
  }

  /// Configura o tratamento de mensagens em diferentes estados do ciclo de vida
  void _setupMessageHandlers() {
    // FOREGROUND: App aberto e visível
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Mensagem recebida em Foreground: ${message.notification?.title}');
      _showInAppNotification(message);
    });

    // BACKGROUND: App minimizado (clique na notificação)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Toque na notificação (Background): ${message.data}');
      _handleDeepLink(message);
    });

    // TERMINATED: App fechado (aberto via clique na notificação)
    _fcm.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('App inicializado via notificação: ${message.data}');
        _handleDeepLink(message);
      }
    });
  }

  /// Exibe um feedback visual quando o app está em primeiro plano
  void _showInAppNotification(RemoteMessage message) {
    final notification = message.notification;
    final context = navigatorKey.currentContext;

    if (notification != null && context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification.title ?? 'Nova Notificação', 
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(notification.body ?? ''),
            ],
          ),
          backgroundColor: Colors.deepPurple,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Ver',
            textColor: Colors.white,
            onPressed: () => _handleDeepLink(message),
          ),
        ),
      );
    }
  }

  /// Lógica de roteamento baseada nos dados (Payload) da notificação
  void _handleDeepLink(RemoteMessage message) {
    // Exemplo: { "route": "/weather", "city": "São Paulo" }
    final route = message.data['route'];
    final city = message.data['city'];

    if (route != null) {
      navigatorKey.currentState?.pushNamed(route, arguments: city);
    } else if (city != null) {
      // Fallback caso apenas a cidade seja enviada
      navigatorKey.currentState?.pushNamed('/weather', arguments: city);
    }
  }
}
