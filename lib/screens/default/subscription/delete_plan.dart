import 'package:examplesgn/components/form.dart';
import 'package:examplesgn/credentials.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerencianet/gerencianet.dart';

class DeletePlan extends StatefulWidget {
  @override
  _DeletePlanState createState() => _DeletePlanState();
}

class _DeletePlanState extends State<DeletePlan> {
  TextEditingController _txIdController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  Gerencianet gn;

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
        backgroundColor: Theme.of(context).backgroundColor,
        bottomSheet: _bottomSheet(),
        body: SingleChildScrollView(
          child: _body(),
        ));
  }

  Widget _body() {
    return Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.only(top: 15, left: 5, right: 5),
            child: _form(_formId())));
  }

  Widget _form(Widget form) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 50, top: 15),
        child: form);
  }

  Widget _formId() {
    return Row(
      children: [
        Expanded(
            child: FormDataField(
          helperText: "Id do plano",
          label: "Id*",
          hintText: "Ex: 1",
          line: 1,
          controller: _txIdController,
          textInputType: TextInputType.number,
          validator: (value) => value.isEmpty ? 'Campo Obrigatório!' : null,
        )),
        IconButton(
            icon: Icon(Icons.remove_red_eye, color: Color(0xFF00b4c5)),
            onPressed: () {
              Navigator.pushNamed(context, "subscription/plan/list");
            }),
      ],
    );
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
            if (form.validate()) {
              _deletePlan();
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
                "DELETAR",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
      ),
    );
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

  Widget _appBar() {
    return AppBar(
      elevation: 0,
      title: Text("Deletar Plano"),
      centerTitle: true,
      actions: [
        _buttonInfo(
            "Deletar plano",
            "Permite cancelar um plano de assinatura. Para tal, você deve informar o plan_id do plano de assinatura que deseja cancelar.\n\n",
            Colors.white)
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

  dynamic _deletePlan() async {
    setState(() => _loading = true);
    Map<String, dynamic> params = {"id": _txIdController.text};
    gn.call('deletePlan', params: params).then((value) {
      setState(() => _loading = false);
      _showMessage("Plano Deletado!", Theme.of(context).accentColor,
          MediaQuery.of(context).size.height);
    }).catchError((error) {
      setState(() => _loading = false);
      _showMessage(
          error.toString(), Colors.red, MediaQuery.of(context).size.height);
    });
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
}
