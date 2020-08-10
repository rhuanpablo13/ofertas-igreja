import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:ofertasigrejaflutter/models/credit_card.dart';
import 'package:ofertasigrejaflutter/models/user_model.dart';
import 'package:ofertasigrejaflutter/payment_cielo/cielo_payment.dart';
import 'package:ofertasigrejaflutter/widgets/credit_card_widget.dart';
import 'package:scoped_model/scoped_model.dart';




class ResumoScreen extends StatelessWidget {

   final CreditCard _creditCard = CreditCard();
   var controllerOferta = MoneyMaskedTextController(decimalSeparator: ',', precision: 2, thousandSeparator: '.', leftSymbol: 'R\$ ');
   var controllerTaxa = MoneyMaskedTextController(decimalSeparator: ',', precision: 2, thousandSeparator: '.', leftSymbol: 'R\$ ');
   var controllerTotal = MoneyMaskedTextController(decimalSeparator: ',', precision: 2, thousandSeparator: '.', leftSymbol: 'R\$ ');

   double _valor = 0; // valor da oferta/doação/dízimo

   double _calcularTaxa() {
      if (_valor <= 20) {
         return 2;
      }
      return _valor * 0.10;
   }

   final _formKey = GlobalKey<FormState>();

   ResumoScreen(this._valor) {
      double taxa = _calcularTaxa();
      controllerOferta.updateValue(_valor);
      controllerTaxa.updateValue(taxa);
      controllerTotal.updateValue((_valor + taxa).roundToDouble());
   }

   @override
   Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
          title: Text('Resumo'),
          centerTitle: true,
       ),
       body: GestureDetector(
          onTap: (){
             FocusScope.of(context).unfocus();
          },
          child: ScopedModelDescendant<UserModel>(
             builder: (context, child, model) {
                if (model.isLoading()) return CircularProgressIndicator();
                return SingleChildScrollView(
                   child: Form(
                      key: _formKey,
                      child: Column(
                         children: <Widget>[
                            CreditCardWidget(_creditCard),
                            DataTable(
                               columns: const <DataColumn>[
                                  DataColumn(label: Text('')),
                                  DataColumn(label: Text('')),
                               ],
                               rows: <DataRow>[
                                  DataRow(
                                     cells: <DataCell>[
                                        DataCell(Text('valor da oferta', style: TextStyle(fontFamily: 'Roboto Bold', fontSize: 16.0, color: Colors.black54))),
                                        DataCell(
                                           Text(controllerOferta.text,
                                              style: TextStyle(
                                                 fontFamily: 'Roboto Light',
                                                 fontSize: 16.0
                                              )
                                           )
                                        ),
                                     ],
                                  ),
                                  DataRow(
                                     cells: <DataCell>[
                                        DataCell(Text('taxa de operação', style: TextStyle(fontFamily: 'Roboto Bold', fontSize: 16.0, color: Colors.black54))),
                                        DataCell(Text(controllerTaxa.text, style: TextStyle(fontFamily: 'Roboto Light', fontSize: 16.0))),
                                     ],
                                  ),
                                  DataRow(
                                     cells: <DataCell>[
                                        DataCell(Text('total', style: TextStyle(fontFamily: 'Roboto Bold', fontSize: 16.0, color: Colors.green))),
                                        DataCell(Text(controllerTotal.text, style: TextStyle(fontFamily: 'Roboto Light', fontSize: 16.0, color: Colors.green))),
                                     ],
                                  ),
                               ],
                            ),

                            Container(
                               margin: EdgeInsets.only(top: 40, bottom: 40),
                               width: 200,
                               //height: 90,
                               child: RaisedButton(
                                  child: Text('Prosseguir',
                                     style: TextStyle(
                                        fontSize: 18.0
                                     )
                                  ),
                                  textColor: Colors.white,
                                  color: Colors.green,
                                  onPressed: () {
                                     CreditCard cc = CreditCard();
                                     if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        CieloPayment cieloPayment = CieloPayment();
                                        cieloPayment.authorize(
                                           creditCard: _creditCard,
                                           price: controllerTotal.numberValue,
                                           orderId: '1',
                                           user: model
                                        );
                                     }
                                  },
                               ),
                            )
                         ],
                      ),
                   )
                );
             },
          ),
       ),
    );
   }
}
