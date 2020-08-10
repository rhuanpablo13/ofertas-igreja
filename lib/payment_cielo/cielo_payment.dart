import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:ofertasigrejaflutter/models/credit_card.dart';
import 'package:ofertasigrejaflutter/models/user_model.dart';

class CieloPayment {

   final CloudFunctions functions = CloudFunctions.instance;

   Future<void> authorize({CreditCard creditCard, num price, String orderId, UserModel user}) async {

      try {
         final Map<String, dynamic> dataSale = {
            'merchantOrderId': orderId,
            'amount': (price * 100).toInt(),
            'softDescriptor': 'oferta igreja',
            'installments': 1,
            'creditCard': creditCard.toJson(),
            'cpf': user.cpfCnpj,
            'paymentType': 'CreditCard',
         };
// SplittedCreditCard
// CreditCard
         print(dataSale);

         final HttpsCallable callable = functions.getHttpsCallable(
            functionName: 'autorizeCreditCard'
         );
         final response = await callable.call(dataSale);

         print(response.data);

         final data = Map<String, dynamic>.from(response.data);
         if (data['success']) {
            return data['paymentId'];
         } else {
            debugPrint('${data['error']['message']}');
            return Future.error(data['error']['message']);
         }
      } catch (e) {
         debugPrint('$e');
         return Future.error('Falha ao processar transação. Tente novamente.');
      }

   }






/*
   final CieloEcommerce cielo = CieloEcommerce(
      environment: Environment.sandbox,
      merchant: Merchant(
         merchantId: "SEU_MERCHANT_ID",
         merchantKey: "SEU_MERCHANT_KEY",
      ));


   _makePayment() async {

      print("Transação Simples");
      print("Iniciando pagamento....");
      //Objeto de venda
      Sale sale = Sale(
         merchantOrderId: "2020032601", // Numero de identificação do Pedido
         customer: Customer(
            name: "Comprador crédito simples - Rhuan", // Nome do Comprador
         ),
         payment: Payment(
            type: TypePayment.creditCard, // Tipo do Meio de Pagamento
            amount: 9, // Valor do Pedido (ser enviado em centavos)
            installments: 1, // Número de Parcelas
            softDescriptor: "Mensagem", // Descrição que aparecerá no extrato do usuário. Apenas 15 caracteres
            creditCard: CreditCard(
               cardNumber: "4024007153763191", // Número do Cartão do Comprador
               holder: 'Teste accept', // Nome do Comprador impresso no cartão
               expirationDate: '08/2030', // Data de validade impresso no cartão
               securityCode: '123', // Código de segurança impresso no verso do cartão
               brand: 'Visa', // Bandeira do cartão
            ),
         ),
      );

      try {
         var response = await cielo.createSale(sale);

         print('paymentId ${response.payment.paymentId}');

      } on CieloException catch (e) {
         print(e);
         print(e.message);
         print(e.errors[0].message);
         print(e.errors[0].code);
      }
   }*/

}
