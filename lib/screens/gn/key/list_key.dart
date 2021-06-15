import 'package:examplesgn/components/loading.dart';
import 'package:examplesgn/credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerencianet/gerencianet.dart';

class ListKey extends StatefulWidget {
  @override
  _ListKeyState createState() => _ListKeyState();
}

class _ListKeyState extends State<ListKey> {
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
          return snapshot.data['chaves'].length > 0
              ? _list(snapshot)
              : _notFound();
        } else {
          return _loading();
        }
      },
      future: gn.call('gnListEvp'),
    );
  }

  Widget _list(snapshot) {
    return ListView.builder(
        itemCount: snapshot.data['chaves'].length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return _content(snapshot.data['chaves'], index);
        });
  }

  Widget _content(key, index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 7.5, top: 7.5),
      child: ListTile(
          title: Text(key[index]),
          subtitle: Text("Chave ${index+1}"),
          tileColor: Colors.white,
          leading: Container(
            width: 45,
            child: IconButton(
              onPressed: () async {
                ClipboardData data = ClipboardData(text: key[index]);
                await Clipboard.setData(data);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Theme.of(context).accentColor,
                  content: Text("Chave copiada"),
                ));
              },
              icon: Icon(Icons.copy, color: Theme.of(context).accentColor),
            ),
          )),
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
          "Nenhuma chave encontrada!",
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

  Widget _appBar() {
    return AppBar(
      elevation: 0,
      title: Text("Chaves"),
      centerTitle: true,
    );
  }
}
