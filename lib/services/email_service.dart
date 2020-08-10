import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailService {

   static Future<String> sendEmailSupport(String content, String subject) async {
      final Email email = Email(
         body: content,
         subject: subject,
         recipients: ['rhuanpablo13@hotmail.com'],
         cc: ['rhuanpablo13@hotmail.com'],
         bcc: ['rhuanpablo13saga@gmail.com'], //remetente
         attachmentPaths: [],
         isHTML: false,
      );

      String platformResponse;
      try {
         await FlutterEmailSender.send(email);
         platformResponse = 'Mensagem enviada com sucesso! Aguarde nosso retorno.';
      } catch (error) {
         platformResponse = error.toString();
      }
      return platformResponse;
   }

}