import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardTextField extends StatelessWidget {

   final String title;
   final bool bold;
   final String hint;
   final TextInputType inputType;
   final List<TextInputFormatter> inputFormatters;
   final FormFieldValidator<String> validator;
   final int maxLength;
   final TextAlign textAlign;
   final FocusNode focusNode;
   final Function(String) onSubmitted;
   final TextInputAction textInputAction;
   final FormFieldSetter<String> onSaved;
   String initialValue;

   CardTextField({this.initialValue, this.title, this.bold = false, this.hint, this.inputType, this.inputFormatters, this.validator, this.maxLength, this.textAlign = TextAlign.start, this.focusNode, this.onSubmitted, this.onSaved}) :
   textInputAction = onSubmitted == null ? TextInputAction.done : TextInputAction.next;


   @override
   Widget build(BuildContext context) {
    return FormField(
       initialValue: '',
       validator: validator,
       onSaved: onSaved,
       builder: (state) {
         return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                  if (title != null)
                     Row(
                        children: <Widget>[
                           Text(title,
                              style: TextStyle(
                                 fontFamily: 'Roboto Light',
                                 fontSize: 10.0,
                                 color: Colors.white
                              )
                           ),

                           if (state.hasError)
                              const Text(
                                 '   Inválido',
                                 style: TextStyle(
                                    color: Colors.red, fontSize: 9),
                              )
                        ],
                  ),

                  TextFormField(
                     initialValue: initialValue,
                     style: TextStyle(
                        color: title == null && state.hasError ? Colors.red : Colors.white,
                        fontWeight: bold ? FontWeight.bold : FontWeight.w500
                     ),
                     decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: TextStyle(
                           color: title == null && state.hasError ? Colors.red : Colors.white.withAlpha(100)
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 2),
                        counterText: ''
                     ),
                     keyboardType: inputType,
                     inputFormatters: inputFormatters,
                     onChanged: (text) {
                        state.didChange(text);
                     },
                     maxLength: maxLength,
                     textAlign: textAlign,
                     cursorColor: Colors.white,
                     focusNode: focusNode,
                     onFieldSubmitted: onSubmitted,
                     textInputAction: textInputAction,
                  )
               ],
            ),
         );
      },
    );
   }
}
