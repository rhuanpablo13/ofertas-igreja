import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:ofertasigrejaflutter/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class AtualizarLogin extends StatelessWidget {

   final _scaffoldKey = GlobalKey<ScaffoldState>();
   final _formKey = GlobalKey<FormState>();

   final _emailController = TextEditingController();
   final _passOldController = TextEditingController();
   final _passNewController = TextEditingController();


   @override
   Widget build(BuildContext context) {

      return Scaffold(
         key: _scaffoldKey,
         appBar: AppBar(
            title: Text('Atualizar Login'),
            centerTitle: true,
         ),

         body: ScopedModelDescendant<UserModel> (
            builder: (context, child, model) {

               if (model.isLoading()) {
                  return CircularProgressIndicator();
               }

               return Form(
                  key: _formKey,
                  child: Column(
                     children: <Widget>[

                        Container(
                           padding: EdgeInsets.only(top: 50.0, bottom: 20.0),
                           alignment: Alignment.center,
                           child: Text('Informações de Login',
                              style: TextStyle(
                                 fontSize: 18.0
                              ),
                              textAlign: TextAlign.center,
                           ),
                        ),


                        Container(
                           width: 300.0,
                           child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                 hintText: 'E-mail'
                              ),
                              validator: (text) {
                                 if (text.isEmpty) {
                                    return 'Campo não pode estar vazio';
                                 }
                                 if (!EmailValidator.validate(text)) {
                                    return 'Email não válido';
                                 }
                                 return null;
                              },
                           ),
                        ),


                        // senha antiga
                        Container(
                           width: 300.0,
                           child: TextFormField(
                              controller: _passOldController,
                              decoration: InputDecoration(
                                 hintText: 'Senha Atual'
                              ),
                              obscureText: true,
                              validator: (text) {
                                 if (text.isEmpty) {
                                    return 'Campo não pode estar vazio';
                                 }
                                 return null;
                              },
                           ),
                        ),


                        // nova senha
                        Container(
                           padding: EdgeInsets.only(bottom: 20.0),
                           width: 300.0,
                           child: TextFormField(
                              controller: _passNewController,
                              decoration: InputDecoration(
                                 hintText: 'Nova Senha'
                              ),
                              obscureText: true,
                              validator: (text) {
                                 if (text.isEmpty) {
                                    return 'Campo não pode estar vazio';
                                 }
                                 return null;
                              },
                           ),
                        ),


                        Container(
                           width: 300.0,
                           child: RaisedButton(
                              child: Text('Atualizar',
                                 style: TextStyle(
                                    fontSize: 18.0
                                 )
                              ),
                              textColor: Colors.white,
                              color: Theme.of(context).primaryColor,

                              onPressed: () {
                                 if (_formKey.currentState.validate()) {
                                    print('atualizando dados do login');
                                    model.resetPassword(_emailController.text);
                                 }
                              },
                           )
                        )
                     ],
                  ),
               );
            }
         ),
      );
   }
}
