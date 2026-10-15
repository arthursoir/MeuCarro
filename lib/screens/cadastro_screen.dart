
import 'package:flutter/material.dart';

// Importa o serviço que criamos no passo anterior.
import '../services/auth_service.dart';

// TELA DE CADASTRO DO MEUCARRO
//
// StatefulWidget é usado porque a tela terá estados
// que mudam, como o carregamento durante o cadastro.
class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {

  // Controla a validação dos campos do formulário.
  final _formKey = GlobalKey<FormState>();

  // Controllers permitem acessar o texto digitado.
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  // Indica se uma requisição está em andamento.
  bool _salvando = false;

  // Libera os recursos quando a tela é destruída.
  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  // FUNÇÃO EXECUTADA AO TOCAR EM "CRIAR CONTA"
  Future<void> _cadastrar() async {

    // Verifica se todos os campos são válidos.
    final valido = _formKey.currentState?.validate() ?? false;

    if (!valido) {
      return;
    }

    // Fecha o teclado antes de enviar os dados.
    FocusScope.of(context).unfocus();

    // Atualiza a interface para mostrar o carregamento.
    setState(() {
      _salvando = true;
    });

    try {
      // Chama o serviço que se comunica com o Flask.
      final mensagem = await AuthService.cadastrarUsuario(
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        senha: _senhaController.text,
      );

      // Verifica se a tela ainda está aberta.
      if (!mounted) return;

      // Exibe uma mensagem de sucesso.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagem),
          backgroundColor: Colors.green.shade700,
        ),
      );

      // Limpa os campos após um cadastro bem-sucedido.
      _nomeController.clear();
      _emailController.clear();
      _senhaController.clear();
      _confirmarSenhaController.clear();

    } catch (erro) {
      // Trata erros vindos da API ou da conexão.
      if (!mounted) return;

      final mensagem = erro.toString().replaceFirst(
        'Exception: ',
        '',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagem),
          backgroundColor: Colors.red.shade700,
        ),
      );

    } finally {
      // Encerra o carregamento após sucesso ou erro.
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }

  // CONSTRUÇÃO DA INTERFACE
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('MeuCarro'),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),

              child: Form(
                key: _formKey,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    // ÍCONE PRINCIPAL
                    const Icon(
                      Icons.directions_car,
                      size: 65,
                      color: Color(0xFF1DB954),
                    ),

                    const SizedBox(height: 16),

                    // TÍTULO
                    const Text(
                      'Criar minha conta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Cadastre-se para gerenciar seus veículos.',
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),

                    // CAMPO NOME
                    TextFormField(
                      controller: _nomeController,
                      textCapitalization: TextCapitalization.words,

                      decoration: const InputDecoration(
                        labelText: 'Nome completo',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),

                      validator: (valor) {
                        if (valor == null ||
                            valor.trim().length < 2) {
                          return 'Informe seu nome.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // CAMPO E-MAIL
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,

                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),

                      validator: (valor) {
                        final email = valor?.trim() ?? '';

                        if (email.isEmpty ||
                            !email.contains('@') ||
                            !email.contains('.')) {
                          return 'Informe um e-mail válido.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // CAMPO SENHA
                    TextFormField(
                      controller: _senhaController,

                      // Oculta os caracteres da senha.
                      obscureText: true,

                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                      ),

                      validator: (valor) {
                        if (valor == null || valor.length < 8) {
                          return 'Use pelo menos 8 caracteres.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // CAMPO CONFIRMAR SENHA
                    TextFormField(
                      controller: _confirmarSenhaController,
                      obscureText: true,

                      decoration: const InputDecoration(
                        labelText: 'Confirmar senha',
                        prefixIcon: Icon(Icons.lock_reset),
                        border: OutlineInputBorder(),
                      ),

                      validator: (valor) {
                        if (valor != _senhaController.text) {
                          return 'As senhas não coincidem.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // BOTÃO DE CADASTRO
                    SizedBox(
                      height: 50,

                      child: FilledButton(
                        // Impede dois cadastros simultâneos.
                        onPressed: _salvando ? null : _cadastrar,

                        // Exibe progresso ou texto do botão.
                        child: _salvando
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Criar conta'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
