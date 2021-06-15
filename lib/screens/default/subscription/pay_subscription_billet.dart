import 'package:examplesgn/components/form.dart';
import 'package:examplesgn/credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerencianet/gerencianet.dart';

class PaySubscriptionBillet extends StatefulWidget {
  @override
  _PaySubscriptionBilletState createState() => _PaySubscriptionBilletState();
}

class _PaySubscriptionBilletState extends State<PaySubscriptionBillet> {
  TextEditingController _idController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _cpfController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Gerencianet gn;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    Map credentials = new Map.from(CREDENTIALS);
    credentials.remove("pix_cert");
    credentials.remove("pix_private_key");
    gn = new Gerencianet(credentials);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        bottomSheet: _bottomSheet(),
        backgroundColor: Theme.of(context).backgroundColor,
        body: _body());
  }

  Widget _body() {
    return SingleChildScrollView(
        child: Form(key: _formKey, child: Column(
          children: [
            _headerForm(
                "Assinatura",
                "O campo ID é referente ao ID de uma assinatura criada anteriormente."),
            _form(_formId()),
            _headerForm(
                "Cliente",
                "Os campos abaixo faz referência ao cliente a ser vinculado a assinatura."),
            _form(_formName()),
            _form(_formCpf()),
            _form(_formPhone()),
            _headerForm(
                "Boleto",
                "Os campos abaixo faz referência ao boleto a ser associado."),
            _form(_formExpireDate()),
            Container(height: 100)

          ],
        )));
  }

  Widget _form(Widget form) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 50, top: 15),
        child: form);
  }

  Widget _formExpireDate() {
    return FormDataField(
      helperText: "Data de vencimento do boleto (yyyy-mm-dd)",
      label: "Data de Vencimento*",
      hintText: "ex: 2021-07-06",
      line: 1,
      controller: _dateController,
      textInputType: TextInputType.datetime,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formPhone() {
    return FormDataField(
      helperText: "Telefone do cliente (somente números)",
      label: "Telefone*",
      hintText: "ex: 5144916523",
      line: 1,
      controller: _phoneController,
      textInputType: TextInputType.number,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formCpf() {
    return FormDataField(
      helperText: "CPF do cliente (somente números)",
      label: "CPF*",
      hintText: "ex: 94271564656",
      line: 1,
      controller: _cpfController,
      textInputType: TextInputType.number,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formName() {
    return FormDataField(
      helperText: "Nome do cliente",
      label: "Nome*",
      hintText: "ex: Gorbadoc Oldbuck",
      line: 1,
      controller: _nameController,
      textInputType: TextInputType.text,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formId() {
    return FormDataField(
      helperText: "Id da assinatura",
      label: "Id*",
      hintText: "ex: 123",
      line: 1,
      controller: _idController,
      textInputType: TextInputType.number,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _buttonInfo(String title, String content, Color color) {
    return IconButton(
        icon: Icon(Icons.help, color: color),
        onPressed: () {
          _showInfo(title, content);
        });
  }

  void _showInfo(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor,
            title: new Text(title),
            content: Text(content +
                "\n\nPara mais informações acesse a nossa documentação: dev.gerencianet.com.br"),
            contentTextStyle: TextStyle(color: Color(0xFF848484)),
            titleTextStyle:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
            actions: <Widget>[
              new TextButton(
                child: new Text(
                  "Fechar",
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Widget _bottomSheet() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: TextButton(
        onPressed: () {
          if (!this._loading) {
            FocusScope.of(context).requestFocus(new FocusNode());
            final FormState form = _formKey.currentState;
            if (form.validate() && !_loading) {
              _paySubscription();
            } else {
              _showMessage("Preencha os campos obrigatórios!", Colors.red, 25);
            }
          }
        },
        child: _loading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Text(
                "ASSOCIAR",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  void _showMessage(String msg, Color color, double height) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      content: Container(
        height: height,
        child: Center(
          child: Text(msg),
        ),
      ),
    ));
  }

  Widget _appBar() {
    return AppBar(
      elevation: 0,
      title: Text("Associar Boleto Assinatura"),
      centerTitle: true,
      actions: [
        _buttonInfo(
            "Associar Boleto Assinatura",
            "Associa método de pagamento Boleto à uma assinatura já criada\n\n",
            Colors.white)
      ],
    );
  }

  _headerForm(String title, String content) {
    return Container(
      margin: EdgeInsets.only(top: 15, right: 5, left: 5),
      color: Colors.white,
      padding: EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Row(
        children: [
          Expanded(
              child: Text(title,
                  style: TextStyle(color: Theme.of(context).primaryColor))),
          _buttonInfo(title, content, Color(0xFF00b4c5))
        ],
      ),
    );
  }

  void _paySubscription() {
    setState(() => _loading = true);

    Map<String, dynamic> params = {
      "id": _idController.text,
    };

    Map<String, dynamic> body = {
      "payment": {
        "banking_billet": {
          "expire_at": _dateController.text,
          "customer": {
            "name": _nameController.text,
            "cpf": _cpfController.text,
            "phone_number": _phoneController.text
          }
        }
      }
    };

    gn.call("paySubscription", params: params, body: body).then((value) {
      setState(() => _loading = false);
      _showMessage("Boleto Associado!", Theme.of(context).accentColor,
          MediaQuery.of(context).size.height);
    }).catchError((error) {
      setState(() => _loading = false);
      _showMessage(
          error.toString(), Colors.red, MediaQuery.of(context).size.height);
    });
  }
}
