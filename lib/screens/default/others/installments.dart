import 'package:examplesgn/components/form.dart';
import 'package:examplesgn/credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerencianet/gerencianet.dart';

class Installments extends StatefulWidget {
  @override
  _InstallmentsState createState() => _InstallmentsState();
}

class _InstallmentsState extends State<Installments> {
  TextEditingController _brandController = new TextEditingController();
  TextEditingController _valueController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Gerencianet gn;
  bool _loading = false;

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
        bottomSheet: _bottomSheet(),
        backgroundColor: Theme.of(context).backgroundColor,
        body: _body());
  }

  Widget _body() {
    return SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                _headerForm("Bandeira",
                    "Bandeiras disponíveis: visa, mastercard, amex, elo e hipercard."),
                _form(_formBrand()),
                _headerForm("Valor", "Valor inteiro a ser listado as parcelas"),
                _form(_formValue()),
              ],
            )));
  }

  _headerForm(String title, String content) {
    return Container(
      margin: EdgeInsets.only(top: 15, right: 5, left: 5),
      color: Colors.white,
      padding: EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Row(
        children: [
          Expanded(
              child: Text(title,
                  style: TextStyle(color: Theme.of(context).primaryColor))),
          _buttonInfo(title, content, Color(0xFF00b4c5))
        ],
      ),
    );
  }

  Widget _form(Widget form) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 50, top: 15),
        child: form);
  }

  Widget _formValue() {
    return FormDataField(
      helperText: "Valor a ser calculado",
      label: "Valor*",
      hintText: "Ex: 5000",
      line: 1,
      controller: _valueController,
      textInputType: TextInputType.number,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formBrand() {
    return FormDataField(
      helperText: "Bandeira cartão",
      label: "Bandeira*",
      hintText: "Ex: visa",
      line: 1,
      controller: _brandController,
      textInputType: TextInputType.text,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
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
              _installments();
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
                "CONSULTAR",
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
      title: Text("Consultar Parcelas"),
      centerTitle: true,
      actions: [
        _buttonInfo(
            "Consultar Parcelas",
            "O endpoint installments é utilizado para listar as parcelas de cada bandeira de cartão de crédito, já com os valores de juros e número de parcelas calculados de acordo com a conta integradora. Ou seja, se sua conta possui uma configuração de juros de cartão (opção disponível para clientes que optaram por receber valores de cartão de forma parcelada), não é necessário fazer nenhum cálculo, esse endpoint já informa os valores calculados.\n\n",
            Colors.white)
      ],
    );
  }

  void _showInfoDetail(dynamic value) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: Text("Parcelas"),
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
                    for (var installment in value['data']['installments'])
                      ListTile(
                        title: Text(
                            "${installment['installment']}x de R\$${installment['currency']}"),
                        subtitle: Text(
                            "Juros:  ${installment['interest_percentage'] / 100}%"),
                      )
                  ],
                ),
              ));
        });
  }

  void _installments() {
    setState(() => _loading = true);

    Map<String, dynamic> params = {
      "brand": _brandController.text,
      "total": _valueController.text,
    };
    gn.call("getInstallments", params: params).then((value) {
      setState(() => _loading = false);
      _showInfoDetail(value);
    }).catchError((error) {
      setState(() => _loading = false);
      _showMessage(
          error.toString(), Colors.red, MediaQuery.of(context).size.height);
    });
  }
}
