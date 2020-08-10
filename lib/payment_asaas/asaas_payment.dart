import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ofertasigrejaflutter/models/user_model.dart';

class AsaasPayment {

   //String API_KEY = 'bb9b038e3f6ebde9654f50233c075c33ef1d159b6e966a9170be1dd95e0a7324';
   //String baseApi = 'https://www.asaas.com/api/v3/';

   String API_KEY = '83760a8c3df41b0ec70b9698f938e4f71107e833854062397568a50be4bcc3a8'; // sandbox
   String baseApi = 'https://sandbox.asaas.com/api/v3/'; // sandbox

//   Sua API Key é: bb9b038e3f6ebde9654f50233c075c33ef1d159b6e966a9170be1dd95e0a7324
//   Sua API Key sandbox é: 83760a8c3df41b0ec70b9698f938e4f71107e833854062397568a50be4bcc3a8

   Future<void> createClient({@required UserModel userModel, @required Function onFail}) async {
      print('criando cliente: ' + userModel.toString());
      Map<String, dynamic> data = {
         "name": userModel.name,
         "email": userModel.email,
         "mobilePhone": userModel.mobilePhone,
         "cpfCnpj": userModel.cpfCnpj,
         "postalCode": userModel.postalCode,
         "address": userModel.address,
         "addressNumber": userModel.addressNumber,
         "complement": userModel.complement,
      };

      final Dio dio = Dio();
      dio.options.headers['access_token'] = API_KEY;

      try {
         Response response = await dio.post(baseApi + 'customers', data: data);
         print(response.data);
      } catch (e) {
         onFail(_handleError(e));
      }
   }


   Future<void> listClients({@required Function onFail}) async {
      print('listando clientes: ');


      final Dio dio = Dio();
      dio.options.headers['access_token'] = API_KEY;

      try {
         Response response = await dio.get(baseApi + 'customers');
         print(response.data);
      } catch (e) {
         onFail(_handleError(e));
      }
   }



   Future<void> createAccountAsaas({@required UserModel userModel, @required Function onFail}) async {
      print('criando conta asaas: ' + userModel.toString());
      Map<String, dynamic> data = {
         "name": "Ronaldo Ribeiro",
         "email": "rhuanpablo13saga@gmail.com",
         "mobilePhone": "61999999999",
         "cpfCnpj": userModel.cpfCnpj,
         "postalCode": userModel.postalCode,
         "address": userModel.address,
         "addressNumber": userModel.addressNumber,
         "complement": userModel.complement,
         "province": userModel.province,
      };

      final Dio dio = Dio();
      dio.options.headers['access_token'] = API_KEY;

      try {
         Response response = await dio.post(baseApi + 'accounts', data: data);
         print(response.data);
      } catch (e) {
         onFail(_handleError(e));
      }

      //walletId: f1952857-31a1-41a4-8870-265f39b17423, apiKey: 630b1ba3fc2eac7a91d134b90ef5571547832849d7614452558f5475fcb32998
   }


   String _handleError(DioError dioError) {
      String errorDescription = "";
      switch (dioError.type) {
         case DioErrorType.CANCEL:
            errorDescription = "Requisição para a API server foi cancelada";
            break;
         case DioErrorType.CONNECT_TIMEOUT:
            errorDescription = "Tempo esgotado para conectar com a API server";
            break;
         case DioErrorType.DEFAULT:
            errorDescription =
            "Falha na conexão com a API server devido à conexão com a Internet";
            break;
         case DioErrorType.RECEIVE_TIMEOUT:
            errorDescription = "Tempo limite de recebimento de dados com a API server";
            break;
         case DioErrorType.RESPONSE:

            switch (dioError.response.statusCode) {
               case 400:
                  errorDescription = "400 - Erro ao enviar dados = ${dioError.response.data['errors'][0]['description']}";
                  break;
               case 401:
                  errorDescription = "401 - Não foi enviada API Key ou ela é inválida.";
                  break;
               case 404:
                  errorDescription = "404 - O endpoint ou o objeto solicitado não existe.";
                  break;
               case 500:
                  errorDescription = "500 - Algo deu errado no servidor do Asaas.";
                  break;
            }
            break;
         case DioErrorType.SEND_TIMEOUT:
            errorDescription = "Tempo limite para enviar dados para a API server";
            break;
         default:
            errorDescription = "Erro inesperado ocorreu";
      }
      return errorDescription;
   }




   Future<void> teste() async {

      print('chamou o método');

      final Map<String, dynamic> dados = {
         'value': 1000.00,
         'bankAccount': {
            'bank': {
               'code': '033'
            },
            'accountName': 'Conta do Santander',
            'ownerName': 'Marcelo Almeida',
            'ownerBirthDate': '1995-04-12',
            'cpfCnpj': '52233424611',
            'agency': '1263',
            'account': '9999991',
            'accountDigit': '1',
            'bankAccountType': 'CONTA_CORRENTE',
         }
      };

      String ds = this.coordinateToJson(dados);
      print(baseApi + ds);
      final Dio dio = Dio();
      dio.options.headers['access_token'] = API_KEY;

      /*
      try {
         Response response = await dio.post(baseApi, data: dados);
         print(response.data);
      } catch (e) {
         print(e.message);
         print(e.response);
      } */


      try {
         Response response = await dio.get('https://sandbox.asaas.com/api/v3/customers');
         print(response.data);
      } catch (e) {
         print(e.response);
      }
   }


   void criarUsuario() async {
      final Map<String, dynamic> data = {
         "name": "Rhuan Pablo",
         "email": "rhuanpablo13@hotmail.com",
         "phone": "4738010919",
         "mobilePhone": "4799376637",
         "cpfCnpj": "02533572179",
         "postalCode": "72275-110",
         "addressNumber": "22a",
         "complement": "22a",
         "province": "Centro",
         "externalReference": "12987382",
         "notificationDisabled": false,
         "municipalInscription": "46683695908",
         "stateInscription": "646681195275",
         "observations": "ótimo pagador, nenhum problema até o momento"
      };

      final Dio dio = Dio();
      dio.options.headers['access_token'] = API_KEY;

      try {
         Response response = await dio.post('https://sandbox.asaas.com/api/v3/customers', data: data);
         print(response.data);
      } catch (e) {
         print(e.message);
         print(e.response);
      }
   }


   void consultarUsuarios() async {
      print('consultando usuarios');
      final Dio dio = Dio();
      dio.options.headers['access_token'] = API_KEY;
      try {
         Response response = await dio.get('https://sandbox.asaas.com/api/v3/customers');
         print(response.data);
      } catch (e) {
         print(e.message);
         print(e.response);
      }
   }


   void consultarSaldo() async {
      print('consultando saldo');
      final Dio dio = Dio();
      dio.options.headers['access_token'] = API_KEY;
      try {
         Response response = await dio.get('https://www.asaas.com/api/v3/finance/getCurrentBalance');
         print(response.data);
      } catch (e) {
         print(e.message);
         print(e.response);
      }

   }


   void transferir() async {
      print('transferindo');
      final Map<String, dynamic> data = {
         "value": 10.00,
         "bankAccount": {
            "bank": {
               "code": "260"
            },
            "accountName": "Conta do Nubank",
            "ownerName": "Rhuan Pablo",
            "ownerBirthDate": "1995-04-11",
            "cpfCnpj": "02533572179",
            "agency": "0001",
            "account": "32420803",
            "accountDigit": "5",
            "bankAccountType": "CONTA_CORRENTE",
         }
      };

      final Dio dio = Dio();
      dio.options.headers['access_token'] = API_KEY;

      try {
         Response response = await dio.post('https://www.asaas.com/api/v3/transfers', data: data);
         print(response.data);
      } catch (e) {
         print(e.message);
         print(e.response);
      }
   }


   void listarContas() async {
      print('listando contas');
      final Dio dio = Dio();
      dio.options.headers['access_token'] = API_KEY;

      try {
         Response response = await dio.get('https://www.asaas.com/api/v3/accounts');
         print(response.data);
      } catch (e) {
         print(e.message);
         print(e.response);
      }
   }



   // usuário Rhuan Pablo - cus_000002861116



   dynamic coordinateFromJson(String str) => json.decode(str);

   String coordinateToJson(dynamic data) => json.encode(data);

}