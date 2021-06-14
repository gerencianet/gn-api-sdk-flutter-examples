import 'package:examplesgn/components/form.dart';
import 'package:examplesgn/credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerencianet/gerencianet.dart';

class PixDetail extends StatefulWidget {
  @override
  _PixDetailState createState() => _PixDetailState();
}

class _PixDetailState extends State<PixDetail> {
  TextEditingController _e2eIdController = new TextEditingController();
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
        child: Form(key: _formKey, child: _form(_formTxId())));
  }

  Widget _form(Widget form) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 50, top: 15),
        child: form);
  }

  Widget _formTxId() {
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
              _pixDetail();
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
      title: Text("Consultar PIX"),
      centerTitle: true,
      actions: [
        _buttonInfo(
            "Consultar Pix",
            "Endpoint para consultar um Pix através de um e2eid GET /v2/pix/{e2eId}.\n\n",
            Colors.white)
      ],
    );
  }

  void _pixDetail() {
    setState(() => _loading = true);

    Map<String, dynamic> params = {
      "e2eId": _e2eIdController.text,
    };
    gn.call("pixDetail", params: params).then((value) {
      setState(() => _loading = false);
      _showInfoDetail(value);
    }).catchError((error) {
      setState(() => _loading = false);
      _showMessage(
          error.toString(), Colors.red, MediaQuery.of(context).size.height);
    });
  }

  void _showInfoDetail(dynamic value) {
    print(value);
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                title:
                    Text(value['endToEndId'], style: TextStyle(fontSize: 15)),
                centerTitle: true,
                actions: [
                  value.containsKey('devolucoes')
                      ? IconButton(
                          icon: Icon(Icons.monetization_on_outlined),
                          onPressed: () {
                            _showDevolutions(value['devolucoes']);
                          })
                      : Container()
                ],
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
                    _infoCharge("${value['endToEndId']}", "ENDTOENDID", true),
                    _infoCharge("${value['valor']}", "VALOR", true),
                    _infoCharge("${value['chave']}", "CHAVE", true),
                    _infoCharge("${value['horario']}", "HORÁRIO", false),
                  ],
                ),
              ));
        });
  }

  void _showDevolutions(value) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: Text("Devoluções"),
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
                    for (var devolution in value)
                      Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Column(
                          children: [
                            _infoCharge(
                                "${devolution['id'].toString()}", "ID", true),
                            _infoCharge(
                                "${devolution['valor']}", "VALOR", true),
                            _infoCharge(
                                "${devolution['status']}", "STATUS", false),
                            _infoCharge(
                                "${devolution['rtrId']}", "RTRID", false),
                            _infoCharge(
                                "${devolution['horario']['solicitacao']}",
                                "SOLICITAÇÃO",
                                false),
                            _infoCharge(
                                "${devolution['horario']['liquidacao']}",
                                "LIQUIDAÇÃO",
                                false),
                            Divider(
                              color: Theme.of(context).primaryColor,
                              height: 2,
                            )
                          ],
                        ),
                      )
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
