import 'package:fe_lab_clinicas_core/fe_lab_clinicas_core.dart';
import 'package:fe_lab_clinicas_self_service/src/modules/auth/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with MessageViewMixin {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final controller = Injector.get<LoginController>();

  @override
  void initState() {
    messageListener(controller);
    effect(() {
      if (controller.isLogged) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(minHeight: size.height),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background_login.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(40),
              constraints: BoxConstraints(maxWidth: size.width * 0.8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const Text(
                      'Login',
                      style: LabClinicasTheme.titleStyle,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      decoration: const InputDecoration(label: Text('Email')),
                      controller: emailController,
                      validator: Validatorless.multiple([
                        Validatorless.required('Email obrigatório'),
                        Validatorless.email('Email inválido'),
                      ]),
                    ),
                    const SizedBox(height: 24),
                    Watch(
                      (_) {
                        return TextFormField(
                          obscureText: controller.obscurePassword,
                          controller: passwordController,
                          validator: Validatorless.required('Senha obrigatória'),
                          decoration: InputDecoration(
                            label: const Text('Password'),
                            suffixIcon: IconButton(
                              onPressed: () {
                                controller.passwordToggle();
                              },
                              icon: controller.obscurePassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: size.width * 0.8,
                      child: ElevatedButton(
                          onPressed: () {
                            final isValid = formKey.currentState?.validate() ?? false;
                            if (isValid) {
                              controller.login(emailController.text, passwordController.text);
                            }
                          },
                          child: const Text('ENTRAR')),
                    )
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
