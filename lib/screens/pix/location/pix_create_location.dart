import 'package:examplesgn/components/form.dart';
import 'package:examplesgn/credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerencianet/gerencianet.dart';

class PixCreateLocation extends StatefulWidget {
  @override
  _PixCreateLocationState createState() => _PixCreateLocationState();
}

class _PixCreateLocationState extends State<PixCreateLocation> {
  TextEditingController _typeController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Gerencianet gn;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
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
        child: Form(key: _formKey, child: _form(_formType())));
  }

  Widget _form(Widget form) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 50, top: 15),
        child: form);
  }

  Widget _formType() {
    return FormDataField(
      label: "Tipo Cob*",
      hintText: "Ex: cob",
      line: 1,
      controller: _typeController,
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
              _pixCreateLocation();
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
      title: Text("Criar Location"),
      centerTitle: true,
      actions: [
        _buttonInfo(
            "Criar location do payload",
            "Endpoint para criar location do payload POST/v2​/loc.\n\n",
            Colors.white)
      ],
    );
  }

  void _pixCreateLocation() {
    setState(() => _loading = true);
    Map<String, dynamic> body = {
      "tipoCob": _typeController.text,
    };
    gn.call("pixCreateLocation", body: body).then((value) {
      setState(() => _loading = false);
      _showInfoLocation(value);
    }).catchError((error) {
      setState(() => _loading = false);
      _showMessage(
          error.toString(), Colors.red, MediaQuery.of(context).size.height);
    });
  }

  void _showInfoLocation(dynamic value) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: Text("LOCATION ${value['id']}"),
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
                    _infoCharge("${value['id']}", "ID", true),
                    _infoCharge("${value['location']}", "LOCATION", true),
                    _infoCharge("${value['tipoCob']}", "TIPO", false),
                    _infoCharge("${value['criacao']}", "CRIAÇÃO", false),
                  ],
                ),
              ));
        });
  }

  Widget _infoCharge(String info, String name, bool show) {
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
}
