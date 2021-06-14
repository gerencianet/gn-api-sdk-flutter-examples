import 'dart:convert';
import 'dart:typed_data';

import 'package:examplesgn/components/form.dart';
import 'package:examplesgn/credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerencianet/gerencianet.dart';

class PixGenerateQrcode extends StatefulWidget {
  @override
  _PixGenerateQrcodeState createState() => _PixGenerateQrcodeState();
}

class _PixGenerateQrcodeState extends State<PixGenerateQrcode> {
  TextEditingController _idController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Gerencianet gn;
  bool _loading = false;
  Uint8List _byteData;

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
        child: Column(
      children: [
        Form(key: _formKey, child: _form(_formTxId())),
        _byteData != null
            ? Center(
                child: Container(
                  margin: EdgeInsets.only(top: 100),
                  height: MediaQuery.of(context).size.width / 2,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Image.memory(_byteData.buffer.asUint8List()),
                ),
              )
            : Container()
      ],
    ));
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
          helperText: "Id da location cadastrada para servir um payload",
          label: "Id Location*",
          line: 1,
          controller: _idController,
          textInputType: TextInputType.text,
          validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
        )),
        IconButton(
            icon: Icon(Icons.remove_red_eye, color: Color(0xFF00b4c5)),
            onPressed: () {
              Navigator.pushNamed(context, "pix/location/list");
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
              _pixGenerateQRCode();
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
                "GERAR",
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
      title: Text("Gerar QrCode"),
      centerTitle: true,
      actions: [
        _buttonInfo(
            "Gerar QrCode de um location",
            "Endpoint para gerar QRCode de um location GET/v2​/loc/{id}/qrcode.\n\n",
            Colors.white)
      ],
    );
  }

  void _pixGenerateQRCode() {
    setState(() {
      _loading = true;
      _byteData = null;
    });

    Map<String, dynamic> params = {
      "id": _idController.text,
    };
    gn.call("pixGenerateQRCode", params: params).then((value) {
      setState(() => _loading = false);
      print(value);
      _showMessage("Operação Realizada!", Theme.of(context).accentColor,
          MediaQuery.of(context).size.height);
      this._byteData =
          Base64Decoder().convert(value['imagemQrcode'].split(',').last);
    }).catchError((error) {
      setState(() => _loading = false);
      _showMessage(
          error.toString(), Colors.red, MediaQuery.of(context).size.height);
    });
  }
}
