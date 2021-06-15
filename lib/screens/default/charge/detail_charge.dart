import 'package:examplesgn/components/form.dart';
import 'package:examplesgn/credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerencianet/gerencianet.dart';

class DetailCharge extends StatefulWidget {
  @override
  _DetailChargeState createState() => _DetailChargeState();
}

class _DetailChargeState extends State<DetailCharge> {
  TextEditingController _idController = new TextEditingController();
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
        child: Form(key: _formKey, child: _form(_formId())));
  }

  Widget _form(Widget form) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 50, top: 15),
        child: form);
  }

  Widget _formId() {
    return FormDataField(
      helperText: "Id da cobrança",
      label: "Id*",
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
              _detailCharge();
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
                "CONSULTAR",
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
      title: Text("Consultar Cobrança"),
      centerTitle: true,
      actions: [
        _buttonInfo("Consultar Cobrança",
            "Retornar informações de transação existente.\n\n", Colors.white)
      ],
    );
  }

  void _showInfoDetail(dynamic value) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: Text(value['charge_id'].toString(),
                    style: TextStyle(fontSize: 15)),
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    _info("${value['charge_id']}", "ID", true),
                    _info("R\$ ${value['total'] / 100}", "TOTAL", false),
                    _info("${value['status']}", "STATUS", false),
                    _info("${value['created_at']}", "CRIADO EM", false),
                  ],
                ),
              ));
        });
  }

  Widget _info(String info, String name, bool show) {
    return ListTile(
      title: Text(info),
      subtitle: Text(name),
      leading: Container(
          width: 45,
          child: show
              ? IconButton(
                  onPressed: () async {
                    ClipboardData data = ClipboardData(text: info);
                    await Clipboard.setData(data);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Theme.of(context).accentColor,
                      content: Text("Informação copiada"),
                    ));
                  },
                  icon: Icon(Icons.copy, color: Theme.of(context).accentColor),
                )
              : Container()),
    );
  }

  void _detailCharge() {
    setState(() => _loading = true);

    Map<String, dynamic> params = {
      "id": _idController.text,
    };
    gn.call("detailCharge", params: params).then((value) {
      setState(() => _loading = false);
      _showInfoDetail(value['data']);
    }).catchError((error) {
      setState(() => _loading = false);
      _showMessage(
          error.toString(), Colors.red, MediaQuery.of(context).size.height);
    });
  }
}
