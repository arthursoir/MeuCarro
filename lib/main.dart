import 'screens/cadastro_screen.dart';
import 'package:flutter/material.dart';

// FUNÇÃO PRINCIPAL
// A execução do aplicativo começa por aqui.
void main() {
  // runApp inicia o Flutter e exibe nosso aplicativo.
  runApp(const MeuCarroApp());
}

// CLASSE PRINCIPAL DO APLICATIVO
// StatelessWidget representa um widget que não gerencia
// um estado interno que muda ao longo do tempo.
class MeuCarroApp extends StatelessWidget {
  const MeuCarroApp({super.key});

  // build descreve o que o Flutter deve mostrar.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyCar',

      // Remove a faixa DEBUG da tela.
      debugShowCheckedModeBanner: false,

      // Define as configurações visuais do aplicativo.
      theme: ThemeData(
        useMaterial3: true,

        // Verde principal da identidade do MeuCarro.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1DB954),
        ),
      ),

      // Define qual será a primeira tela.
      home: const CadastroScreen(),
    );
  }
}

// PRIMEIRA TELA: MINHA GARAGEM
class GaragemScreen extends StatelessWidget {
  const GaragemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior da tela.
      appBar: AppBar(
        title: const Text('MeuCarro'),
        centerTitle: true,
      ),

      // Conteúdo principal.
      body: Center(
        child: Padding(
          // Espaçamento interno de 24 pixels lógicos.
          padding: const EdgeInsets.all(24),

          // Column organiza os elementos verticalmente.
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícone do carro.
              const Icon(
                Icons.directions_car,
                size: 80,
                color: Color(0xFF1DB954),
              ),

              // Espaço entre o ícone e o título.
              const SizedBox(height: 24),

              // Título da tela.
              const Text(
                'Minha garagem',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Espaço entre os textos.
              const SizedBox(height: 12),

              // Mensagem exibida quando não há veículos.
              const Text(
                'Você ainda não cadastrou nenhum veículo.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
