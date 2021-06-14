import 'package:examplesgn/components/form.dart';
import 'package:examplesgn/credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerencianet/gerencianet.dart';

class LinkCharge extends StatefulWidget {
  @override
  _LinkChargeState createState() => _LinkChargeState();
}

class _LinkChargeState extends State<LinkCharge> {
  TextEditingController _idController = new TextEditingController();
  TextEditingController _billetDiscountController = new TextEditingController();
  TextEditingController _cardDiscountController = new TextEditingController();
  TextEditingController _messageController = new TextEditingController();
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
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                _headerForm("Transação",
                    "O campo ID é referente ao ID de uma transação criada anteriormente."),
                _form(_formId()),
                _headerForm("Link",
                    "O campo abaixo é referente a data de vencimento da tela de pagamento e do próprio boleto."),
                _form(_formBilletDiscount()),
                _form(_formCardDiscount()),
                _form(_formMessage()),
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

  Widget _formMessage() {
    return FormDataField(
      helperText: "Mensagem para o pagador com até 80 caracteres",
      label: "Mensagem*",
      hintText: "ex: Olá...",
      line: 1,
      controller: _messageController,
      textInputType: TextInputType.text,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formBilletDiscount() {
    return FormDataField(
      helperText:
          "Desconto, em reais, caso o pagador escolha boleto (5000 equivale a R\$ 50,00)",
      label: "Desconto Boleto*",
      hintText: "ex: 1000",
      line: 1,
      controller: _billetDiscountController,
      textInputType: TextInputType.number,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formCardDiscount() {
    return FormDataField(
      helperText:
          "desconto, em reais, caso o pagador escolha cartão (3000 equivale a R\$ 30,00)",
      label: "Desconto Boleto*",
      hintText: "ex: 1000",
      line: 1,
      controller: _cardDiscountController,
      textInputType: TextInputType.number,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formId() {
    return FormDataField(
      helperText: "Id da transação",
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
              _linkCharge();
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
                "CRIAR",
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
      title: Text("Criar Link Pagamento"),
      centerTitle: true,
      actions: [
        _buttonInfo(
            "Criar Link Pagamento",
            "Retorna um link para uma tela de pagamento da Gerencianet.\n\n",
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

  void _linkCharge() {
    setState(() => _loading = true);

    Map<String, dynamic> params = {
      "id": _idController.text,
    };

    Map<String, dynamic> body = {
      "billet_discount": int.parse(_billetDiscountController.text),
      "card_discount": int.parse(_cardDiscountController.text),
      "message": _messageController.text,
      "expire_at": _dateController.text,
      "request_delivery_address": true,
      "payment_method": "all"
    };

    gn.call("linkCharge", params: params, body: body).then((value) {
      setState(() => _loading = false);
      _showMessage("Link Criado!", Theme.of(context).accentColor,
          MediaQuery.of(context).size.height);
    }).catchError((error) {
      setState(() => _loading = false);
      _showMessage(
          error.toString(), Colors.red, MediaQuery.of(context).size.height);
    });
  }
}
