import 'package:client/providers/auth_provider.dart';
import 'package:flutter/material.dart';

String? _notNullValidator(value) {
  if (value.isEmpty) {
    return "field cant be empty";
  } else {
    return null;
  }
}

class PhoneNumberScreen extends StatefulWidget {
  final Function clickNextButtonFunction;
  final Function clickLoginButtonFunction;
  final AuthProvider authProvider;
  const PhoneNumberScreen({
    super.key,
    required this.clickNextButtonFunction,
    required this.clickLoginButtonFunction,
    required this.authProvider,
  });

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  late final GlobalKey<FormState> _phoneNumberGlobalKey;
  bool _isLoading = false;

  @override
  void initState() {
    _phoneNumberGlobalKey = GlobalKey<FormState>();

    super.initState();
  }

  final phoneNumberMap = <String, String>{};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Form(
              key: _phoneNumberGlobalKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      validator: _notNullValidator,
                      onSaved: (newValue) =>
                          phoneNumberMap["phoneNumber"] = newValue as String,
                      // onTap: () {
                      //   FocusScope.of(context).requestFocus(_passwordFocusNode);
                      // },
                      onFieldSubmitted: (value) {},
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        labelStyle: const TextStyle(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_phoneNumberGlobalKey.currentState!.validate()) {
                            _phoneNumberGlobalKey.currentState!.save();
                            try {
                              setState(() {
                                _isLoading = true;
                              });
                              await widget.authProvider.sendOTP(
                                  phoneNumber: phoneNumberMap["phoneNumber"]!);
                              setState(() {
                                _isLoading = false;
                              });
                              widget.clickNextButtonFunction();
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
                                    borderRadius: BorderRadius.circular(30)))),
                        child: const Text("Next"),
                      ),
                    ),
                    // const SizedBox(height: 50),
                  ],
                ),
              )),
          GestureDetector(
            behavior: _isLoading
                ? HitTestBehavior.opaque
                : HitTestBehavior.translucent,
            child: _isLoading
                ? const Center(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Container(),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Container(
        margin: const EdgeInsets.all(10),
        height: 50,
        width: 100,
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)))),
          onPressed: () {
            widget.clickLoginButtonFunction();
          },
          child: const Text("Log in"),
        ),
      ),
    );
  }
}
