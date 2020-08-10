
import 'package:credit_card_type_detector/credit_card_type_detector.dart';

class CreditCard {

   String number = '4300000000000001';
   String holder = 'joao da silva';
   String expirationDate = '11/2020';
   String securityCode = '123';
   String brand = 'VISA';

   void setHolder(String name) => holder = name;
   void setExpirationDate(String date) => expirationDate = date;
   void setCvv(String cvv) => securityCode = cvv;
   void setNumber(String number) {
      this.number = number;
      brand = detectCCType(number.replaceAll(' ', '')).toString().toUpperCase().split('.').last;
   }

   Map<String, dynamic> toJson() {
      return {
         'cardNumber': number.replaceAll(' ', ''),
         'holder': holder,
         'expirationDate': expirationDate,
         'securityCode': securityCode,
         'brand': brand
      };
   }

}