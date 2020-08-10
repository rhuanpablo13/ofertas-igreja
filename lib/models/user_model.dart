import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ofertasigrejaflutter/services/email_service.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class UserModel extends Model {


   UserModel({
      @required this.name,
      this.email,
      this.mobilePhone,
      @required this.cpfCnpj,
      this.postalCode,
      this.address,
      this.addressNumber,
      this.complement,
      this.province,
      this.uf,
      this.city,
      this.gender,
      @required this.typeAccount
   });

   String name;
   String email;
   String mobilePhone;
   String cpfCnpj;
   String postalCode;
   String address;
   String addressNumber;
   String complement;
   String province;
   String gender;
   String uf;
   String city;
   String typeAccount;



   void fromJson(Map<String, dynamic> json) {
      name = json["name"];
      email = json["email"];
      mobilePhone = json["mobilePhone"];
      cpfCnpj = json["cpfCnpj"];
      postalCode = json["postalCode"];
      address = json["address"];
      addressNumber = json["addressNumber"];
      complement = json["complement"];
      province = json["province"];
      uf = json["uf"];
      city = json["city"];
      gender = json["gender"];
      typeAccount = json["typeAccount"];
   }



   Map<String, dynamic> toJson() => {
      "name": name,
      "email": email,
      "mobilePhone": mobilePhone,
      "cpfCnpj": cpfCnpj,
      "postalCode": postalCode,
      "address": address,
      "addressNumber": addressNumber,
      "complement": complement,
      "province": province,
      "uf": uf,
      "city": city,
      "gender": gender,
      'typeAccount': typeAccount
   };




   FirebaseAuth _auth = FirebaseAuth.instance;
   FirebaseUser firebaseUser;
   bool _isLoading = false;

   static UserModel of(BuildContext context) => ScopedModel.of<UserModel>(context);

   @override
   void addListener(listener) {
      super.addListener(listener);
      _loadCurrentUser();
   }



   void signUp({@required pass, @required Function onSuccess, @required Function onFail}) {

      _isLoading = true;
      notifyListeners();

      _auth = FirebaseAuth.instance;
      _auth.createUserWithEmailAndPassword(
         email: this.email,
         password: pass
      ).then((value) async {

         firebaseUser = value.user;
         if (firebaseUser != null) {

            try {
               await _saveUserData();
            } catch (e) {

               // re-autenticar o usuário para poder deletar seu email cadastrado e não gerar lixo
               AuthCredential credential;
               credential = EmailAuthProvider.getCredential(
                  email: this.email,
                  password: pass
               );

               AuthResult authResult = (await firebaseUser.reauthenticateWithCredential( credential).catchError((error) {
                  print("FirebaseAuthHelper::reauthCurrentUser $error");
               }));

               await authResult.user.delete();

               _isLoading = false;
               onFail(tratarMensagemErro(e.message));
               notifyListeners();
               return;
            }

            print('enviando email de verificação...');
            await firebaseUser.sendEmailVerification();

            onSuccess('Usuário ' + this.email + ' cadastrado com sucesso');
            _isLoading = false;
            notifyListeners();
         }

      }).catchError((error) {
         onFail(tratarMensagemErro(error.code));
         _isLoading = false;
         notifyListeners();
      });
   }



   Future<Null> _saveUserData() async {
      await Firestore.instance.collection('users').document(firebaseUser.uid).setData(this.toJson());
   }



   Future<Null> updateUserData({@required Function onSuccess, @required Function onFail}) async {
      await Firestore.instance.collection('users').document(firebaseUser.uid).setData(this.toJson()).then((value) {
         onSuccess('Usuário atualizado com sucesso');
      }).catchError((_) {
         onFail('Falha ao atualizar dados do usuário');
      });
   }


   @override
   String toString() {
      return 'UserModel{name: $name, email: $email, mobilePhone: $mobilePhone, cpfCnpj: $cpfCnpj, postalCode: $postalCode, address: $address, addressNumber: $addressNumber, complement: $complement, gender: $gender}';
   }


   void signIn({@required String email, @required String pass, @required Function onSuccess, @required Function onFail}) {

      _auth.signInWithEmailAndPassword(email: email, password: pass).then((value) async {

         firebaseUser = value.user;
         if (firebaseUser == null) {
            firebaseUser = await _auth.currentUser();
         }

         if (firebaseUser != null) {
            if (this.name == null) {
               DocumentSnapshot docUser = await Firestore.instance.collection('users').document(firebaseUser.uid).get();
               fromJson(docUser.data);
            }
            print(this.toString());
            onSuccess();
         }

         _isLoading = false;
         notifyListeners();

      }).catchError((onError) {
         String errorMsg = tratarMensagemErro(onError.code);
         onFail(errorMsg);
         _isLoading = false;
         notifyListeners();
      });

   }

   void signOut() {
      _auth.signOut().then((value) {
         firebaseUser = null;
      });
      notifyListeners();
   }

   void recoverPass(String email) {
      _auth.sendPasswordResetEmail(email: email);
   }

   void resetPassword(String email) {
      _auth.sendPasswordResetEmail(email: email);
   }

   bool isLoading() {
      return _isLoading;
   }

   bool isLogged() {
      return firebaseUser != null && this != null;
      //if (this.userData != null) print('n nulo'); else print('é nulo');
      //return this.userData != null || this.userData.isNotEmpty;
   }

   Future<bool> isEmailConfirmed() async {
      if (firebaseUser == null) {
         firebaseUser = await _auth.currentUser();
      }
      if (firebaseUser == null) {
         print('firebaseUser é nulo');
      }
      return firebaseUser.isEmailVerified;
   }

   Future<Null> _loadCurrentUser() async {
      if (firebaseUser == null) {
         firebaseUser = await _auth.currentUser();
      }

      if (firebaseUser != null && firebaseUser.isEmailVerified) {
         if (this.name == null) {
            DocumentSnapshot docUser = await Firestore.instance.collection('users').document(firebaseUser.uid).get();
            fromJson(docUser.data);
         }
      }
      notifyListeners();
   }

   String tratarMensagemErro(String code) {
      //ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account

      if (code == 'ERROR_EMAIL_ALREADY_IN_USE') {
         return 'Este e-mail já está cadastrado';
      }
      if (code.contains('PERMISSION_DENIED')) {
         return 'Erro de permissão! Contate o suporte';
      }
      if (code == 'ERROR_USER_NOT_FOUND') {
         return 'E-mail e senha não cadastrados';
      }
      return 'Erro ao criar usuário';
   }

}