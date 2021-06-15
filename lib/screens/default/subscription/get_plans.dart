import 'package:examplesgn/components/loading.dart';
import 'package:examplesgn/credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerencianet/gerencianet.dart';

class GetPlans extends StatefulWidget {
  @override
  _GetPlansState createState() => _GetPlansState();
}

class _GetPlansState extends State<GetPlans> {
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
        body: SingleChildScrollView(
          child: _body(),
        ));
  }

  Widget _body() {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return _error();
        else if (snapshot.hasData)
          return snapshot.data['code'] == 200
              ? _list(snapshot.data['data'])
              : _notFound();
        else
          return _loading();
      },
      future: gn.call('getPlans', params: {
        "inicio": "2021-01-01T16:01:35Z",
        "fim": "2021-12-31T16:01:35Z"
      }),
    );
  }

  Widget _list(data) {
    return ListView.builder(
        itemCount: data.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return _content(data[index]);
        });
  }

  Widget _content(info) {
    return Padding(
        padding: EdgeInsets.only(bottom: 7.5, top: 7.5),
        child: ListTile(
            contentPadding: EdgeInsets.only(bottom: 7.5, top: 7.5, left: 15),
            title: Text(info['name'], style: TextStyle(fontSize: 15)),
            subtitle: Text("ID: ${info['plan_id']}"),
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
                              title: Text(info['name'],
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
                                  _info("${info['plan_id']}", "ID", true),
                                  _info("${info['name']}", "NOME", true),
                                  _info("${info['interval']}", "PERIODICIDADE ",
                                      false),
                                  _info("${info['repeats']}",
                                      "Nº DE COBRANÇAS ", false),
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

  Widget _loading() {
    return Container(
      height: MediaQuery.of(context).size.height - 150,
      child: Center(child: Loading()),
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
      title: Text("Planos"),
      centerTitle: true,
      actions: [
        _buttonInfo(
            "Listar planos",
            "Permite listar os planos de assinatura criados. Existem filtros avançados que podem ser utilizados para localizar, tais como:\n\n"
                "Name: retorna resultados a partir da procura pelo nome do plano cadastrado previamente;\n"
                "Limit: limite máximo de registros de resposta;\n"
                "Offset: determina a partir de qual registro a busca será realizada.\n\n\n",
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
}
