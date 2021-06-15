import 'package:examplesgn/components/form.dart';
import 'package:examplesgn/credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerencianet/gerencianet.dart';

class CreateChargeLink extends StatefulWidget {
  @override
  _CreateChargeLinkState createState() => _CreateChargeLinkState();
}

class _CreateChargeLinkState extends State<CreateChargeLink> {
  TextEditingController _nameItemController = new TextEditingController();
  TextEditingController _amountController = new TextEditingController();
  TextEditingController _valueController = new TextEditingController();
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
                _headerForm("Item",
                    "Os campos abaixo são referentes ao item a ser associado a transação.\n"),
                _form(_formNameItem()),
                _form(_formAmount()),
                _form(_formValue()),
                Container(height: 100)
              ],
            )));
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

  Widget _form(Widget form) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 50, top: 15),
        child: form);
  }

  Widget _formNameItem() {
    return FormDataField(
      helperText: "Nome do item, produto ou serviço.",
      label: "Nome*",
      hintText: "Ex: Transação item 1",
      line: 1,
      controller: _nameItemController,
      textInputType: TextInputType.text,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formAmount() {
    return FormDataField(
      helperText: "Quantidade do item, produto ou serviço",
      label: "Quantidade*",
      hintText: "ex: 1",
      line: 1,
      controller: _amountController,
      textInputType: TextInputType.number,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formValue() {
    return FormDataField(
      helperText: "Valor do item, produto ou serviço. (1000 = R\$ 10,00)",
      label: "Valor*",
      hintText: "ex: 1000",
      line: 1,
      controller: _valueController,
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
              _createChargeLink();
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
      title: Text("Criar Transação"),
      centerTitle: true,
      actions: [
        _buttonInfo("Criar Transação",
            "Criar nova transação.\n\n", Colors.white)
      ],
    );
  }

  void _createChargeLink() {
    setState(() => _loading = true);

    Map<String, dynamic> body = {
      "items": [
        {
          "name": _nameItemController.text,
          "value": int.parse(_valueController.text),
          "amount": int.parse(_amountController.text)
        }
      ],
    };

    gn.call("createChargeLink", body: body).then((value) {
      setState(() => _loading = false);
      _showMessage("Transação Criada!", Theme.of(context).accentColor,
          MediaQuery.of(context).size.height);
    }).catchError((error) {
      setState(() => _loading = false);
      _showMessage(
          error.toString(), Colors.red, MediaQuery.of(context).size.height);
    });
  }
}
