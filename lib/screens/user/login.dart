import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:sqlsqlsql/screens/user/userform.dart";
import "package:sqlsqlsql/widgets/drawer/drawer.dart";

import "../../dbhelper.dart";
import "../../home.dart";
import "../../provider/userformprovider.dart";
import "../../utils/validation.dart";
import "../../widgets/form/formtop.dart";
import "../../widgets/inputwidget.dart";
import "../../widgets/primarybutton.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    final heightContext = MediaQuery.of(context).size.height;
    final userFormProvider =
        Provider.of<UserFormProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      drawer: const AppDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: heightContext < 830 ? 0 : heightContext / 20,
            ),
          ),
          const FormTop(
            topText: 'Login Into Your Account',
            topImagePath: 'assets/users.png',
            bottomText: 'Fill Below Fields to Login',
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).brightness == Brightness.light
                      ? const Color.fromARGB(255, 244, 244, 244)
                      : const Color.fromARGB(255, 49, 47, 47),
                ),
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: heightContext < 830 ? 35 : 20,
                  ),
                  children: <Widget>[
                    Form(
                      key: _key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InputWidget(
                            controller: emailController,
                            hint: "Email",
                            label: "Enter Your Email",
                            preicon: Icons.mail,
                            iconsize: 25.0,
                            validation: validateEmail,
                            action: TextInputAction.next,
                          ),
                          SizedBox(
                            height: heightContext / 40,
                          ),
                          InputWidget(
                            controller: passwordController,
                            hint: "Password",
                            label: "Choose Password",
                            preicon: Icons.password,
                            iconsize: 25.0,
                            validation: validatePassword,
                            action: TextInputAction.done,
                            obscureText: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserFormScreen()));
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: Text(
                    "Need to Make An Account?",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: heightContext < 830 ? 220 : 200,
          ),
          Column(
            children: [
              PrimaryButton(
                text: "Login",
                onPressed: () async {
                  if (_key.currentState!.validate()) {
                    final logedInUser = await userFormProvider.userLogin(
                      email: emailController.text,
                      password: passwordController.text,
                      databaseHelper: _databaseHelper,
                      context: context,
                    );
                    if (logedInUser) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (route) => false,
                      );
                    } else {
                      print("Check Input");
                    }
                  } else {
                    print("Cant Login");
                  }
                },
                borderRadius: BorderRadius.circular(5),
                textsize: 20,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: heightContext < 830 ? 10 : 30,
            ),
          ),
        ],
      ),
    );
  }
}
