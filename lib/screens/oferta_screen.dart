import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:ofertasigrejaflutter/messages/messages.dart';
import 'package:ofertasigrejaflutter/models/user_model.dart';
import 'package:ofertasigrejaflutter/payment_asaas/asaas_payment.dart';
import 'package:ofertasigrejaflutter/screens/resumo_boleto_screen.dart';
import 'package:ofertasigrejaflutter/screens/resumo_screen.dart';

class OfertaScreen extends StatefulWidget {

   UserModel model;
   OfertaScreen(this.model);

   @override
   _OfertaScreenState createState() => _OfertaScreenState();
}


class _OfertaScreenState extends State<OfertaScreen> {

   var controller = MoneyMaskedTextController(decimalSeparator: ',', precision: 2, thousandSeparator: '.', leftSymbol: 'R\$ ');
   var _formaPagamento = '';
   final _scaffoldKey = GlobalKey<ScaffoldState>();
   final _formKey = GlobalKey<FormState>();

   @override
   void initState() {
      controller.text = 'R\$ 15,00';
      super.initState();
   }


   @override
   Widget build(BuildContext context) {
      return Scaffold(
         key: _scaffoldKey,
         appBar: AppBar(
            title: Text('Ofertar'),
            centerTitle: true,
         ),

         body: SingleChildScrollView(
            child: Form(
               key: _formKey,
               child: Container(
                  child: Column(
                     children: <Widget>[
                        Container(
                           padding: EdgeInsets.only(top: 50.0),
                           child: Text(
                              'qual o valor ?',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18, fontFamily: 'Roboto Light'),
                           ),
                        ),

                        Container(
                           padding: EdgeInsets.only(left: 30.0, right: 30.0),
                           child: TextFormField(
                              style: TextStyle(fontSize: 25.0, fontFamily: 'Roboto Bold'),
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              controller: controller,
                              validator: (text) {
                                 double vdb = controller.numberValue;
                                 if (vdb <= 5.00 || vdb > 9999.99)
                                    return 'Valor mínimo: R\$ 5,00 e máximo R\$ 9.999,99';
                                 return null;
                              },
                           ),
                        ),


                        Container(
                           padding: EdgeInsets.only(top: 50.0),
                           child: Text(
                              'para quem ?',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18, fontFamily: 'Roboto Light'),
                           ),
                        ),

                        Container(
                           padding: EdgeInsets.only(top: 20.0),
                           child: Text(
                              'Igreja Católica São Gonçalo',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, fontFamily: 'Roboto Bold'),
                           ),
                        ),

                        Container(
                           padding: EdgeInsets.only(top: 50.0),
                           child: Text(
                              'forma de ofertar',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18, fontFamily: 'Roboto Light'),
                           ),
                        ),


                        Row(
                           children: <Widget>[

                              Expanded(
                                 flex: 2,
                                 child: ListTile(
                                    title: Text('Boleto'),
                                    leading: Radio(
                                       value: 'boleto',
                                       groupValue: _formaPagamento,
                                       onChanged: (v) {
                                          setState(() {
                                             _formaPagamento = v;
                                          });
                                       },
                                    ),
                                 ),
                              ),

                              Expanded(
                                 flex: 2,
                                 child: ListTile(
                                    title: Text('Cartão'),
                                    leading: Radio(
                                       value: 'cartao',
                                       groupValue: _formaPagamento,
                                       onChanged: (v) {
                                          setState(() {
                                             _formaPagamento = v;
                                          });
                                       },
                                    ),
                                 ),
                              ),
                           ],
                        ),

                        Container(
                           margin: EdgeInsets.only(top: 40),
                           width: 200,
                           child: RaisedButton(
                              child: Text('Prosseguir',
                                 style: TextStyle(
                                    fontSize: 18.0
                                 )
                              ),
                              textColor: Colors.white,
                              color: Colors.green,
                              onPressed: () {


                                 AsaasPayment payment = AsaasPayment();
//                                 payment.createClient(userModel: widget.model, onFail: (e){
//                                    _scaffoldKey.currentState.showSnackBar(
//                                       SnackBar(content: Text('$e'),
//                                          backgroundColor: Colors.redAccent,
//                                          duration: Duration(seconds: 2)
//                                       )
//                                    );
//                                 });
//                                 payment.listClients(onFail: (e) => {
//                                    Messages.showSnackBarSuccess(e, _scaffoldKey, Colors.red, Duration(seconds: 2))
//                                 });
//                                 payment.createAccountAsaas(userModel: widget.model, onFail: (e) => {
//                                    Messages.showSnackBarSuccess(e, _scaffoldKey, Colors.red, Duration(seconds: 3))
//                                 });




                                 if (_formaPagamento.isEmpty) {
                                    Messages.showAlertDialog('Selecione a forma de ofertar', context);
                                    return;
                                 }

                                 if (_formKey.currentState.validate()) {
                                    String value = controller.text.replaceAll('R\$ ', '').replaceAll('.', '').replaceAll(',', '.');
                                    double valorOferta = double.parse(value);
                                    if (_formaPagamento == 'cartao') {
                                       Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => ResumoScreen(valorOferta))
                                       );
                                    } else {
                                       Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => ResumoBoletoScreen())
                                       );
                                    }
                                 }


                              },
                           ),
                        )

                     ],
                  ),
               ),
            ),
         )
      );
   }
}

