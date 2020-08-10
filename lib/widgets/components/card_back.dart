import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ofertasigrejaflutter/models/credit_card.dart';
import 'package:ofertasigrejaflutter/widgets/components/card_text_field.dart';

class CardBack extends StatelessWidget {

   final FocusNode cvvFocus;
   final CreditCard creditCard;

   CardBack({@required this.cvvFocus, @required this.creditCard});

   @override
   Widget build(BuildContext context) {
     return Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.deepPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 16,
        child: Container(
           height: 200,
           child: Column(
              children: <Widget>[
                 Container(
                    color: Colors.black,
                    height: 40,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                 ),
                 Row(
                    children: <Widget>[
                       Expanded(
                          flex: 70,
                          child: Container(
                             padding: EdgeInsets.only(right: 10),
                             color: Colors.grey[500],
                             height: 30,
                             child: CardTextField(
                                hint: '123',
                                inputFormatters: [
                                   WhitelistingTextInputFormatter.digitsOnly
                                ],
                                maxLength: 3,
                                textAlign: TextAlign.end,
                                inputType: TextInputType.number,
                                validator: (cvv) {
                                   if (cvv.isEmpty || cvv.length != 3) return 'Inválido'; return null;
                                },
                                focusNode: cvvFocus,
                                onSaved: creditCard.setCvv,
                             ),
                          ),
                       ),
                       Expanded(
                          flex: 30,
                          child: Container(),
                       )
                    ],
                 )
              ],
           ),
        ),
     );
   }
}
