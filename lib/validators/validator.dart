class Validator {


   static bool validateCpf(String CPF) {
      print(CPF);
      CPF = CPF.replaceAll('\\s+', '').replaceAll('-', '').replaceAll('.', '');
      print(CPF);
      if (CPF == ("00000000000") ||
          CPF == ("11111111111") ||
          CPF == ("22222222222") || CPF == ("33333333333") ||
          CPF == ("44444444444") || CPF == ("55555555555") ||
          CPF == ("66666666666") || CPF == ("77777777777") ||
          CPF == ("88888888888") || CPF == ("99999999999") ||
         (CPF.length != 11))
         return(false);

      String dig10, dig11;
      int sm, i, r, num, peso;

      // "try" - protege o codigo para eventuais erros de conversao de tipo (int)
      try {
         // Calculo do 1o. Digito Verificador
         sm = 0;
         peso = 10;
         for (i=0; i<9; i++) {
            // converte o i-esimo caractere do CPF em um numero:
            // por exemplo, transforma o caractere '0' no inteiro 0
            // (48 eh a posicao de '0' na tabela ASCII)
            num = (int.parse(CPF[i]) - 48);
            print(num);
            sm = sm + (num * peso);
            peso = peso - 1;
         }

         r = 11 - (sm % 11);
         if ((r == 10) || (r == 11))
            dig10 = '0';
         else dig10 = (r + 48).toString(); // converte no respectivo caractere numerico

         // Calculo do 2o. Digito Verificador
         sm = 0;
         peso = 11;
         for(i=0; i<10; i++) {
            num = (int.parse(CPF[i]) - 48);
            sm = sm + (num * peso);
            peso = peso - 1;
         }

         r = 11 - (sm % 11);
         if ((r == 10) || (r == 11))
            dig11 = '0';
         else dig11 = (r + 48).toString();


         // Verifica se os digitos calculados conferem com os digitos informados.
         if ((dig10 == CPF[9]) && (dig11 == CPF[10])) {


            return (true);
         }
         else return(false);
      } catch (InputMismatchException) {
         return(false);
      }
   }

}