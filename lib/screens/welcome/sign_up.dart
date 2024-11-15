import 'package:flutter/material.dart';
import 'package:flutter_application/widgets/shared/password_input.dart';
import 'package:flutter_application/widgets/shared/styled_button.dart';
import 'package:flutter_application/widgets/shared/styled_form_field.dart';
import 'package:flutter_application/widgets/shared/styled_text.dart';
import 'package:flutter_application/services/auth_service.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorFeedback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sing up text
            const Center(
                child:
                    StyledBodyText("Zajerestruj się aby utworzyć nowe konto")),
            const SizedBox(height: 16.0),

            // email address
            StyledFormField(
                textEditingController: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Proszę podaj swój Email";
                  }
                  return null;
                },
                label: const Text("Adres e-mail"),
                icon: Icons.person),
            const SizedBox(height: 16.0),

            // password
            PasswordInput(
                textEditingController: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Proszę podaj swoje Hasło";
                  }
                  if (value.length < 8) {
                    return "Hasło musi mieć przynajmniej 8 znaków!";
                  }
                  return null;
                },
                label: const Text("Hasło"),
                icon: Icons.lock),
            const SizedBox(height: 16.0),

            // error feedback
            if (_errorFeedback != null)
              Center(
                  child: Text(_errorFeedback!,
                      style: const TextStyle(color: Colors.red))),

            // sumbit button
            FractionallySizedBox(
              widthFactor: 0.5,
              child: StyledButton(
                onPressed: () async {
                  setState(() {
                    _errorFeedback = null;
                  });

                  // Daje ! na końcu bo wiem że formKey nie będzie posiadać wartowści null
                  if (_formKey.currentState!.validate()) {
                    // trim żeby pozbyć się pustej przestrzeni
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();

                    final user = await AuthService.signUp(email, password);

                    // error feedback
                    if (user == null) {
                      setState(() {
                        _errorFeedback = "Proszę podać inny Email!";
                      });
                    }
                  }
                },
                child: const StyledButtonText("Zajerestruj się"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
