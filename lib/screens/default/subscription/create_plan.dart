import 'package:examplesgn/components/form.dart';
import 'package:examplesgn/credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerencianet/gerencianet.dart';

class CreatePlan extends StatefulWidget {
  @override
  _CreatePlanState createState() => _CreatePlanState();
}

class _CreatePlanState extends State<CreatePlan> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _intervalController = new TextEditingController();
  TextEditingController _repeatController = new TextEditingController();
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
                    _form(_formName()),
                    _form(_formInterval()),
                    _form(_formRepeats()),
                  ],
                ))));
  }

  Widget _form(Widget form) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 50, top: 15),
        child: form);
  }

  Widget _formRepeats() {
    return FormDataField(
      helperText: "Número de vezes que a cobrança deve ser gerada",
      label: "Cobranças",
      hintText: "Ex: 10",
      line: 1,
      controller: _repeatController,
      textInputType: TextInputType.number,
    );
  }

  Widget _formInterval() {
    return FormDataField(
      helperText: "Periodicidade da cobrança (em meses) ",
      label: "Periodicidade *",
      hintText: "Ex: 1",
      line: 1,
      controller: _intervalController,
      textInputType: TextInputType.number,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formName() {
    return FormDataField(
      helperText: "Nome do plano",
      label: "Nome*",
      hintText: "Ex: Meu Plano de Assinatura",
      line: 1,
      controller: _nameController,
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
              _createPlan();
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
      title: Text("Criar Plano"),
      centerTitle: true,
      actions: [
        _buttonInfo(
            "Cria o Plano de Assinatura",
            "Inicialmente, será criado o plano de assinatura, em que o integrador poderá definir três informações:\n\n"
                "Nome do plano;\n"
                "Periodicidade da cobrança (por exemplo, 1 para mensal);\n"
                "Quantas cobranças devem ser geradas.\n"
                "Para criar um plano de assinatura, você deve enviar uma requisição POST para a rota /plan.\n\n",
            Colors.white)
      ],
    );
  }

  void _createPlan() {
    setState(() => _loading = true);

    Map<String, dynamic> body = {
      "name": _nameController.text,
      "interval": int.parse(_intervalController.text),
      "repeats": _repeatController.text != ""
          ? int.parse(_repeatController.text)
          : null,
    };
    gn.call("createPlan", body: body).then((value) {
      setState(() => _loading = false);
      _showMessage("Plano Criado!", Theme.of(context).accentColor,
          MediaQuery.of(context).size.height);
    }).catchError((error) {
      setState(() => _loading = false);
      _showMessage(
          error.toString(), Colors.red, MediaQuery.of(context).size.height);
    });
  }
}
