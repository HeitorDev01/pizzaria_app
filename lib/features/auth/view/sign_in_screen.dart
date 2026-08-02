import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizzaria_app/core/validators/validators.dart';
import 'package:pizzaria_app/core/widgets/app_text_field.dart';
import 'package:pizzaria_app/features/auth/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:pizzaria_app/features/auth/widgets/auth_submit_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  String? _errorMsg;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _errorMsg = null);
    context.read<SignInBloc>().add(
          SignInRequired(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocConsumer<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInFailure) {
          setState(() => _errorMsg = state.message);
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: width * 0.9,
                child: AppTextField(
                  controller: _emailController,
                  hintText: 'E-mail',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(CupertinoIcons.mail_solid),
                  validator: Validators.email,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: width * 0.9,
                child: AppTextField(
                  controller: _passwordController,
                  hintText: 'Senha',
                  obscureText: _obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: const Icon(CupertinoIcons.lock_fill),
                  errorMsg: _errorMsg,
                  validator: Validators.password,
                  suffixIcon: IconButton(
                    onPressed: () => setState(
                      () => _obscurePassword = !_obscurePassword,
                    ),
                    icon: Icon(
                      _obscurePassword
                          ? CupertinoIcons.eye_fill
                          : CupertinoIcons.eye_slash_fill,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AuthSubmitButton(
                label: 'Entrar',
                isLoading: state is SignInInProgress,
                onPressed: _submit,
              ),
            ],
          ),
        );
      },
    );
  }
}
