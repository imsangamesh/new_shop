import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:new_shop/models/myHttpException.dart';
import 'package:new_shop/providers/auth.dart';
import 'package:new_shop/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/authScreen';
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

enum AuthMode { login, signUp }

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _authMode = AuthMode.login;
  String _email;
  String _confirmPwd1 = '';
  String _confirmPwd2 = '';
  bool _isError = false;
  bool _isLoading = false;
  final _form = GlobalKey<FormState>();

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          errorMessage,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.redAccent,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.check),
            label: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  void _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      setState(() => _isError = true);
      return;
    }
    setState(() => _isError = false);
    _form.currentState.save();
    setState(() => _isLoading = true);
    try {
      if (_authMode == AuthMode.login) {
        // log user in
        await Provider.of<Auth>(context, listen: false)
            .login(_email.trim(), _confirmPwd1);
      } else {
        // sign user in
        await Provider.of<Auth>(context, listen: false)
            .signUp(_email.trim(), _confirmPwd1);
      }
    } on MyHttpException catch (error) {
      setState(() => _isLoading = false);
      var errorMessage = 'authentication failed.';
      if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'invalid password.';
      } else if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'this email is already in use, please try logging in.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'your password in too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage =
            'could not find a user with that email address, please signUp instead.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'please provide a valid email address.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      setState(() => _isLoading = false);
      const errorMessage =
          'Could not authenticate you. Please try again after some time.';
      _showErrorDialog(errorMessage);
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Container(
          height: _deviceSize.height * 1,
          width: _deviceSize.width * 1,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 208, 68),
                Color.fromARGB(255, 255, 54, 121),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: EdgeInsets.only(
            top: 17,
            left: 17,
            right: 17,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 10,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 255, 236, 180),
                    ),
                    child: Text(
                      'SANShop',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 16,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      color: const Color.fromARGB(132, 255, 251, 251),
                    ),
                    padding: const EdgeInsets.all(13),
                    height: _authMode == AuthMode.signUp
                        ? _isError
                            ? _deviceSize.height * 0.463
                            : _deviceSize.height * 0.42
                        : _isError
                            ? _deviceSize.height * 0.39
                            : _deviceSize.height * 0.33,
                    child: Form(
                      key: _form,
                      child: ListView(
                        //_deviceSize.height * 0.42
                        children: [
                          TextFormField(
                            // ---------------------------------1-------------------
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'please provide your email.';
                              } else if (!value.contains('@')) {
                                return 'please provide a valid email address.';
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              labelText: 'email address',
                              hintText: 'eg:  san.sangamesh96@gmail.com',
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              _email = value;
                            },
                          ),
                          TextFormField(
                            // ---------------------------------2-------------------
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'please provide your password.';
                              } else if (value.length <= 5) {
                                return 'password should be atleast 6 characters long.';
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              labelText: 'password',
                              hintText: 'eg:  itsAsecret',
                            ),
                            textInputAction: _authMode == AuthMode.login
                                ? TextInputAction.done
                                : TextInputAction.next,
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            onChanged: (value) {
                              _confirmPwd1 = value;
                            },
                            onFieldSubmitted: _authMode == AuthMode.login
                                ? (_) => _saveForm()
                                : null,
                          ),
                          if (_authMode == AuthMode.signUp)
                            TextFormField(
                              // ---------------------------------3-------------------
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please provide your password.';
                                } else if (value.length <= 5) {
                                  return 'password should be atleast 6 characters long.';
                                } else if (_confirmPwd1 != _confirmPwd2) {
                                  return 'both passwords should be same.';
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                labelText: 'password',
                                hintText: 'eg:  itsAsecret',
                              ),
                              textInputAction: TextInputAction.done,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              onChanged: (value) {
                                _confirmPwd2 = value;
                              },
                              onFieldSubmitted: _authMode == AuthMode.signUp
                                  ? (_) => _saveForm()
                                  : null,
                            ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              _saveForm();
                              setState(() => _authMode = AuthMode.login);
                            },
                            icon: const Icon(Icons.login_rounded),
                            label: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _saveForm();
                              setState(() => _authMode = AuthMode.signUp);
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
