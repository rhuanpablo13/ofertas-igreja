import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { CieloConstructor, Cielo, TransactionCreditCardRequestModel, EnumBrands} from 'cielo';
//CaptureRequestModel, CancelTransactionRequestModel,


admin.initializeApp(functions.config().firebase);

 // Start writing Firebase Functions
 // https://firebase.google.com/docs/functions/typescript

console.log('iniciando autorização');


const merchantId = functions.config().cielo.merchantid;
const merchantKey = functions.config().cielo.merchantkey;

const cieloParams: CieloConstructor = {
      merchantId: merchantId,
      merchantKey: merchantKey,
      sandbox: true,
      debug: true,
}

const cielo = new Cielo(cieloParams);
console.log('iniciando construtor');

export const autorizeCreditCard = functions.https.onCall(async  (data, context) => {
      console.log(data);
      console.log('iniciando chamada para autorização');
      if (data === null) {
            return {
                  'success':false,
                  'error': {
                        'code': -1,
                        'message': 'Dados não informados'
                  }
            }
      }

      // usuário logado
      if (!context.auth) {
            return {
                  'success':false,
                  'error': {
                        'code': -1,
                        'message': 'Nenhum usuário informado'
                  }
            }
      }

      const userId = context.auth.uid;
      const snapshot = await admin.firestore().collection('users').doc(userId).get();
      const userData = snapshot.data() || {};

      

      let brand: EnumBrands;
      switch (data.creditCard.brand) {
            case 'VISA':
                  brand = EnumBrands.VISA;
                  break;
            case 'MASTERCARD':
                  brand = EnumBrands.MASTER;
                  break;
            case 'AMEX':
                  brand = EnumBrands.AMEX;
                  break;
            case 'ELO':
                  brand = EnumBrands.ELO;
                  break;
            case 'JCB':
                  brand = EnumBrands.JCB;
                  break;
            case 'DINERSCLUB':
                  brand = EnumBrands.DINERS;
                  break;
            case 'DISCOVER':
                  brand = EnumBrands.DISCOVERY;
                  break;
            case 'HIPERCARD':
                  brand = EnumBrands.HIPERCARD;
                  break;
            default:
                  return {
                        'success':false,
                        'error': {
                              'code': -1,
                              'message': 'Cartão não suportado: ' + data.creditCard.brand
                        }
                  }
      }

      console.log('iniciando TransactionCreditCardRequestModel');
      const saleData: TransactionCreditCardRequestModel = {
            merchantOrderId: data.merchantOrderId,
            customer: {
                  name: userData.name,
                  identity: data.cpf,
                  identityType: 'CPF',
                  email: userData.email,
                  deliveryAdress: {
                        street: userData.adress,
                        number: userData.number,
                        complement: userData.bairro,
                        zipCode: userData.cep.replace('-', ''),
                        city: userData.cidade,
                        state: userData.uf,
                        country: 'BRA',
                        district: userData.bairro
                  },                  
            },
            payment: {
                  currency: 'BRL',
                  country: 'BRA',
                  amount: data.amount,
                  installments: data.installments,
                  softDescriptor: data.softDescriptor,
                  type: data.paymentType,
                  capture: false,
                  creditCard: {
                        cardNumber: data.creditCard.cardNumber,
                        holder: data.creditCard.holder,
                        expirationDate: data.creditCard.expirationDate,
                        securityCode: data.creditCard.securityCode,
                        brand: brand
                  }
            }
      }
      console.log('dados da venda: ');
      console.log(saleData);

      try {
            const transaction = await cielo.creditCard.transaction(saleData);

            if (transaction.payment.status === 1) {
                  return {
                        'success': true,
                        'paymentId': transaction.payment.paymentId
                  }
            } else {
                  let message = '';
                  switch (transaction.payment.returnCode) {
                        case '5':
                              message = 'Não autorizada';
                              break;
                        case '57':
                              message = 'Cartão expirado';
                              break;
                        case '78':
                              message = 'Cartão bloqueado';
                              break;
                        case '99':
                              message = 'Tempo de espera esgotado';
                              break;
                        case '77':
                              message = 'Cartão cancelado';
                              break;
                        case '70':
                              message = 'Problemas com o Cartão de Crédito';
                              break;
                        default: 
                              message = transaction.payment.returnMessage;                        
                  }
                  return {
                        'success': false,
                        'status': transaction.payment.status,
                        'error': {
                              'code': transaction.payment.returnCode,
                              'message': message
                        }
                  }
            }
      } catch(error) {
            console.log('Erro ao realizar autorização: ', error);
            return {
                  'success': false,
                  'status': error.payment.status,
                  'error': {
                        'code': error.response[0].Code,
                        'message': error.response[0].Message
                  }
            }
      }

});






//export const helloWorld = functions.https.onRequest((request, response) => {
// response.send("Hello from Firebase!");
//});

/*
export const helloWorld = functions.https.onCall((data, context) => {
      return {data: "Hello from Cloud Functions"};
});

 export const getUserData = functions.https.onCall( async (data, context) => {
      
      if (!context.auth) {
            return {
                  'data':'Nenhum usuário logado'
            }  
      }

      const snapshot = await admin.firestore().collection('users').doc(context.auth.uid).get();
      return {
            'data':snapshot.data()
      };
 });


 export const addMessage = functions.https.onCall( async (data, context) => {
      console.log(data); // aparece no log do firebase
      const snapshot = await admin.firestore().collection('messages').add(data);      
      return {'sucess':snapshot.id};
 });

 
 export const onNewOrder = functions.firestore.document('/transactions/{transactionId}').onCreate((snapshot, context) => {
      const transactionId = context.params.transactionId;
      console.log(transactionId);      
 });
*/

 // deploy das funções para o firebase:
 // firebase deploy --only functions

 // mostrar o log no console:
 // firebase functions: log