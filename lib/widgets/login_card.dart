import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';
import '../providers/auth.dart';

class LoginCard extends StatefulWidget {
  const LoginCard({Key? key, required this.deviceSize}) : super(key: key);
  final Size deviceSize;
  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final Map<String, String> _authData = {'email': '', 'password': ''};
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordCont = TextEditingController();

  bool _isLoading = false;

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Error has occured"),
        content: Text(msg),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).login(
        _authData['email'].toString(),
        _authData['password'].toString(),
      );
    } on HttpException catch (error) {
      String errorMsg = "Authentication Failed!";
      if (error.toString().contains(
          'Maaf username salah atau anda tidak berada di satuan kerja OMM')) {
        errorMsg =
            'Maaf username salah atau anda tidak berada di satuan kerja OMM';
      } else if (error.toString().contains(
          "Username / Password Salah atau anda tidak punya hak akses.")) {
        errorMsg = "Username / Password Salah atau anda tidak punya hak akses.";
      }
      _showErrorDialog(errorMsg);
    } catch (error) {
      print(error);
      const errorMessage =
          'Terjadi gangguan pada server silakan coba lagi nanti';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  } //Future

  String dropdownValue = 'Perusahaan Gas Negara';
  var items = ['Perusahaan Gas Negara', 'PGAS Solution'];
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            elevation: 8.0,
            child: Container(
              height: 60,
              constraints: const BoxConstraints(
                minHeight: 60,
              ),
              width: widget.deviceSize.width * 0.95,
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Center(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: dropdownValue,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      hint: const Text("Pilih salah satu"),
                      items: items.map((String e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            elevation: 8.0,
            child: Container(
              height: 60,
              constraints: const BoxConstraints(
                minHeight: 60,
              ),
              width: widget.deviceSize.width * 0.95,
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                style: const TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Email',
                  // icon: Icon(Icons.person, color: Colors.black),
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  fillColor: Colors.black,
                  focusColor: Colors.black,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Email tidak boleh kosong!";
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['email'] = value.toString();
                },
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            elevation: 8.0,
            child: Container(
              height: 60,
              constraints: const BoxConstraints(
                minHeight: 60,
              ),
              width: widget.deviceSize.width * 0.95,
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                textInputAction: TextInputAction.done,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration.collapsed(
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  focusColor: Colors.black,
                  fillColor: Colors.black,
                ),
                obscureText: true,
                controller: _passwordCont,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password tidak boleh kosong!";
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['password'] = value.toString();
                },
              ),
            ),
          ),
          Container(
            child: _isLoading
                ? Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : ElevatedButton(
                    onPressed: _submit,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.deviceSize.width > 600
                            ? 158
                            : widget.deviceSize.width / 2.35,
                      ),
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text(
                      "LOGIN",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
