import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_challenge/core/routes/routes.dart';
import 'package:tmdb_challenge/login/presentation/widgets/alert_dialog.dart';

const _loginEmail = 'user@user.com';
const _loginPassWord = '123456';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailCtrlr;
  late TextEditingController passwordCtrlr;
  late GlobalKey<FormState> formStateKey;

  @override
  void initState() {
    super.initState();
    emailCtrlr = TextEditingController();
    passwordCtrlr = TextEditingController();
    formStateKey = GlobalKey<FormState>();
  }

  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Form(
          key: formStateKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // logo
              SvgPicture.asset(
                'assets/tmdb_logo.svg',
                height: 25,
              ),
              const SizedBox(height: 10),

              Text(
                'Verifarma  challenge',
                style: textStyle.bodyMedium!.copyWith(
                  color: Colors.grey.shade700,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 50),

              // email
              TextFormField(
                controller: emailCtrlr,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration(
                  labelText: 'Email',
                  hintText: 'email@email.com',
                  sufixIcon: Icons.clear_rounded,
                  onTap: () => emailCtrlr.clear(),
                ),
                validator: (value) {
                  if (value != null && !_validateEmail(value)) {
                    return 'Ingrese un email válido';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 10),

              // password
              TextFormField(
                obscureText: showPassword,
                controller: passwordCtrlr,
                keyboardType: TextInputType.visiblePassword,
                decoration: _inputDecoration(
                  labelText: 'Password',
                  hintText: 'Ingrese su password',
                  sufixIcon: showPassword == true ? Icons.visibility_rounded : Icons.visibility_off_outlined,
                  onTap: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                ),
                validator: (value) {
                  if (value != null && value.length < 3) {
                    return 'Ingrese un valor';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 10),

              // login button
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _tryLogin(),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: textStyle.titleLarge,
                  ),
                ),
              ),
              // ayuda
              const SizedBox(height: 20),

              Text(
                '[  user: $_loginEmail / pass: $_loginPassWord  ]',
                style: textStyle.bodyMedium!.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 40),

              // options buttons
              TextButton(
                onPressed: () {},
                child: const Text('Recuperar contraseña.'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Crear cuenta.'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String labelText,
    required String hintText,
    required VoidCallback onTap,
    required IconData sufixIcon,
  }) {
    return InputDecoration(
      // regular borders
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.cyan, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.cyan, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      // error borders
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red.shade800, width: 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(100)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red.shade800, width: 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(100)),
      ),
      // other properties
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      labelText: labelText,
      hintText: hintText,
      suffixIcon: IconButton(
        onPressed: () => onTap(),
        icon: Icon(sufixIcon),
      ),
    );
  }

  void _tryLogin() {
    if (formStateKey.currentState!.validate()) {
      if (emailCtrlr.text == _loginEmail && passwordCtrlr.text == _loginPassWord) {
        context.goNamed(AppRoutes.homePage);
      } else {
        loginErrorDialog(context);
      }
    }
  }

  bool _validateEmail(String value) {
    RegExp regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return (!regex.hasMatch(value)) ? false : true;
  }
}
