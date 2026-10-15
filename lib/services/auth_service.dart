
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

// SERVIÇO DE AUTENTICAÇÃO DO MEUCARRO
//
// Esta classe será responsável pela comunicação
// entre o aplicativo Flutter e a API Flask.
//
// Por enquanto, implementaremos apenas o cadastro.
class AuthService {

  // Endereço do servidor Flask no computador.
  //
  // 10.0.2.2 é o endereço especial utilizado
  // pelo emulador Android para acessar o computador.
  static const String _urlBase = 'http://10.0.2.2:5000';

  // Função responsável por cadastrar um usuário.
  //
  // Future<String> significa que ela devolverá
  // uma mensagem de texto quando terminar.
  //
  // async permite aguardar operações de rede.
  static Future<String> cadastrarUsuario({
    required String nome,
    required String email,
    required String senha,
  }) async {

    try {
      // Monta o endereço da rota de cadastro.
      final url = Uri.parse('$_urlBase/api/usuarios');

      // Envia uma requisição HTTP do tipo POST.
      //
      // jsonEncode transforma os dados Dart em JSON,
      // formato que nosso Flask consegue interpretar.
      final resposta = await http.post(
        url,

        headers: {
          'Content-Type': 'application/json; charset=utf-8',
        },

        body: jsonEncode({
          'nome': nome,
          'email': email,
          'senha': senha,
        }),
      ).timeout(const Duration(seconds: 10));

      // Converte a resposta JSON em dados do Dart.
      // utf8.decode preserva caracteres acentuados.
      final dados = jsonDecode(
        utf8.decode(resposta.bodyBytes),
      );

      // Confere se recebemos um objeto JSON.
      if (dados is! Map<String, dynamic>) {
        throw Exception('Resposta inesperada do servidor.');
      }

      // Código HTTP 201 significa que o cadastro
      // foi criado com sucesso.
      if (resposta.statusCode == 201) {
        return dados['mensagem']?.toString()
            ?? 'Usuário cadastrado com sucesso!';
      }

      // Caso o servidor retorne um erro, como
      // e-mail duplicado, exibiremos a mensagem.
      throw Exception(
        dados['erro']?.toString()
            ?? 'Não foi possível cadastrar o usuário.',
      );

    } on TimeoutException {
      // O servidor demorou mais de 10 segundos.
      throw Exception(
        'Tempo esgotado. Verifique o servidor Flask.',
      );

    } on http.ClientException {
      // Não foi possível estabelecer a comunicação.
      throw Exception(
        'Falha de conexão. Verifique a API Flask.',
      );
    }
  }
}
