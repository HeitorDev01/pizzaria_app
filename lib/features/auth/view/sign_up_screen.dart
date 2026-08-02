import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizzaria_app/core/validators/validators.dart';
import 'package:pizzaria_app/core/widgets/app_text_field.dart';
import 'package:pizzaria_app/features/auth/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:pizzaria_app/features/auth/widgets/auth_submit_button.dart';
import 'package:pizzaria_app/features/auth/widgets/password_checklist.dart';
import 'package:user_repository/user_repository.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _obscurePassword = true;
  PasswordRequirements _requirements = PasswordRequirements.empty;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final user = MyUser.empty.copyWith(
      email: _emailController.text.trim(),
      name: _nameController.text.trim(),
    );

    context
        .read<SignUpBloc>()
        .add(SignUpRequired(user, _passwordController.text));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  width: size.width * 0.9,
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
                  width: size.width * 0.9,
                  child: AppTextField(
                    controller: _passwordController,
                    hintText: 'Senha',
                    obscureText: _obscurePassword,
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: const Icon(CupertinoIcons.lock_fill),
                    validator: Validators.password,
                    onChanged: (value) => setState(
                      () => _requirements = PasswordRequirements.of(value),
                    ),
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
                const SizedBox(height: 10),
                PasswordChecklist(requirements: _requirements),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width * 0.9,
                  child: AppTextField(
                    controller: _nameController,
                    hintText: 'Nome',
                    keyboardType: TextInputType.name,
                    prefixIcon: const Icon(CupertinoIcons.person_fill),
                    validator: Validators.name,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                AuthSubmitButton(
                  label: 'Cadastrar',
                  isLoading: state is SignUpInProgress,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
