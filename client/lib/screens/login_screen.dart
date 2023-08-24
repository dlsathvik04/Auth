import 'package:client/providers/auth_provider.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final Function registerClicked;
  final Function forgotPasswordClicked;
  final AuthProvider authProvider;
  const LoginScreen(
      {super.key,
      required this.registerClicked,
      required this.forgotPasswordClicked,
      required this.authProvider});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late GlobalKey<FormState> _loginFormGlobalKey;
  late FocusNode _phoneNumberLoginFocusNode;
  late FocusNode _passwordLoginFocusNode;
  bool _isLoading = false;
  final loginMap = <String, String>{};

  @override
  void initState() {
    _loginFormGlobalKey = GlobalKey<FormState>();
    _phoneNumberLoginFocusNode = FocusNode();
    _passwordLoginFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordLoginFocusNode.dispose();
    _phoneNumberLoginFocusNode.dispose();
    super.dispose();
  }

  String? _notNullValidator(value) {
    if (value.isEmpty) {
      return "field cant be empty";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Form(
            key: _loginFormGlobalKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextFormField(
                    validator: _notNullValidator,
                    onSaved: (newValue) =>
                        loginMap["phoneNumber"] = newValue ?? "",
                    focusNode: _phoneNumberLoginFocusNode,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context)
                          .requestFocus(_passwordLoginFocusNode);
                    },
                    onTapOutside: (event) {
                      if (FocusScope.of(context).hasFocus) {
                        FocusScope.of(context).unfocus();
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    validator: _notNullValidator,
                    onSaved: (newValue) =>
                        loginMap["password"] = newValue ?? "",
                    focusNode: _passwordLoginFocusNode,
                    onFieldSubmitted: (value) {},
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    onTapOutside: (event) {
                      if (FocusScope.of(context).hasFocus) {
                        FocusScope.of(context).unfocus();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_loginFormGlobalKey.currentState!.validate()) {
                          _loginFormGlobalKey.currentState!.save();
                          try {
                            setState(() {
                              _isLoading = true;
                            });
                            await widget.authProvider.login(
                                phoneNumber: loginMap["phoneNumber"]!,
                                password: loginMap["password"]!);
                            setState(() {
                              _isLoading = false;
                            });
                          } catch (err) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Text(err.toString()),
                                backgroundColor:
                                    const Color.fromARGB(255, 233, 99, 89),
                              ),
                            );
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                        // Provider.of<AuthProvider>(context, listen: false)
                        //     .logIn();
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)))),
                      child: const Text("login"),
                    ),
                  ),
                  TextButton(
                      onPressed: () => widget.forgotPasswordClicked(),
                      child: const Text("forgot password")),
                  // const SizedBox(height: 150),
                  TextButton(
                      onPressed: () => widget.registerClicked(),
                      child: const Text("Register")),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          GestureDetector(
            behavior: _isLoading
                ? HitTestBehavior.opaque
                : HitTestBehavior.translucent,
            child: _isLoading
                ? const Center(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}
