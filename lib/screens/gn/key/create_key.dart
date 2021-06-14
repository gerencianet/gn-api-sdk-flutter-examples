import 'package:examplesgn/credentials.dart';
import 'package:flutter/material.dart';
import 'package:gerencianet/gerencianet.dart';

class CreateKey extends StatefulWidget {
  @override
  _CreateKeyState createState() => _CreateKeyState();
}

class _CreateKeyState extends State<CreateKey> {
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
    return Center(
        child: Text("Para criar uma chave aleatória, aperte em CRIAR",
            style: TextStyle(color: Color(0xFF848484))));
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
        onPressed: _createKey,
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
      title: Text("Criar Chave"),
      centerTitle: true,
      actions: [
        _buttonInfo(
            "Criar chave evp",
            "Endpoint utilizado para criar uma chave Pix aleatória (evp). POST /v2/gn/evp\n\n",
            Colors.white)
      ],
    );
  }

  void _createKey() {
    if (!_loading) {
      setState(() => this._loading = true);
      gn.call("gnCreateEvp").then((value) {
        setState(() => _loading = false);
        _showMessage("Chave Criada!", Theme.of(context).accentColor,
            MediaQuery.of(context).size.height);

      }).catchError((error) {
        setState(() => _loading = false);
        _showMessage(
            error.toString(), Colors.red, MediaQuery.of(context).size.height);
      });
    }
  }
}
