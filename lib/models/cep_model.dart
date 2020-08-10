
// classe que vai representar um objeto de retorno da cep_webservice
class CepModel {

   String cep;
   String logradouro;
   String complemento;
   String bairro;
   String localidade;
   String uf;
   String unidade;
   String ibge;
   String gia;

   CepModel({this.cep, this.logradouro, this.complemento, this.bairro, this.localidade, this.uf, this.unidade, this.ibge, this.gia});


   factory CepModel.fromJson(Map<dynamic, dynamic> json) {
      CepModel model = CepModel();

      json['cep'] != null ? model.cep = json['cep'] : model.cep = '';
      json['logradouro'] != null ? model.logradouro = json['logradouro'] : model.logradouro = '';
      json['complemento'] != null ? model.complemento = json['complemento'] : model.complemento = '';
      json['bairro'] != null ? model.bairro = json['bairro'] : model.bairro = '';
      json['localidade'] != null ? model.localidade = json['localidade'] : model.localidade = '';
      json['uf'] != null ? model.uf = json['uf'] : model.uf = '';
      json['unidade'] != null ? model.unidade = json['unidade'] : model.unidade = '';
      json['ibge'] != null ? model.ibge = json['ibge'] : model.ibge = '';
      json['gia'] != null ? model.gia = json['gia'] : model.gia = '';

      return model;
   }

   @override
  String toString() {

    return "cep: $cep, logradouro: $logradouro, complemento: $complemento, "
       "bairro: $bairro, localidade: $localidade, uf: $uf, unidade: $unidade, ibge: $ibge, gia: $gia";
  }
}