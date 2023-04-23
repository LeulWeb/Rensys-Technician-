import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:technician_rensys/constatnts/colors.dart';
import 'package:technician_rensys/responsive/mobile_layout.dart';

import 'package:technician_rensys/services/graphql_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../responsive/responsive_layout.dart';
import '../widgets/text_app.dart';
import 'home_screen.dart';

//Working with shared preference

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static const loginRoute = "/login";

  String phoneNumber = '';
  String password = '';
  final _graphql_service = GraphQLService();
  final FocusNode _passwordFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  QueryResult? result;
  String errorMessage = "";
  //Check if the user is new to the app
  bool? isLoggedIn = false;
  String? accessToken = '';
  SharedPreferences? loginData;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    checkUserStatus();
  }

  void checkUserStatus() async {
    //we need to instantiate the shared preference
    loginData = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = loginData!.getBool('loggedIn');
    });

    if (isLoggedIn!) {
      goHome();
    }
  }

  void goHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Responsive(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _passwordFocus.dispose();
  }

  void _handleSubmit() async {
    final bool isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();

      setState(() {
        isLoading = true;
      });

      Future.delayed(const Duration(seconds: 30), () {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: red,
            behavior: SnackBarBehavior.floating,
            content: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                child: const Text(
                    "Connection Timeout: Unable to connect to the server. Please check your internet connection and try again."),
              ),
            ),
          ),
        );
      });

      final QueryResult _result =
          await _graphql_service.login(phone: phoneNumber, password: password);

      if (_result.hasException) {
        print(_result.exception?.graphqlErrors.first.message);
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: red,
            behavior: SnackBarBehavior.floating,
            content: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                child: Text(_result.exception!.graphqlErrors.first.message),
              ),
            ),
          ),
        );

        return;
      }

      setState(() {
        result = _result;
      });

      //setting the shared preference
      loginData?.setBool("loggedIn", true);
      loginData?.setString("accessToken", result!.data!["login"]["accestoken"]);

      setState(() {
        isLoading = false;
      });

      goHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn!
        ? Responsive()
        : Scaffold(
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 300,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Container(
                                  width: 300,
                                  height: 300,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          AssetImage("assets/images/logo.png"),
                                    ),
                                  ),
                                ),
                              ),

                              //Welcome text

                              // const SizedBox(
                              //   height: 12,
                              // ),
                              const TextApp(
                                title: "Welcome Back",
                                weight: FontWeight.bold,
                                size: 30,
                              ),
                              // const SizedBox(
                              //   height: 12,
                              // ),

                              TextFormField(
                                  decoration: const InputDecoration(
                                      hintText: "Phone Number"),
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(_passwordFocus);
                                  },
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value!.isEmpty || value == '') {
                                      return "Please Enter your phone";
                                    }

                                    if (value.length < 10 ||
                                        value.length > 10) {
                                      return "Please enter a 10-digit phone number";
                                    }

                                    return null;
                                  },
                                  onSaved: (value) {
                                    phoneNumber = value!;
                                  }),
                              TextFormField(
                                  decoration: InputDecoration(
                                      hintText: "Password",
                                      suffix: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            showPassword = !showPassword;
                                          });
                                        },
                                        icon: showPassword
                                            ? const Icon(
                                                Icons.visibility_off_outlined)
                                            : const Icon(
                                                Icons.visibility_outlined),
                                      )),
                                  textInputAction: TextInputAction.done,
                                  focusNode: _passwordFocus,
                                  obscureText: showPassword,
                                  onFieldSubmitted: (value) {
                                    _handleSubmit();
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please Enter your password";
                                    }
                                    if (value.length < 6) {
                                      return "Password should be at least 6 characters long";
                                    }

                                    return null;
                                  },
                                  onSaved: (value) {
                                    password = value!;
                                  }),

                              const SizedBox(
                                height: 12,
                              ),

                              Container(
                                  alignment: Alignment.centerRight,
                                  child: const Text(
                                    "Forgot password",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: lightBlue,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )),

                              const SizedBox(
                                height: 12,
                              ),

                              isLoading
                                  ? Center(
                                      child: Container(
                                        width: 100,
                                        child: Lottie.asset(
                                            "assets/images/loading.json"),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        _handleSubmit();
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: darkBlue,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Text(
                                          "L O G I N",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
