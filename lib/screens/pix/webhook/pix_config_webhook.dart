import 'package:examplesgn/components/form.dart';
import 'package:examplesgn/credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerencianet/gerencianet.dart';

class PixConfigWebhook extends StatefulWidget {
  @override
  _PixConfigWebhookState createState() => _PixConfigWebhookState();
}

class _PixConfigWebhookState extends State<PixConfigWebhook> {
  TextEditingController _keyController = new TextEditingController();
  TextEditingController _urlController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Gerencianet gn;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    CREDENTIALS['headers'] = {
      'x-skip-mtls-checking': 'true',
    };
    gn = new Gerencianet(CREDENTIALS);
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
        child: Padding(
      padding: EdgeInsets.only(top: 15, left: 5, right: 5),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              _form(_formKeyPix()),
              _form(_formUrl()),
            ],
          )),
    ));
  }

  Widget _form(Widget form) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 50, top: 15),
        child: form);
  }

  Widget _formUrl() {
    return FormDataField(
      helperText: "Url que receberá a notificação",
      label: "URL*",
      line: 1,
      controller: _urlController,
      textInputType: TextInputType.text,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formKeyPix() {
    return Row(
      children: [
        Expanded(
            child: FormDataField(
          helperText: "Chave pix",
          label: "Chave*",
          line: 1,
          controller: _keyController,
          textInputType: TextInputType.text,
          validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
        )),
        IconButton(
            icon: Icon(Icons.remove_red_eye, color: Color(0xFF00b4c5)),
            onPressed: () {
              Navigator.pushNamed(context, "gn/key/list");
            }),
      ],
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
              _pixConfigWebhook();
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
                "CONFIGURAR",
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
      title: Text("Configurar Webhook"),
      centerTitle: true,
      actions: [
        _buttonInfo(
            "Configurar o Webhook Pix",
            "Endpoint para configuração do serviço de notificações acerca de Pix recebidos. Somente PIX associados a um txid serão notificados.\n\n",
            Colors.white)
      ],
    );
  }

  void _pixConfigWebhook() {
    setState(() => _loading = true);
    Map<String, dynamic> params = {
      "chave": _keyController.text,
    };

    Map<String, dynamic> body = {
      "webhookUrl": _urlController.text,
    };

    gn.call("pixConfigWebhook", params: params, body: body).then((value) {
      setState(() => _loading = false);
      _showMessage("Webhook Configurado!", Theme.of(context).accentColor,
          MediaQuery.of(context).size.height);
    }).catchError((error) {
      setState(() => _loading = false);
      _showMessage(
          error.toString(), Colors.red, MediaQuery.of(context).size.height);
    });
  }
}
