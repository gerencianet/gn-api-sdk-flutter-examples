![SDK Gerencianet for Dart](https://media-exp1.licdn.com/dms/image/C4D1BAQH9taNIaZyh_Q/company-background_10000/0/1603126623964?e=2159024400&v=beta&t=coQC_AK70vTYL3NdvbeIaeYts8nKumNHjvvIGCmq5XA)

# gn-api-sdk-flutter-examples

SDK for Gerencianet Pagamentos' API.
For more informations about parameters and values, please refer to [Gerencianet](http://gerencianet.com.br) documentation.




## Getting started

Add the PIX certificate and its key in assets/certs.

![certs](https://s3.amazonaws.com/gerencianet-pub-prod-1/printscreen/2021/06/15/igor.pedroso/64cff6-a9ec4b90-33ed-4063-8832-ce263d8019b8.png)

After adding, run the  ```flutter pub get``` command.


The credentials of your application (client_id and client_secret) must be informed in the credentials.dart file

![credentials](https://s3.amazonaws.com/gerencianet-pub-prod-1/printscreen/2021/06/15/igor.pedroso/6bb866-e20b2cd1-bd0c-4ca4-b66c-0c032155e845.png)


```
dynamic CREDENTIALS = {
  'client_id': '',        # Enter your client id
  'client_secret': '',    # Enter your client secret
  'sandbox': false,       # Enable or disable sandbox mode
  'pix_cert': 'assets/certs/cert.crt.pem',         # Enter the certificate directory 
  'pix_private_key': 'assets/certs/cert.key.pem'   # Enter the certificate key directory 
};

```

**To generate your certificate:** Access the menu API (1)-> Meus Certificados (2) and choose the environment you want the certificate: Produção or Homologação -> click in Novo Certificado (3). 
![To generate your certificate](https://app-us-east-1.t-cdn.net/5fa37ea6b47fe9313cb4c9ca/posts/603543f7d1778b2d725dea1e/603543f7d1778b2d725dea1e_85669.png)

**Create a new application to use the Pix API:** Access the menu API (1)-> Minhas Aplicações -> Nova Aplicação(2) -> Ative API Pix (3) and choose the scopes you want to release in Produção e/ou Homologação (remembering that these can be changed later). -> click in Criar Nova aplicação(4).
![Create a new application to use the Pix API](https://t-images.imgix.net/https%3A%2F%2Fapp-us-east-1.t-cdn.net%2F5fa37ea6b47fe9313cb4c9ca%2Fposts%2F603543ff4253cf5983339cf1%2F603543ff4253cf5983339cf1_88071.png?width=1240&w=1240&auto=format%2Ccompress&ixlib=js-2.3.1&s=2f24c7ea5674dbbea13773b3a0b1e95c)


**Change an existing application to use the Pix API:** Access the menu API (1)-> Minhas Aplicações e escolha a sua aplicação (2) -> Editar(Botão laranja) -> Ative API Pix (3) and choose the scopes you want to release in Produção e/ou Homologação. -> click in Atualizar aplicação (4).
![Change an existing application to use the Pix API](https://app-us-east-1.t-cdn.net/5fa37ea6b47fe9313cb4c9ca/posts/603544082060b2e9b88bc717/603544082060b2e9b88bc717_22430.png)


For use in Dart, the certificate must be converted to .pem.
Below you will find example using the OpenSSL command for conversion.

### Command OpenSSL
```
// Gerar certificado e chave separadas
openssl pkcs12 -in path.p12 -out newfile.crt.pem -clcerts -nokeys //certificado
openssl pkcs12 -in path.p12 -out newfile.key.pem -nocerts -nodes //chave privada
```

### To register your Pix keys
The registration of Pix keys can be done through the application. If you don't already have our app installed, click on [Android](https://play.google.com/store/apps/details?id=br.com.gerencianet.app) or [iOS](https://apps.apple.com/br/app/gerencianet/id1443363326), according to your smartphone's operating system, to download it.

To register your Pix keys through the application:
1. Access your account through **app Gerencianet**.
2. In the side menu, touch **Pix** to start your registration.
3. Read the information that appears on the screen and click **Registrar Chave**.
    If this is no longer your first contact, tap **Minhas Chaves** and then the icon (➕).
4. **Select the data** you are going to register as a Pix Key and tap **avançar** - you must choose at least 1 of the 4 available key options (cell, e-mail, CPF e/ou random key).
5. After registering the desired Pix keys, click on **concluir**.
6. **Ready! Your keys are already registered with us.**




## Additional Documentation

The full documentation with all available endpoints is in https://dev.gerencianet.com.br/.

If you don't have a digital account atnetnet, [open yours now](https://sistema.gerencianet.com.br/)!

## License ##
[MIT](LICENSE)