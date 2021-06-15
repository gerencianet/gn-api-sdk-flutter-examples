import 'package:examplesgn/components/form.dart';
import 'package:examplesgn/components/loading.dart';
import 'package:examplesgn/credentials.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerencianet/gerencianet.dart';

class EditSettings extends StatefulWidget {
  @override
  _EditSettingsState createState() => _EditSettingsState();
}

class _EditSettingsState extends State<EditSettings> {
  Gerencianet gn;
  TextEditingController _keyController = new TextEditingController();
  bool _loadingSave = false;
  dynamic _infoSettings;
  bool _qrCodeStatic = false;
  bool _txId = false;

  @override
  void initState() {
    super.initState();
    gn = new Gerencianet(CREDENTIALS);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return _error();
        else if (snapshot.hasData) {
          if (_infoSettings == null) this._infoSettings = snapshot.data;
          return _content(snapshot);
        } else
          return _loading();
      },
      future: gn.call('gnDetailSettings'),
    );
  }

  Widget _content(snapshot) {
    return Scaffold(
        appBar: _appBar(),
        bottomSheet: _bottomSheet(),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: [
            _headerContent("PIX"),
            _checkForm(
                Checkbox(
                    value: _infoSettings['pix']['receberSemChave'],
                    onChanged: (bool newValue) => setState(() => this
                        ._infoSettings['pix']['receberSemChave'] = newValue)),
                "Receber sem chave:"),
            _headerContent("CHAVE"),
            _form(_formKeyPix()),
            _checkForm(
                Checkbox(
                    value: _qrCodeStatic,
                    onChanged: (bool newValue) =>
                        setState(() => this._qrCodeStatic = newValue)),
                "Recusar QrCode Estático:"),
            _checkForm(
                Checkbox(
                    value: _txId,
                    onChanged: (bool newValue) =>
                        setState(() => this._txId = newValue)),
                "TXID Obrigatório:"),
          ],
        ));
  }

  Widget _formKeyPix() {
    return Row(
      children: [
        Expanded(
            child: FormDataField(
          helperText: "Chave pix aleatória",
          label: "Chave",
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

  Widget _form(Widget form) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 15),
        child: form);
  }

  Widget _checkForm(Widget checkbox, String text) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Expanded(child: Text(text)),
          SizedBox(height: 24.0, width: 24.0, child: checkbox),
        ],
      ),
    );
  }

  _headerContent(String title) {
    return Container(
      margin: EdgeInsets.only(top: 15, right: 5, left: 5),
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: 45,
      padding: EdgeInsets.only(left: 15, right: 15, top: 15),
      child:
          Text(title, style: TextStyle(color: Theme.of(context).primaryColor)),
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

  Widget _loading() {
    return Scaffold(
        appBar: _appBar(),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Container(
          height: MediaQuery.of(context).size.height - 150,
          child: Center(
            child: Loading(),
          ),
        ));
  }

  Widget _error() {
    return Container(
      height: MediaQuery.of(context).size.height - 150,
      child: Center(
        child: Text(
          "Aconteceu um erro!",
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      elevation: 0,
      title: Text("Modificar Configurações"),
      centerTitle: true,
      actions: [
        _buttonInfo(
            "Criar / modificar configurações da conta",
            "Endpoint com a finalidade de criar e modificar as configurações da conta do cliente relacionados à API.PUT /v2/gn/config.\n\n",
            Colors.white)
      ],
    );
  }

  Widget _bottomSheet() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: TextButton(
        onPressed: () {
          if (!this._loadingSave) {
            setState(() => this._loadingSave = true);
            FocusScope.of(context).requestFocus(new FocusNode());
            _gnUpdateSettings();
          }
        },
        child: _loadingSave
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Text(
                "SALVAR",
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

  dynamic _gnUpdateSettings() async {
    if (_keyController.text != "")
      _infoSettings['pix']['chaves'][_keyController.text] = {
        'recebimento': {
          'txidObrigatorio': _txId,
          'qrCodeEstatico': {'recusarTodos': _qrCodeStatic}
        }
      };

    gn.call('gnUpdateSettings', body: _infoSettings).then((value) {
      setState(() => _loadingSave = false);
      _showMessage("Informações Atualizadas!", Theme.of(context).accentColor,
          MediaQuery.of(context).size.height);
    }).catchError((error) {
      setState(() => _loadingSave = false);
      _showMessage(
          error.toString(), Colors.red, MediaQuery.of(context).size.height);
    });
  }
}
