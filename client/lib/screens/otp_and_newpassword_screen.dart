import 'package:client/providers/auth_provider.dart';
import 'package:flutter/material.dart';

String? _notNullValidator(value) {
  if (value.isEmpty) {
    return "field cant be empty";
  } else {
    return null;
  }
}

class OtpAndNewPasswordScreen extends StatefulWidget {
  final Function clickLoginButtonFunction;
  final AuthProvider authProvider;
  const OtpAndNewPasswordScreen(
      {super.key,
      required this.clickLoginButtonFunction,
      required this.authProvider});

  @override
  State<OtpAndNewPasswordScreen> createState() =>
      _OtpAndNewPasswordScreenState();
}

class _OtpAndNewPasswordScreenState extends State<OtpAndNewPasswordScreen> {
  final _formGlobalKey = GlobalKey<FormState>();
  final formMap = <String, String>{};

  late FocusNode _otpFocusNode;
  late FocusNode _passwordFocusNode;
  late FocusNode _reEnterPasswordFocusNode;
  late TextEditingController _passwordController;

  bool _isLoading = false;

  @override
  void initState() {
    _otpFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _reEnterPasswordFocusNode = FocusNode();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _otpFocusNode.dispose();
    _passwordController.dispose();
    _reEnterPasswordFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(15, 70, 15, 15),
            height: double.infinity,
            child: Form(
                key: _formGlobalKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        focusNode: _otpFocusNode,
                        validator: _notNullValidator,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },
                        onSaved: (newValue) =>
                            formMap["otp"] = newValue as String,
                        decoration: InputDecoration(
                            label: const Text("Enter OTP"),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        validator: _notNullValidator,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(_reEnterPasswordFocusNode);
                        },
                        onSaved: (newValue) =>
                            formMap["newPassword"] = newValue as String,
                        obscureText: true,
                        decoration: InputDecoration(
                            label: const Text("Password"),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        focusNode: _reEnterPasswordFocusNode,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return "Passwords dont match";
                          } else {
                            return null;
                          }
                        },
                        textInputAction: TextInputAction.next,
                        obscureText: true,
                        decoration: InputDecoration(
                            label: const Text("Re-enter password"),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formGlobalKey.currentState!.validate()) {
                              _formGlobalKey.currentState!.save();
                              try {
                                setState(() {
                                  _isLoading = true;
                                });
                                await widget.authProvider.changePassword(
                                    otp: formMap["otp"]!,
                                    newPassword: formMap["newPassword"]!);
                                setState(() {
                                  _isLoading = false;
                                });
                                widget.clickLoginButtonFunction();
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
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30)))),
                          child: const Text("Verify and Change password"),
                        ),
                      ),
                    ])),
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
      floatingActionButton: SizedBox(
        height: 50,
        width: 120,
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)))),
          onPressed: () {
            widget.clickLoginButtonFunction();
          },
          child: Row(
            children: const [
              Icon(Icons.arrow_back),
              SizedBox(
                width: 10,
              ),
              Text("Log in"),
            ],
          ),
        ),
      ),
    );
  }
}
