import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:ofertasigrejaflutter/models/cep_model.dart';
import 'package:ofertasigrejaflutter/models/user_model.dart';
import 'package:ofertasigrejaflutter/services/cep_webservice.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cpfcnpj/cpfcnpj.dart';


class SignupScreen extends StatefulWidget {

   bool boAlteracao;
   SignupScreen({this.boAlteracao});

   @override
   _SignupScreenState createState() => _SignupScreenState();
}



class _SignupScreenState extends State<SignupScreen> {

   final _nameController = TextEditingController();
   final _cpfController = TextEditingController();
   final _phoneController = TextEditingController();
   final _postalCodeController = TextEditingController();
   final _addressController = TextEditingController();
   final _complementController = TextEditingController();
   final _provinceController = TextEditingController();
   final _numberController = TextEditingController();
   final _ufController = TextEditingController();
   final _cityController = TextEditingController();
   static String _typeAccount = '';

   final _emailController = TextEditingController();
   final _passController = TextEditingController();

   final _scaffoldKey = GlobalKey<ScaffoldState>();
   final _formKey = GlobalKey<FormState>();
   final _fbKey = GlobalKey<FormBuilderState>();


   String itemSelected;
   List<DropdownMenuItem<String>> _items;
   final String msgCampoVazio = 'Preencha este campo';

   @override
   void initState() {
      buildDropDownMenuItems();
      itemSelected = _items[0].value;
      super.initState();
   }

   ValueChanged _onChanged = (val) => _typeAccount = val;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       key: _scaffoldKey,
       appBar: AppBar(
          title: Text('Minha Conta'),
          centerTitle: true,
          actions: <Widget>[
             ScopedModelDescendant<UserModel>(
                builder: (context, child, model) {
                   return Container(
                      //color: Colors.indigo,
                      width: 100.0,
                      height: 50.0,
                      child: widget.boAlteracao ? FlatButton(
                         child: Text('Atualizar Senha', textAlign: TextAlign.center),
                         textColor: Colors.white,
                         onPressed: () {
                            print('atualizando login');
                            // atualizar o firebase auth
                            // atualizar o email do cadastro de dados
                            model.resetPassword(_emailController.text);
                            onSuccess(msg:'Um e-mail para redefinição de senha foi enviado');
                         },
                      ) : Container(),
                   );
                },
             )
          ],
       ),


       body: SingleChildScrollView(
          child: ScopedModelDescendant<UserModel>(
             builder: (context, child, model) {

                if (model.isLoading()) {
                   return Center(child: CircularProgressIndicator());
                }

                if (model.isLogged() && widget.boAlteracao) {
                   _nameController.text = model.name;
                   _cpfController.text = model.cpfCnpj;
                   itemSelected = model.gender;
                   _phoneController.text = model.mobilePhone;
                   _postalCodeController.text = model.postalCode;
                   _addressController.text = model.address;
                   _complementController.text = model.complement;
                   _provinceController.text = model.province;
                   _numberController.text = model.addressNumber;
                   _ufController.text = model.uf;
                   _emailController.text = model.email;
                   _cityController.text = model.city;
                }

                return Form(
                   key: _formKey,
                   child: SingleChildScrollView(
                      child: Column(
                         children: <Widget>[
                            Icon(Icons.account_circle, size: 100.0,),
                            Row(
                               children: <Widget>[

                                  // Nome
                                  Expanded(
                                     child: Container(
                                        width: 200.0,
                                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                        child: TextFormField(
                                           controller: _nameController,
                                           decoration: InputDecoration(
                                              hintText: 'Nome'
                                           ),
                                           validator: (text) {
                                              if (text.isEmpty) {
                                                 return msgCampoVazio;
                                              }
                                              return null;
                                           },
                                           maxLength: 100,
                                        ),
                                     )
                                  ),
                               ],
                            ),
                            SizedBox(height: 10.0),//
                            Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: <Widget>[

                                  // CPF
                                  Container(
                                     padding: EdgeInsets.only(left: 10.0),
                                     width: 140.0,
                                     child: TextFormField(
                                        controller: _cpfController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [MaskTextInputFormatter(mask: '###.###.###-##')],
                                        decoration: InputDecoration(
                                           hintText: 'CPF'
                                        ),
                                        validator: (text) {
                                           if (text.isEmpty) {
                                              return msgCampoVazio;
                                           }
                                           if (!CPF.isValid(text)) {
                                              return 'CPF inválido';
                                           }
                                           return null;
                                        },
                                     ),
                                  ),

                                  // Sexo
                                  Container(
                                     width: 180.0,
                                     alignment: Alignment.centerLeft,
                                     child: DropdownButton(
                                        items: _items,
                                        value: itemSelected,
                                        onChanged: (item) {
                                           onChangedSelectedBox(item);
                                           model.gender = itemSelected;
                                        },
                                     ),
                                  )
                               ],
                            ),
                            SizedBox(height: 10.0,),


                            // Celular
                            Row(
                               children: <Widget>[
                                  Container(
                                     padding: EdgeInsets.only(left: 10.0),
                                     width: 140.0,
                                     child: TextFormField(
                                        controller: _phoneController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [MaskTextInputFormatter(mask: '(##) #####-####')],
                                        decoration: InputDecoration(
                                           hintText: 'Celular'
                                        ),
                                        validator: (text) {
                                           if (text.isEmpty) {
                                              return msgCampoVazio;
                                           }
                                           return null;
                                        },
                                     ),
                                  )
                               ],
                            ),
                            SizedBox(height: 10.0,),


                            // CEP
                            Row(
                               children: <Widget>[
                                  Container(
                                     padding: EdgeInsets.only(left: 10.0),
                                     margin: EdgeInsets.only(right: 15.0),
                                     width: 140.0,
                                     child: TextFormField(
                                        controller: _postalCodeController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [MaskTextInputFormatter(mask: '#####-###')],
                                        decoration: InputDecoration(
                                           hintText: 'CEP'
                                        ),
                                        validator: (text) {
                                           if (text.isEmpty) {
                                              return msgCampoVazio;
                                           }
                                           return null;
                                        },
                                     ),
                                  ),
                                  Container(
                                     child: FlatButton(
                                        child: Text('Consultar', style: TextStyle(color: Colors.white),),
                                        splashColor: Colors.blueAccent,
                                        color: Colors.blue,
                                        onPressed: () {
                                           _consultarCep(_postalCodeController.text);
                                        },
                                     ),
                                  )
                               ],
                            ),
                            SizedBox(height: 10.0,),

                            // endereço/logradouro
                            Row(
                               children: <Widget>[
                                  Expanded(
                                     child: Container(
                                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                        width: 200.0,
                                        child: TextFormField(
                                           controller: _addressController,
                                           decoration: InputDecoration(
                                              hintText: 'Endereço'
                                           ),
                                           validator: (text) {
                                              if (text.isEmpty) {
                                                 return msgCampoVazio;
                                              }
                                              return null;
                                           },
                                        ),
                                     ),
                                  )
                               ],
                            ),
                            SizedBox(height: 10.0,),


                            Row(
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: <Widget>[
                                  // Bairro
                                  Container(
                                     //padding: EdgeInsets.only(left: 10.0),
                                     width: 200.0,
                                     child: TextFormField(
                                        controller: _provinceController,
                                        decoration: InputDecoration(
                                           hintText: 'Bairro'
                                        ),
                                        validator: (text) {
                                           if (text.isEmpty) {
                                              return msgCampoVazio;
                                           }
                                           return null;
                                        },
                                     ),
                                  ),

                                  // Número
                                  Container(
                                     padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                     width: 80.0,
                                     child: TextFormField(
                                        controller: _numberController,
                                        decoration: InputDecoration(
                                           hintText: 'Número'
                                        ),
                                        validator: (text) {
                                           if (text.isEmpty) {
                                              return msgCampoVazio;
                                           }
                                           return null;
                                        },
                                     ),
                                  ),

                                  // UF
                                  Container(
                                     margin: EdgeInsets.only(left: 10.0),
                                     width: 50.0,
                                     child: TextFormField(
                                        controller: _ufController,
                                        decoration: InputDecoration(
                                           hintText: 'UF'
                                        ),
                                        validator: (text) {
                                           if (text.isEmpty) {
                                              return msgCampoVazio;
                                           }
                                           return null;
                                        },
                                     ),
                                  )
                               ],
                            ),
                            SizedBox(height: 20.0,),
                            Divider(),
                            SizedBox(height: 20.0,),

                            !widget.boAlteracao ?
                            Text('Informações de login',
                               style: TextStyle(
                                  fontSize: 18.0
                               ),
                            ) : Container(),


                            !widget.boAlteracao ? _buildEmail() : Container(),
                            !widget.boAlteracao ? _buildSenha() : Container(),
                            !widget.boAlteracao ? SizedBox(height: 40.0,) : Container(),

                            !widget.boAlteracao ? Text('Você é?',
                               style: TextStyle(
                                  fontSize: 18.0
                               )
                            ) : Container(),

                            !widget.boAlteracao ? _buildTipoConta() : Container(),

                            !widget.boAlteracao ? SizedBox(height: 20.0,) : Container(),

                            !widget.boAlteracao ? _buildButtonCadastro(model)  : _buildButtonUpdate(model)

                         ],
                      ),
                   ),
                );
             },
          ),
       )
    );

  }


   Widget _buildTipoConta() {
      return
         Padding(
            padding: EdgeInsets.only(right: 50, left: 50),
            child: FormBuilder(
               key: _fbKey,
               autovalidate: true,
               child:FormBuilderRadio(
                  onChanged: _onChanged,
                  attribute: "tipo_conta",
                  leadingInput: true,
                  validators: [FormBuilderValidators.required()],
                  options: ["Igreja", "Membro"]
                     .map((lang) => FormBuilderFieldOption(
                     value: lang,
                     child: Text('$lang'),
                  )).toList(growable: false),
               )
            )
         );
   }

   Widget _buildEmail() {
      // E-mail
      return Container(
         width: 300.0,
         child: TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
               hintText: 'E-mail'
            ),
            validator: (text) {
               if (text.isEmpty) {
                  return msgCampoVazio;
               }
               if (!EmailValidator.validate(text)) {
                  return 'Email não válido';
               }
               return null;
            },
         ),
      );
   }

   Widget _buildSenha() {
      // Senha
      return Container(
         width: 300.0,
         child: TextFormField(
            controller: _passController,
            decoration: InputDecoration(
               hintText: 'Senha'
            ),
            obscureText: true,
            validator: (text) {
               if (text.isEmpty) {
                  return msgCampoVazio;
               }
               return null;
            },
         ),
      );
   }


   Widget _buildButtonUpdate(UserModel model) {
      return Container(
         width: 300.0,
         child: RaisedButton(
            child: Text('Atualizar Cadastro',
               style: TextStyle(
                  fontSize: 18.0
               )
            ),
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,

            onPressed: () {
               if (_formKey.currentState.validate()) {
                  Map<String, dynamic> userData = {
                     'name':_nameController.text,
                     'cpfCnpj':_cpfController.text,
                     'gender':itemSelected,
                     'mobilePhone':_phoneController.text,
                     'postalCode':_postalCodeController.text,
                     'address':_addressController.text,
                     'complement':_complementController.text,
                     'addressNumber':_numberController.text,
                     'uf':_ufController.text,
                     'email':_emailController.text,
                  };

                  model.fromJson(userData);
                  model.updateUserData(
                     onSuccess: (s) => onSuccess(msg:s),
                     onFail: (e) => onFail(msg:e)
                  );

               }
            },
         )
      );
   }


   Widget _buildButtonCadastro(UserModel model) {
      return Container(
         margin: EdgeInsets.only(bottom: 20),
         width: 300.0,
         child: RaisedButton(
            child: Text('Cadastrar',
               style: TextStyle(
                  fontSize: 18.0
               )
            ),
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,

            onPressed: () {

               // recuperar os dados, criar a conta e salvar os dados do usuário
               if (_formKey.currentState.validate() && _fbKey.currentState.saveAndValidate()) {
                  Map<String, dynamic> userData = {
                     'name':_nameController.text,
                     'cpfCnpj':_cpfController.text,
                     'gender':itemSelected,
                     'mobilePhone':_phoneController.text,
                     'postalCode':_postalCodeController.text,
                     'address':_addressController.text,
                     'complement':_complementController.text,
                     'addressNumber':_numberController.text,
                     'uf':_ufController.text,
                     'email':_emailController.text,
                     'typeAccount':_typeAccount
                  };

                  print(userData);

                  model.fromJson(userData);
                  model.signUp(
                     pass: _passController.text,
                     onSuccess: (m) {
                        onSuccess(msg: m);
                        backScreen();
                     },
                     onFail: (e) {
                        onFail(msg: e);
                        //backScreen();
                        if (model.isLogged()) model.signOut();
                     }
                  );
               }
            },
         )
      );
   }



   void buildDropDownMenuItems() {
      _items = new List();

      _items.add(new DropdownMenuItem(
         value: 'masculino',
         child: Text('Masculino'),
      ));

      _items.add(new DropdownMenuItem(
         value: 'feminino',
         child: Text('Feminino'),
      ));
   }

   onChangedSelectedBox(String selectedItem) {
      setState(() {
         itemSelected = selectedItem;
      });
   }

   void _consultarCep(String cep) {
      CepModel m;
      CepWebService ws = CepWebService();
      Future<Map> data = ws.consultarCep(cep);
      data.then((value) async {
         if (value.containsKey('erro')) {
            onFail(msg:'Cep não encontrado');
            _addressController.clear();
            _complementController.clear();
            _ufController.clear();
            _numberController.clear();
            _cityController.clear();
            _provinceController.clear();
         } else {
            m = CepModel.fromJson(value);
            _addressController.text = m.logradouro;
            _complementController.text = m.complemento;
            _ufController.text = m.uf;
            _cityController.text = m.localidade;
            _provinceController.text = m.bairro;
         }
      });
   }

   void backScreen() {
      Future.delayed(Duration(seconds: 2)).then((value) => Navigator.of(context).pop());
   }

   void onFail({String msg}) {
      if (msg == null) msg = 'erro';
      _scaffoldKey.currentState.showSnackBar(
         SnackBar(content: Text(msg),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2)
         )
      );
   }

   void onSuccess({String msg}) {
      if (msg == null) msg = 'sucesso';
      _scaffoldKey.currentState.showSnackBar(
         SnackBar(content: Text(msg),
            backgroundColor: Colors.lightGreen,
            duration: Duration(seconds: 2)
         )
      );
   }

//                _nameController.text = 'Rhuan Pablo';
//                _cpfController.text = '025.335.721-79';
//                itemSelected = 'masculino';
//                _phoneController.text = '(61) 98251-2714';
//                _postalCodeController.text = '72275-110';
//                _addressController.text = 'QNR 01 Conjunto J';
//                _complementController.text = 'Ceilandia Norte';
//                _numberController.text = '22a';
//                _ufController.text = 'DF';
//                _cityController.text = 'Brasília';
//                _emailController.text = 'rhuanpablo13@hotmail.com';
//                _passController.text = '123456';

}

