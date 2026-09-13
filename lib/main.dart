import 'package:climapp_cc20262/src/screens/welcome_screen.dart';
import 'package:climapp_cc20262/src/screens/list_city_screen.dart';
import 'package:climapp_cc20262/src/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';

/// Handler para mensagens em Background/Terminated.
/// Deve ser global e anotado com @pragma('vm:entry-point').
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("Background Message ID: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Inicializa o Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // 2. Configura o handler de background antes de qualquer outra coisa do FCM
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  // 3. Inicializa o serviço de notificações (solicita permissões e obtém token)
  final notificationService = NotificationService();
  await notificationService.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Climapp',
      // Define a navigatorKey global do NotificationService para permitir navegação via Push
      navigatorKey: NotificationService().navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
      ),
      // Mapeamento de rotas para o Deep Linking funcionar corretamente
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/list': (context) => const ListCityScreen(),
        // A rota /weather pode ser tratada via onGenerateRoute se precisar de argumentos complexos
        // ou simplificada no NotificationService para ir para a lista ou detalhe.
      },
      initialRoute: '/',
    );
  }
}
