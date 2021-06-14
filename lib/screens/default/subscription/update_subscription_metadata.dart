import 'package:examplesgn/components/form.dart';
import 'package:examplesgn/credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerencianet/gerencianet.dart';

class UpdateSubscriptionMetadata extends StatefulWidget {
  @override
  _UpdateSubscriptionMetadataState createState() =>
      _UpdateSubscriptionMetadataState();
}

class _UpdateSubscriptionMetadataState
    extends State<UpdateSubscriptionMetadata> {
  TextEditingController _idController = new TextEditingController();
  TextEditingController _customIdController = new TextEditingController();
  TextEditingController _urlController = new TextEditingController();
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
        child: Padding(
            padding: EdgeInsets.only(top: 15, left: 5, right: 5),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _form(_formId()),
                    _form(_formCustomId()),
                    _form(_formUrl())
                  ],
                ))));
  }

  Widget _form(Widget form) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 50, top: 15),
        child: form);
  }

  Widget _formUrl() {
    return FormDataField(
      helperText: "Url de notificação",
      label: "Url*",
      hintText: "ex: http://minha_url_de_notificacao.com/notificacao",
      line: 1,
      controller: _urlController,
      textInputType: TextInputType.text,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formCustomId() {
    return FormDataField(
      helperText: "Id customizado",
      label: "Custom Id*",
      hintText: "ex: Custom Subscription 0001",
      line: 1,
      controller: _customIdController,
      textInputType: TextInputType.text,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formId() {
    return FormDataField(
      helperText: "Id da assinatura",
      label: "Id*",
      hintText: "ex: 1",
      line: 1,
      controller: _idController,
      textInputType: TextInputType.text,
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
              _updateSubscriptionMetadata();
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
                "ATUALIZAR",
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
      title: Text("Atualizar Assinatura"),
      centerTitle: true,
      actions: [
        _buttonInfo(
            "Atualizar Assinatura",
            "Alterar URL de notificação ('notification_url') e/ou 'custom_id' em uma assinatura existente\n\n"
                "É possível definir ou alterar as informações enviadas na propriedade metadata de uma assinatura a qualquer momento. Este endpoint é de extrema importância para atualizar sua URL de notificação atrelada às assinaturas ou modificar o custom_id previamente associado a assinatura.\n\n",
            Colors.white)
      ],
    );
  }

  void _updateSubscriptionMetadata() {
    setState(() => _loading = true);

    Map<String, dynamic> params = {
      "id": _idController.text,
    };

    Map<String, dynamic> body = {
      "custom_id": _customIdController.text,
      "notification_url": _urlController.text,
    };
    gn.call("updateSubscriptionMetadata", params: params, body: body)
        .then((value) {
      setState(() => _loading = false);
      _showMessage("Assinatura Atualizada!", Theme.of(context).accentColor,
          MediaQuery.of(context).size.height);
    }).catchError((error) {
      setState(() => _loading = false);
      _showMessage(
          error.toString(), Colors.red, MediaQuery.of(context).size.height);
    });
  }
}
