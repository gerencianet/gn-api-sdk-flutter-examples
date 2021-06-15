import 'package:examplesgn/components/loading.dart';
import 'package:examplesgn/credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerencianet/gerencianet.dart';

class PixListCharges extends StatefulWidget {
  @override
  _PixListChargesState createState() => _PixListChargesState();
}

class _PixListChargesState extends State<PixListCharges> {
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
        body: SingleChildScrollView(
          child: _body(),
        ));
  }

  Widget _body() {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _error();
        } else if (snapshot.hasData) {
          return snapshot.data['cobs'].length > 0
              ? _list(snapshot)
              : _notFound();
        } else {
          return _loading();
        }
      },
      future: gn.call('pixListCharges', params: {
        "inicio": "2021-01-01T16:01:35Z",
        "fim": "2021-12-31T16:01:35Z"
      }),
    );
  }

  Widget _list(snapshot) {
    return ListView.builder(
        itemCount: snapshot.data['cobs'].length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return _content(snapshot.data['cobs'], index);
        });
  }

  Widget _content(info, index) {
    return Padding(
        padding: EdgeInsets.only(bottom: 7.5, top: 7.5),
        child: ListTile(
            title: Text(info[index]['txid']),
            subtitle: Text(
                "COBRANÇA ${index + 1} - ${info[index]['calendario']['criacao'].split('T')[0]}"),
            tileColor: Colors.white,
            leading: Container(
              width: 45,
              child: IconButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Scaffold(
                            appBar: AppBar(
                              elevation: 0,
                              title: Text("COBRANÇA ${index + 1}"),
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
                                  _infoCharge(
                                      "${info[index]['status']}",
                                      "STATUS",
                                      false),
                                  _infoCharge(
                                      "${info[index]['calendario']['criacao']}",
                                      "DATA CRIAÇÂO",
                                      false),
                                  _infoCharge(
                                      "${info[index]['calendario']['expiracao']}",
                                      "EXPIRAÇÃO",
                                      false),
                                  _infoCharge(
                                      "${info[index]['location']}",
                                      "LOCATION",
                                      true),
                                  _infoCharge(
                                      "${info[index]['txid']}",
                                      "TXID",
                                      true),
                                  _infoCharge(
                                      "${info[index]['valor']['original']}",
                                      "VALOR",
                                      false),
                                  _infoCharge(
                                      "${info[index]['chave']}",
                                      "CHAVE",
                                      true),
                                ],
                              ),
                            ));
                      });
                },
                icon: Icon(Icons.remove_red_eye,
                    color: Theme.of(context).accentColor),
              ),
            )));
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

  Widget _loading() {
    return Container(
      height: MediaQuery.of(context).size.height - 150,
      child: Center(
        child: Loading(),
      ),
    );
  }

  Widget _notFound() {
    return Container(
      height: MediaQuery.of(context).size.height - 150,
      child: Center(
        child: Text(
          "Nenhum dado encontrado!",
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
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

  Widget _appBar() {
    return AppBar(
      elevation: 0,
      title: Text("Cobranças"),
      centerTitle: true,
      actions: [
        _buttonInfo(
            "Consultar lista de cobranças",
            "Endpoint para consultar cobranças através de parâmetros como início, fim, cpf, cnpj e status, os atributos são inseridos no parâmetro da query GET /v2/cob​/\n\n",
            Colors.white)
      ],
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
}
