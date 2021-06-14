import 'package:examplesgn/components/loading.dart';
import 'package:examplesgn/credentials.dart';
import 'package:flutter/material.dart';
import 'package:gerencianet/gerencianet.dart';

class DetailBalance extends StatefulWidget {
  @override
  _DetailBalanceState createState() => _DetailBalanceState();
}

class _DetailBalanceState extends State<DetailBalance> {
  Gerencianet gn;

  @override
  void initState() {
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
          return _balance(snapshot.data['saldo']);
        else
          return _loading();
      },
      future: gn.call('gnDetailBalance'),
    );
  }

  Widget _balance(String value) {
    return Center(
        child: Container(
      height: 150,
      margin: EdgeInsets.symmetric(horizontal: 5),
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Saldo disponível", style: TextStyle(color: Color(0xFF848484))),
          Text("R\$ $value",
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold)),
        ],
      ),
    ));
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

  Widget _appBar() {
    return AppBar(
      elevation: 0,
      title: Text("Saldo"),
      centerTitle: true,
      actions: [
        _buttonInfo(
            "Criar chave evp",
            "Endpoint com a finalidade de consultar o saldo em sua conta Gerencianet GET/v2/gn/saldo. Você pode habilitar o escopo nas configurações de sua aplicação em sua conta Gerencianet.\n\n",
            Colors.white)
      ],
    );
  }
}
