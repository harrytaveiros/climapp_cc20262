import 'dart:ui';
import 'package:flutter/material.dart';

/// RegionBadgeWidget exibe o emoji da bandeira com um efeito de Glassmorphism.
/// Possui tratamento de erro interno para garantir a estabilidade da UI.
class RegionBadgeWidget extends StatelessWidget {
  final String emoji;

  const RegionBadgeWidget({super.key, required this.emoji});

  @override
  Widget build(BuildContext context) {
    // Fallback de segurança: se o emoji for inválido/vazio, mostra o globo
    final String displayEmoji = emoji.isEmpty ? '🌍' : emoji;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Text(
            displayEmoji,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
