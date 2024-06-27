import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('O aplikacji'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              'Opis Aplikacji',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            AutoSizeText(
              'Quality Control Mobile jest aplikacją przeznaczoną do zarządzania kontrolą jakości '
              'w ramach dostaw komponentów. Umożliwia ona monitorowanie i zarządzanie dostawami, '
              'komponentami oraz ich statusami w czasie rzeczywistym.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            AutoSizeText(
              'Funkcjonalności:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            AutoSizeText(
              '• Dodawanie nowych dostaw i komponentów\n'
              '• Śledzenie statusu komponentów\n'
              '• Zarządzanie klientami i typami komponentów\n'
              '• Automatyczne zmiany statusów dostaw oraz komponentów w opraciu o statusy podkomponentów',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            AutoSizeText(
              'Autor:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            AutoSizeText(
              'Rafał Krawczyk\n'
              'Numer indexu: 13950',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
