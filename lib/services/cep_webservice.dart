import 'dart:convert';
import 'package:http/http.dart' as http;

class CepWebService {

   Future<Map> consultarCep(String cep) async {
      http.Response response;
      if (cep == null || cep.isEmpty) {
         return null;
      }

      cep = cep.replaceAll('\\s+', '').replaceAll('-', ''); // removendo espaços em branco e traços
      response = await http.get("https://viacep.com.br/ws/$cep/json/");
      return json.decode(response.body);
   }


}