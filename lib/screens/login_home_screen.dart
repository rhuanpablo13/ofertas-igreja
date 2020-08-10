import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:ofertasigrejaflutter/messages/messages.dart';
import 'package:ofertasigrejaflutter/models/user_model.dart';
import 'package:ofertasigrejaflutter/screens/home_screen.dart';
import 'package:ofertasigrejaflutter/screens/signup_screen.dart';
import 'package:ofertasigrejaflutter/validators/validator.dart';
import 'package:scoped_model/scoped_model.dart';


// Tela de login inicial do app
class LoginHomeScreen extends StatefulWidget {

   @override
   LoginHomeScreenState createState() => LoginHomeScreenState();
}


class LoginHomeScreenState extends State<LoginHomeScreen> {

   final _formKey = GlobalKey<FormState>();
   final _emailController = TextEditingController();
   final _passController = TextEditingController();
   final _scafoldKey = GlobalKey<ScaffoldState>();
   var _formaLogin = '';

  @override
  Widget build(BuildContext context) {

     _emailController.text = 'rhuanpablo13@hotmail.com';
     _passController.text = '123456';

     return Scaffold(
        key: _scafoldKey,
        appBar: AppBar(
           title: Text('Entrar'),
           centerTitle: true,
           actions: <Widget>[
              FlatButton(
                 child: Text('Criar Conta', style:
                 TextStyle(
                    fontSize: 15.0
                 )
                 ),
                 textColor: Colors.white,
                 onPressed: () {
                    Navigator.of(context).push(
                       MaterialPageRoute(builder: (context) => SignupScreen(boAlteracao: false))
                    );
                 },
              )
           ],
        ),

        body: ScopedModelDescendant<UserModel>(
           builder: (context, child, model) {
              if (model.isLoading())
                 return Center(child: CircularProgressIndicator());
              return Form(
                 key: _formKey,
                 child: ListView(
                    padding: EdgeInsets.all(16.0),
                    children: <Widget>[

                       Padding(
                          padding: EdgeInsets.only(top: 50.0, bottom: 60.0),
                          child: Text(
                             'OFERTAS IGREJA',
                             style: TextStyle(
                                fontSize: 25.0,
                                fontFamily: 'Roboto Bold'
                             ),
                             textAlign: TextAlign.center,
                          ),
                       ),

                       SizedBox(height: 16.0),
                       TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                             hintText: 'E-mail'
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (text) {
                             if (!EmailValidator.validate(text)) {
                                return 'E-mail inválido';
                             }
                             return null;
                          },
                       ),
                       SizedBox(height: 16.0),
                       TextFormField(
                          controller: _passController,
                          decoration: InputDecoration(
                             hintText: 'Senha'
                          ),
                          validator: (text) {
                             if (text.isEmpty || text.length < 6) {
                                return 'Senha inválida';
                             }
                             return null;
                          },
                          obscureText: true,
                       ),
                       Align(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                             onPressed: () {
                                if (_emailController.text.isEmpty) {
                                   _scafoldKey.currentState.showSnackBar(
                                      SnackBar(content: Text('Insira seu e-mail para recuperação'),
                                         backgroundColor: Colors.redAccent,
                                         duration: Duration(seconds: 2)
                                      )
                                   );
                                } else {
                                   model.recoverPass(_emailController.text);
                                   _scafoldKey.currentState.showSnackBar(
                                      SnackBar(content: Text('Confira seu e-mail'),
                                         backgroundColor: Theme.of(context).primaryColor,
                                         duration: Duration(seconds: 2)
                                      )
                                   );
                                }
                             },
                             child: Text('Esqueci minha senha',
                                textAlign: TextAlign.right
                             ),
                             padding: EdgeInsets.zero,
                          ),
                       ),
                       SizedBox(height: 16.0),
                       RaisedButton(
                          child: Text('Entrar',
                             style: TextStyle(
                                fontSize: 18.0
                             )
                          ),
                          textColor: Colors.white,
                          color: Theme.of(context).primaryColor,
                          onPressed: () {

                             if (_formKey.currentState.validate()) {

                                model.signIn(
                                   email: _emailController.text,
                                   pass: _passController.text,
                                   onFail: (e) {
                                      _scafoldKey.currentState.showSnackBar(
                                         SnackBar(content: Text('$e'),
                                            backgroundColor: Colors.redAccent,
                                            duration: Duration(seconds: 2)
                                         )
                                      );
                                   },
                                   onSuccess: () {
                                      if (model.isLogged()) {
                                         model.isEmailConfirmed().then((isConfirmed) {
                                            if (isConfirmed) {
                                               Navigator.of(context).push(
                                                  MaterialPageRoute(builder: (context) => HomeScreen())
                                               );
                                            } else {
                                               Messages.showAlertDialog('Seu e-mail não foi verificado, por favor acesse ${_emailController.text} e procure um e-mail que enviamos para confirmação :) Ps.: Se não encontrar, verifique também sua caixa de SPAM!', context);
                                               model.signOut();
                                            }
                                         });
                                      }
                                   }
                                );
                             }
                          },
                       )
                    ],
                 ),
              );
           },
        )
     );
  }
}

