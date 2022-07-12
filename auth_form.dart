import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFunction, this.isLoading);
  final bool isLoading;

  final void Function(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) submitFunction;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final passwordCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var _LoginMode = true;

  String? _userEmail = '';
  String? _userPassword = '';
  String? _userName = '';

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFunction(
        _userEmail!.trim(),
        _userName!.trim(),
        _userPassword!.trim(),
        _LoginMode,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (input) {
                      if (!input!.contains('@') || input.isEmpty) {
                        return "Please forward a valid email adress";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email adress'),
                    onSaved: (input) {
                      _userEmail = input;
                    },
                    controller: emailCtrl,
                  ),
                  if (!_LoginMode)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (input) {
                        if (input!.length < 4 || input.isEmpty) {
                          return "Please enter at least 4 characters";
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Username'),
                      onSaved: (input) {
                        _userName = input;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (input) {
                      if (input!.length < 7 || input.isEmpty) {
                        return "Password should be at least 7 characters long";
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (input) {
                      _userPassword = input;
                    },
                    controller: passwordCtrl,
                  ),
                  SizedBox(height: 12),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      child: Text(_LoginMode ? 'Login' : 'Signup'),
                      onPressed: _submit,
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _LoginMode = !_LoginMode;
                        });
                      },
                      child: Text(_LoginMode
                          ? 'Create new account'
                          : 'I have a acoount'),
                      textColor: Theme.of(context).colorScheme.primary,
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
