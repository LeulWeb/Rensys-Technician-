import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:technician_rensys/constants/colors.dart';
import 'package:technician_rensys/services/graphql_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../responsive/responsive_layout.dart';

//Working with shared preference

class Login extends StatefulWidget {
  final void Function(Locale locale) setLocale;

  const Login({super.key, required this.setLocale});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String phoneNumber = '';
  String password = '';
  final graphqlService = GraphQLService();
  final FocusNode _passwordFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  QueryResult? result;
  String errorMessage = "";
  //Check if the user is new to the app
  bool? isLoggedIn = false;
  String? accessToken = '';
  SharedPreferences? loginData;
  bool showPassword = true;
  Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    checkUserStatus();
  }

  @override
  void dispose() {
    _passwordFocus.dispose();
    //dispose all the controllers

    super.dispose();
  }

  void checkUserStatus() async {
    //we need to instantiate the shared preference
    loginData = await SharedPreferences.getInstance();
    if (loginData != null) {
      setState(() {
        isLoggedIn = (loginData?.getBool('loggedIn') ?? true);
      });

      if (isLoggedIn!) {
        goHome();
      }
    }
  }

  void goHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Responsive(setLocale: widget.setLocale),
      ),
    );
  }

  void _handleSubmit() async {
    final bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();

      setState(() {
        isLoading = true;
      });
      final result =
          await graphqlService.login(phone: phoneNumber, password: password);

      setState(() {
        isLoading = false;
      });

      if (result.hasException) {
        if (result.exception!.graphqlErrors.isNotEmpty) {
          if (result.exception!.graphqlErrors.first.message ==
                  'incorrect password' ||
              result.exception!.graphqlErrors.first.message ==
                  'incorrect username or password please enter again') {
            showError(
                "Incorrect Email or Password. Please double-check your login credentials and try again.");
          } else {
            showError(
                "Unable to Connect to Server. Please check your internet connection and try again. If the problem persists, please contact our support team for further assistance.");
          }
        }
      }

      //setting the shared preference

      loginData!.setBool("loggedIn", true);
      loginData!.setString("accessToken", result.data!["login"]["accestoken"]);
      goHome();
    }
  }

  void showError(String errMessage) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(errMessage),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
      padding: const EdgeInsets.all(10),
      showCloseIcon: true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn!
        ? Responsive(
            setLocale: widget.setLocale,
          )
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              const Text(
                                "Welcome to Rensys",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: "Phone Number",
                                    border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: darkBlue, width: 1),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: darkBlue, width: 1),
                                    ),
                                  ),
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
                                      border: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: darkBlue,
                                          width: 1,
                                        ),
                                      ),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: darkBlue, width: 1),
                                      ),
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
                              // Container(
                              //     alignment: Alignment.centerRight,
                              //     child: const Text(
                              //       "Forgot password",
                              //       style: TextStyle(
                              //         fontSize: 12,
                              //         color: lightBlue,
                              //         fontWeight: FontWeight.normal,
                              //       ),
                              //     )),
                              // const SizedBox(
                              //   height: 12,
                              // ),
                              isLoading
                                  ? Center(
                                      child: SizedBox(
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
                                          color: lightBlue,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.handyman_outlined,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Text(
                                              "L O G I N",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
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
