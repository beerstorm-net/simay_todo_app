import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simay_todo_app/blocs/main/main_bloc.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _formInput = new Map();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              onChanged: (value) =>
                  setState(() => _formInput['username'] = value),
              decoration: InputDecoration(
                labelText: 'username',
                hintText: 'başvuru yaptığınız mail adresi',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return "This is required";
                }

                return null;
              },
            ),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              onChanged: (value) =>
                  setState(() => _formInput['password'] = value),
              decoration: InputDecoration(
                labelText: 'password',
                hintText: '123456',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return "This is required";
                }

                return null;
              },
            ),
            SizedBox(
              height: 8,
            ),
            ElevatedButton(
              child: Icon(
                Icons.login,
                size: 33,
              ),
              onPressed: () {
                setState(() {
                  _formKey.currentState.save();
                  print("_formInput: $_formInput");
                  if (_formKey.currentState.validate()) {
                    BlocProvider.of<MainBloc>(context).add(LoginEvent(
                        username: _formInput["username"],
                        password: _formInput["password"]));
                  }
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
