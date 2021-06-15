import 'package:examplesgn/components/loading.dart';
import 'package:examplesgn/credentials.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerencianet/gerencianet.dart';

class DetailSettings extends StatefulWidget {
  @override
  _DetailSettingsState createState() => _DetailSettingsState();
}

class _DetailSettingsState extends State<DetailSettings> {
  Gerencianet gn;

  @override
  void initState() {
    super.initState();
    gn = new Gerencianet(CREDENTIALS);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        backgroundColor: Theme.of(context).backgroundColor,
        body: _body());
  }

  Widget _body() {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return _error();
        else if (snapshot.hasData)
          return _content(snapshot);
        else
          return _loading();
      },
      future: gn.call('gnDetailSettings'),
    );
  }

  Widget _content(snapshot) {
    return Column(
      children: [
        _headerContent("PIX"),
        _contentPix(snapshot.data['pix']['receberSemChave']),
        _headerContent("CHAVES"),
        for (var key in snapshot.data['pix']['chaves'].keys)
          _contentKey(key, snapshot)
      ],
    );
  }

  Widget _contentPix(info) {
    return Container(
        color: Colors.white,
        margin: EdgeInsets.only(left: 5, right: 5),
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 5),
        child: Row(
          children: [
            Expanded(child: Text("Receber sem chave:")),
            Text(info ? "Sim" : "Não"),
          ],
        ));
  }

  Widget _contentKey(String key, dynamic snapshot) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(key, style: TextStyle(fontWeight: FontWeight.w600)),
            Padding(padding: EdgeInsets.only(top: 15)),
            Row(
              children: [
                Expanded(child: Text("TXID Obrigatório:")),
                Text(snapshot.data['pix']['chaves'][key]['recebimento']
                        ['txidObrigatorio']
                    ? "Sim"
                    : "Não"),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 5)),
            Row(
              children: [
                Expanded(child: Text("Recusar QrCode Estático:")),
                Text(snapshot.data['pix']['chaves'][key]['recebimento']
                        ['qrCodeEstatico']['recusarTodos']
                    ? "Sim"
                    : "Não"),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Divider(
              height: 10,
            ),
            Padding(padding: EdgeInsets.only(bottom: 15)),
          ],
        ));
    // Divider()
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
    return Container(
      height: MediaQuery.of(context).size.height - 150,
      child: Center(
        child: Loading(),
      ),
    );
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
      title: Text("Configurações"),
      centerTitle: true,
      actions: [
        _buttonInfo(
            "Listar configurações da conta",
            "Endpoint com a finalidade de listar as configurações definidas na conta.GET /v2/gn/config.\n\n",
            Colors.white)
      ],
    );
  }
}
