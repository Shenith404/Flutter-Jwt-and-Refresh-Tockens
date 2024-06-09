import 'package:erpmobile/Routing/router_names.dart';
import 'package:erpmobile/Services/authe_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  bool obcureText1 = true;
  bool obcureText2 = true;
  bool showIcon = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final autheService = AuthService();

  //LogIN
  void LogIn() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => const Dialog(
            backgroundColor: Colors.transparent, child: Text("Please wait")));

    var result =
        await autheService.login(emailController.text, passwordController.text);

    if (result == true) {
      Navigator.of(context).pop();
      context.goNamed(RouterNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.08,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                const Text("Log In",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter the Email";
                      } else {
                        // Basic email format validation using a regular expression
                        String emailRegex =
                            r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
                        RegExp regex = RegExp(emailRegex);

                        if (!regex.hasMatch(value)) {
                          return 'Enter a valid email address';
                        }

                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      labelText: 'Enter Username',
                      hintText: 'e.g., john_doe@gmail.com',
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: obcureText2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter the Password";
                      } else if (value.length < 6) {
                        return "Password must be at least 6 characters long";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      labelText: 'Enter Password',
                      hintText: 'Abc@123',
                      suffixIcon: IconButton(
                        icon: showIcon
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            obcureText2 = !obcureText2;
                            showIcon = !showIcon;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //second
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      LogIn();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: height * 0.02),
                    child: const Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Text("Don't have an Account ?",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              GestureDetector(
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
            ],
          )
        ],
      ),
    );
  }
}
