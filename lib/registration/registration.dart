import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warranty_admin/components/toast.dart';
import 'package:warranty_admin/const/style.dart';
import 'package:warranty_admin/provider/auth_service.dart';

class Registration extends StatefulWidget {
  Registration({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Registration> {
  bool _hidePass = true;
  bool _validation = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 10, right: 10),
        color: Colors.grey[200],
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  hintText: 'Jhon Doe',
                  errorText: _validation ? 'name not be empty' : null,
                  prefixIcon: Icon(Icons.person),
                ),
                onChanged: (value) {
                  print('Password ===> $value');
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'name@example.com',
                  errorText: _validation ? 'country not be empty' : null,
                  prefixIcon: Icon(Icons.email),
                ),
                onChanged: (value) {
                  print('Password ===> $value');
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone',
                  hintText: '+60187832241',
                  errorText: _validation ? 'phone not be empty' : null,
                  prefixIcon: Icon(Icons.mobile_friendly_sharp),
                ),
                onChanged: (value) {
                  print('Password ===> $value');
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: _hidePass,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'password',
                  errorText: _validation ? 'password not be empty' : null,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                      color: Theme.of(context).accentColor.withOpacity(0.4),
                      icon: Icon(
                          _hidePass ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _hidePass = !_hidePass;
                        });
                      }),
                ),
                onChanged: (value) {
                  print('inputted password ===> $value');
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _hidePass,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Password',
                  hintText: 'confirm password',
                  errorText:
                      _validation ? 'confirm password not be empty' : null,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                      color: Theme.of(context).accentColor.withOpacity(0.4),
                      icon: Icon(
                          _hidePass ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _hidePass = !_hidePass;
                        });
                      }),
                ),
                onChanged: (value) {
                  print('inputted confirm password ===> $value');
                },
              ),
              SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 45,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.green[900];
                        return Colors.green; // Use the component's default.
                      },
                    ),
                  ),
                  child: Text('Register Now', style: normalStyle),
                  onPressed: () async {
                    print('===> register button pressed');
                    setState(() {
                      if (_nameController.text.isEmpty &&
                          _emailController.text.isEmpty &&
                          _phoneController.text.isEmpty &&
                          _passwordController.text.isEmpty) {
                        //_validation = true;
                        ToastDisplay.displayMessage(
                            'all fields are required', context);

                        print('fields are required');
                      } else if (_passwordController.text !=
                          _confirmPasswordController.text) {
                        ToastDisplay.displayMessage(
                            'Password doesn\'t match', context);
                        print('Pass doesn\'t match');
                      } else {
                        _registerUserNow(context);
                      }
                    });
                  },
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _registerUserNow(BuildContext context) async {
    AuthService _authSate = Provider.of<AuthService>(context, listen: false);

    Future.delayed(const Duration(milliseconds: 500), () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
          );
        },
      );

      setState(() {
        Navigator.pop(context);
      });
    });

    await _authSate.registerUser(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      password: _confirmPasswordController.text,
      context: context,
    );
  }
}
