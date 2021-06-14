import 'package:examplesgn/components/form.dart';
import 'package:examplesgn/credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerencianet/gerencianet.dart';

class PixDetailDevolution extends StatefulWidget {
  @override
  _PixDetailDevolutionState createState() => _PixDetailDevolutionState();
}

class _PixDetailDevolutionState extends State<PixDetailDevolution> {
  TextEditingController _e2eIdController = new TextEditingController();
  TextEditingController _idController = new TextEditingController();
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
        child: Padding(
            padding: EdgeInsets.only(top: 15, left: 5, right: 5),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _form(_formE2eId()),
                    _form(_formId()),
                  ],
                ))));
  }

  Widget _form(Widget form) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 50, top: 15),
        child: form);
  }

  Widget _formId() {
    return FormDataField(
      helperText: "Id gerado para representar unicamente uma devolução.",
      label: "Id*",
      line: 1,
      controller: _idController,
      textInputType: TextInputType.text,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formE2eId() {
    return Row(
      children: [
        Expanded(
            child: FormDataField(
          helperText: "EndToEndIdentification",
          label: "e2eid*",
          line: 1,
          controller: _e2eIdController,
          textInputType: TextInputType.text,
          validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
        )),
        IconButton(
            icon: Icon(Icons.remove_red_eye, color: Color(0xFF00b4c5)),
            onPressed: () {
              Navigator.pushNamed(context, "pix/received/list");
            }),
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
              _pixDetailDevolution();
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
                "BUSCAR",
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
      title: Text("Consultar Devolução"),
      centerTitle: true,
      actions: [
        _buttonInfo(
            "Consultar devolução",
            "Endpoint para consultar uma devolução através de um End To End ID do Pix e do ID da devolução GET /v2/pix/{e2eId}/devolucao/{id}.\n\n",
            Colors.white)
      ],
    );
  }

  void _pixDetailDevolution() {
    setState(() => _loading = true);

    Map<String, dynamic> params = {
      "e2eId": _e2eIdController.text,
      "id": _idController.text,
    };
    gn.call("pixDetailDevolution", params: params).then((value) {
      setState(() => _loading = false);
      _showInfoDevolution(value);
    }).catchError((error) {
      setState(() => _loading = false);
      _showMessage(
          error.toString(), Colors.red, MediaQuery.of(context).size.height);
    });
  }

  void _showInfoDevolution(value) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: Text("Devolução ${value['id']}"),
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
                    _info("${value['id'].toString()}", "ID", true),
                    _info("${value['valor']}", "VALOR", true),
                    _info("${value['status']}", "STATUS", false),
                    _info("${value['rtrId']}", "RTRID", false),
                    _info("${value['horario']['solicitacao']}", "SOLICITAÇÃO",
                        false),
                    _info("${value['horario']['liquidacao']}", "LIQUIDAÇÃO",
                        false),
                    Divider(
                      color: Theme.of(context).primaryColor,
                      height: 2,
                    ),
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
}
