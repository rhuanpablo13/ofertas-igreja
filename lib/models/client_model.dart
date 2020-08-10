// To parse this JSON data, do
//
//     final clientModel = clientModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class ClientModel {
   ClientModel({
      @required this.name,
      @required this.email,
      @required this.phone,
      @required this.mobilePhone,
      @required this.cpfCnpj,
      @required this.postalCode,
      @required this.address,
      @required this.addressNumber,
      @required this.complement,
      @required this.province,
      @required this.externalReference,
      @required this.notificationDisabled,
      @required this.additionalEmails,
      @required this.municipalInscription,
      @required this.stateInscription,
      @required this.observations,
   });

   final String name;
   final String email;
   final String phone;
   final String mobilePhone;
   final String cpfCnpj;
   final String postalCode;
   final String address;
   final String addressNumber;
   final String complement;
   final String province;
   final String externalReference;
   final bool notificationDisabled;
   final String additionalEmails;
   final String municipalInscription;
   final String stateInscription;
   final String observations;

   factory ClientModel.fromRawJson(String str) => ClientModel.fromJson(json.decode(str));

   String toRawJson() => json.encode(toJson());

   factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      mobilePhone: json["mobilePhone"],
      cpfCnpj: json["cpfCnpj"],
      postalCode: json["postalCode"],
      address: json["address"],
      addressNumber: json["addressNumber"],
      complement: json["complement"],
      province: json["province"],
      externalReference: json["externalReference"],
      notificationDisabled: json["notificationDisabled"],
      additionalEmails: json["additionalEmails"],
      municipalInscription: json["municipalInscription"],
      stateInscription: json["stateInscription"],
      observations: json["observations"],
   );

   Map<String, dynamic> toJson() => {
      "name": name,
      "email": email,
      "phone": phone,
      "mobilePhone": mobilePhone,
      "cpfCnpj": cpfCnpj,
      "postalCode": postalCode,
      "address": address,
      "addressNumber": addressNumber,
      "complement": complement,
      "province": province,
      "externalReference": externalReference,
      "notificationDisabled": notificationDisabled,
      "additionalEmails": additionalEmails,
      "municipalInscription": municipalInscription,
      "stateInscription": stateInscription,
      "observations": observations,
   };
}
