import 'package:flutter/material.dart';

import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  final Function loginClicked;
  final AuthProvider authProvider;
  const RegisterScreen({
    super.key,
    required this.loginClicked,
    required this.authProvider,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formGlobalKey = GlobalKey<FormState>();
  final Map<String, String> formMap = {};
  bool _isLoading = false;

  late FocusNode _lastNameFocusNode;
  late FocusNode _passwordFocusNode;
  late FocusNode _reEnterPasswordFocusNode;
  late FocusNode _houseNumberFocusNode;
  late FocusNode _streetNameFocusNode;
  late FocusNode _pinCodeFocusNode;
  late FocusNode _phoneNumberFocusNode;
  late FocusNode _emailFocusNode;

  late TextEditingController _passwordController;

  String? _notNullValidator(value) {
    if (value.isEmpty) {
      return "field cant be empty";
    } else {
      return null;
    }
  }

  @override
  void initState() {
    _lastNameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _reEnterPasswordFocusNode = FocusNode();
    _houseNumberFocusNode = FocusNode();
    _streetNameFocusNode = FocusNode();
    _pinCodeFocusNode = FocusNode();
    _phoneNumberFocusNode = FocusNode();
    _emailFocusNode = FocusNode();

    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _lastNameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _reEnterPasswordFocusNode.dispose();
    _houseNumberFocusNode.dispose();
    _streetNameFocusNode.dispose();
    _pinCodeFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _emailFocusNode.dispose();

    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
            height: double.infinity,
            child: Form(
                key: _formGlobalKey,
                child: SingleChildScrollView(
                  child: Column(children: [
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      validator: _notNullValidator,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_lastNameFocusNode);
                      },
                      onSaved: (newValue) =>
                          formMap["firstName"] = newValue as String,
                      decoration: InputDecoration(
                          label: const Text("First Name"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      focusNode: _lastNameFocusNode,
                      validator: _notNullValidator,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                      onSaved: (newValue) =>
                          formMap["lastName"] = newValue as String,
                      decoration: InputDecoration(
                          label: const Text("Last Name"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      validator: _notNullValidator,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(_reEnterPasswordFocusNode);
                      },
                      onSaved: (newValue) =>
                          formMap["password"] = newValue as String,
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
                      focusNode: _reEnterPasswordFocusNode,
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return "Passwords dont match";
                        } else {
                          var re = RegExp(
                              r"^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)$");
                          if (re.hasMatch(value!)) {
                            return null;
                          }
                          return "the password should have atleast one alphabet and number";
                        }
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(_houseNumberFocusNode);
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          label: const Text("Re-enter password"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      focusNode: _houseNumberFocusNode,
                      validator: _notNullValidator,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(_streetNameFocusNode);
                      },
                      onSaved: (newValue) =>
                          formMap["houseNo"] = newValue as String,
                      decoration: InputDecoration(
                          label: const Text("house number"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      focusNode: _streetNameFocusNode,
                      validator: _notNullValidator,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_pinCodeFocusNode);
                      },
                      onSaved: (newValue) =>
                          formMap["streetName"] = newValue as String,
                      decoration: InputDecoration(
                          label: const Text("street name"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      focusNode: _pinCodeFocusNode,
                      validator: _notNullValidator,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(_phoneNumberFocusNode);
                      },
                      onSaved: (newValue) =>
                          formMap["pinCode"] = newValue as String,
                      decoration: InputDecoration(
                          label: const Text("pincode"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      focusNode: _phoneNumberFocusNode,
                      validator: _notNullValidator,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_emailFocusNode);
                      },
                      onSaved: (newValue) =>
                          formMap["phoneNumber"] = newValue as String,
                      decoration: InputDecoration(
                          label: const Text("phone number"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      focusNode: _emailFocusNode,
                      validator: _notNullValidator,
                      textInputAction: TextInputAction.done,
                      onSaved: (newValue) =>
                          formMap["email"] = newValue as String,
                      decoration: InputDecoration(
                          label: const Text("email"),
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
                              await widget.authProvider.register(
                                firstName: formMap["firstName"]!,
                                lastName: formMap["lastName"]!,
                                password: formMap["password"]!,
                                houseNo: formMap["houseNo"]!,
                                streetName: formMap["streetName"]!,
                                pinCode: formMap["pinCode"]!,
                                phoneNumber: formMap["phoneNumber"]!,
                                email: formMap["email"]!,
                              );
                              setState(() {
                                _isLoading = true;
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

                            // Provider.of<AuthProvider>(context, listen: false)
                            //     .register(formMap);
                          }
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)))),
                        child: const Text("register"),
                      ),
                    ),
                  ]),
                )),
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
      floatingActionButton: Container(
        margin: const EdgeInsets.all(5),
        height: 50,
        width: 120,
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)))),
          onPressed: () {
            widget.loginClicked();
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
