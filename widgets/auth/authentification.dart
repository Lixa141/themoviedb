import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/Theme/styles.dart';
import 'package:flutter_themoviedb/widgets/auth/authentification_model.dart';
import 'package:provider/provider.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: const Text('Login to your account'),
        ),
      ),
      body: ListView(
        children: const [
          _HeaderWidget(),
        ],
      ),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({Key? key}) : super(key: key);

  void _register() {
    // print('Tap Here onTap');
  }

  void _verifyViaEmail() {
    // print('Tap Here22222 onTap');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Войти в свою учётную запись',
            style: Styles.h1,
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(style: Styles.p16, children: [
              const TextSpan(
                text:
                    'Чтобы пользоваться правкой и возможностями рейтинга TMDB, а также получить персональные рекомендации, необходимо войти в свою учётную запись. Если у вас нет учётной записи, её регистрация является бесплатной и простой. ',
              ),
              TextSpan(
                text: 'Нажмите здесь',
                style: TextStyle(
                  fontSize: Styles.p16.fontSize,
                  color: const Color(0xFF01b4e4),
                ),
                recognizer: TapGestureRecognizer()..onTap = () => _register(),
              ),
              const TextSpan(style: Styles.p16, text: ', чтобы начать.'),
            ]),
          ),
          const SizedBox(height: 20),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  style: Styles.p16,
                  text:
                      'Если Вы зарегистрировались, но не получили письмо для подтверждения, ',
                ),
                TextSpan(
                  style: TextStyle(
                    fontSize: Styles.p16.fontSize,
                    color: const Color(0xFF01b4e4),
                  ),
                  text: 'нажмите здесь',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _verifyViaEmail(),
                ),
                const TextSpan(
                    style: Styles.p16,
                    text: ', чтобы отправить письмо повторно.'),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const _FormWidget(),
        ],
      ),
    );
  }
}

class _FormWidget extends StatelessWidget {
  const _FormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AuthViewModel>();
    const basicDecoration = InputDecoration(
      border: OutlineInputBorder(
          borderSide: BorderSide(width: 20, color: Colors.red)),
      contentPadding: EdgeInsets.all(10),
      isCollapsed: true,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF01b4e4), width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFced4da), width: 2.0),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ErrorMessageWidget(),
        Text(
          'Username',
          style: TextStyle(
            fontSize: Styles.p16.fontSize,
            color: const Color(0xFF212529),
          ),
        ),
        TextField(
          controller: model.loginTextController,
          decoration: basicDecoration,
        ),
        const SizedBox(height: 22),
        Text(
          'Password',
          style: TextStyle(
            fontSize: Styles.p16.fontSize,
            color: const Color(0xFF212529),
          ),
        ),
        TextField(
          controller: model.passwordTextController,
          decoration: basicDecoration,
          obscureText: true,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const _AuthButtonWidget(),
            const SizedBox(
              width: 30,
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.all(const Color(0xFF01b4e4)),
              ),
              onPressed: () {},
              child: const Text(
                'Reset password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AuthViewModel>();
    final onPressed = model.canStartAuth ? () => model.auth(context) : null;
    final child = model.isAuthProgress
        ? const SizedBox(
            width: 15,
            height: 15,
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          )
        : const Text('Login');

    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xFF01b4e4)),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorMessage =
        context.select((AuthViewModel value) => value.errorMessage);
    if (errorMessage == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        errorMessage,
        style: const TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }
}
