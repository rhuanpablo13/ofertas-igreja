import 'package:brasil_fields/brasil_fields.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:ofertasigrejaflutter/models/credit_card.dart';
import 'package:ofertasigrejaflutter/widgets/components/card_text_field.dart';

class CardFront extends StatelessWidget {

   final dateFormatter = MaskTextInputFormatter(
      mask: '!#/####', filter: {'#':RegExp('[0-9]'), '!':RegExp('[0-1]')}
   );

   final FocusNode numberFocus;
   final FocusNode dateFocus;
   final FocusNode nameFocus;
   final VoidCallback finished;
   final CreditCard creditCard;

   CardFront({@required this.numberFocus, @required this.dateFocus, @required this.nameFocus, @required this.finished, @required this.creditCard});



  @override
  Widget build(BuildContext context) {
    return Card(
       clipBehavior: Clip.antiAlias,
       color: Colors.deepPurple,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
       elevation: 16,
       child: Container(
          padding: const EdgeInsets.all(16),
          height: 200,
          child: Row(
             children: <Widget>[
                Expanded(
                   child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                         CardTextField(title: 'Número', hint: '0000 0000 0000 0000', inputType: TextInputType.number, bold: true, inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, CartaoBancarioInputFormatter()],
                            validator: (number) {
                              if(number.length != 19 || detectCCType(number) == CreditCardType.unknown) return 'Inválido';
                              return null;
                            },
                            onSubmitted: (_){
                              dateFocus.requestFocus();
                            },
                            focusNode: numberFocus,
                            onSaved: creditCard.setNumber,
                         ),

                         CardTextField(title: 'Validate', hint: '11/2020', inputType: TextInputType.number, bold: true, inputFormatters: [dateFormatter],
                            validator: (date) {
                              if(date.length != 7) return 'Inválido'; return null;
                            },
                            onSubmitted: (_){
                              nameFocus.requestFocus();
                            },
                            focusNode: dateFocus,
                            onSaved: creditCard.setExpirationDate,
                         ),

                         CardTextField(title: 'Titular', hint: 'João da Silva', bold: true,
                           validator: (name) {
                              if (name.isEmpty) return 'Inválido'; return null;
                           },
                           onSubmitted: (_){
                              finished();
                           },
                           focusNode: nameFocus,
                           onSaved: creditCard.setHolder,
                         ),
                      ],
                   ),
                )
             ],
          ),
       ),
    );
  }
}
