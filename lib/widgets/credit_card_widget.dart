import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_action.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:ofertasigrejaflutter/models/credit_card.dart';
import 'package:ofertasigrejaflutter/widgets/components/card_back.dart';

import 'components/card_front.dart';

class CreditCardWidget extends StatefulWidget {

   final CreditCard creditCard;
   CreditCardWidget(this.creditCard);

   @override
   _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget> {

   final _cardKey = GlobalKey<FlipCardState>();
   final FocusNode numberFocus = FocusNode();
   final FocusNode dateFocus = FocusNode();
   final FocusNode nameFocus = FocusNode();
   final FocusNode cvvFocus = FocusNode();


   KeyboardActionsConfig _buildConfig(BuildContext context) {
      return KeyboardActionsConfig(
         keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
         keyboardBarColor: Colors.grey[200],
         actions: [
            KeyboardAction(focusNode: numberFocus, displayDoneButton: false),
            KeyboardAction(focusNode: dateFocus, displayDoneButton: false),
            KeyboardAction(
               focusNode: nameFocus,
               toolbarButtons: [
                  (_){
                     return GestureDetector(
                        onTap: (){
                           _cardKey.currentState.toggleCard();
                           cvvFocus.requestFocus();
                        },
                        child: Padding(
                           padding: EdgeInsets.only(right: 8),
                           child: Text('continuar'),
                        )
                     );
                  }
               ]
            ),
         ]
      );
   }

   @override
   Widget build(BuildContext context) {
    return KeyboardActions(
       config: _buildConfig(context),
       autoScroll: false,
       child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.end,
             children: <Widget>[
                FlipCard(
                   key: _cardKey,
                   direction: FlipDirection.HORIZONTAL,
                   speed: 700,
                   flipOnTouch: false,
                   front: CardFront(
                      creditCard: widget.creditCard,
                      numberFocus: numberFocus,
                      dateFocus: dateFocus,
                      nameFocus: nameFocus,
                      finished: (){
                         _cardKey.currentState.toggleCard();
                         cvvFocus.requestFocus();
                      },
                   ),
                   back: CardBack(
                      creditCard: widget.creditCard,
                      cvvFocus: cvvFocus
                   ),
                ),

                FlatButton(
                   textColor: Colors.black87,
                   padding: EdgeInsets.zero,
                   child: Text('Virar cartão'),
                   onPressed: () {
                      _cardKey.currentState.toggleCard();
                   },
                )

             ],
          ),
       ),
    );
   }
}
