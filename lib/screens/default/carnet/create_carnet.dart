import 'package:examplesgn/components/form.dart';
import 'package:examplesgn/credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerencianet/gerencianet.dart';

class CreateCarnet extends StatefulWidget {
  @override
  _CreateCarnetState createState() => _CreateCarnetState();
}

class _CreateCarnetState extends State<CreateCarnet> {
  TextEditingController _nameItemController = new TextEditingController();
  TextEditingController _amountController = new TextEditingController();
  TextEditingController _valueController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _cpfController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _repeatsController = new TextEditingController();
  TextEditingController _expireDateController = new TextEditingController();
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
                _headerForm("Carnê",
                    "Os campos abaixo são referentes as informações do carnê.\n"),
                _form(_formRepeats()),
                _form(_formExpire()),
                _headerForm("Item",
                    "Os campos abaixo são referentes ao item a ser associado no carnê.\n"),
                _form(_formNameItem()),
                _form(_formAmount()),
                _form(_formValue()),
                _headerForm("Cliente",
                    "Os campos abaixo faz referência ao cliente a ser vinculado o carnê."),
                _form(_formName()),
                _form(_formCpf()),
                _form(_formPhone()),
                Container(height: 100)
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

  Widget _formRepeats() {
    return FormDataField(
      helperText: "Número de parcelas do carnê",
      label: "Parcelas*",
      hintText: "ex: 12",
      line: 1,
      controller: _repeatsController,
      textInputType: TextInputType.number,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formExpire() {
    return FormDataField(
      helperText: "Data de vencimento da primeira parcela (yyyy-mm-dd)",
      label: "Data de Vencimento*",
      hintText: "ex: 2021-07-06",
      line: 1,
      controller: _expireDateController,
      textInputType: TextInputType.datetime,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formNameItem() {
    return FormDataField(
      helperText: "Nome do item, produto ou serviço.",
      label: "Nome*",
      hintText: "Ex: Carnê item 1",
      line: 1,
      controller: _nameItemController,
      textInputType: TextInputType.text,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formAmount() {
    return FormDataField(
      helperText: "Quantidade do item, produto ou serviço",
      label: "Quantidade*",
      hintText: "ex: 1",
      line: 1,
      controller: _amountController,
      textInputType: TextInputType.number,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formValue() {
    return FormDataField(
      helperText: "Valor do item, produto ou serviço. (1000 = R\$ 10,00)",
      label: "Valor*",
      hintText: "ex: 1000",
      line: 1,
      controller: _valueController,
      textInputType: TextInputType.number,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formName() {
    return FormDataField(
      helperText: "Nome do cliente",
      label: "Nome*",
      hintText: "ex: Gorbadoc Oldbuck",
      line: 1,
      controller: _nameController,
      textInputType: TextInputType.text,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formCpf() {
    return FormDataField(
      helperText: "CPF do cliente (somente números)",
      label: "CPF*",
      hintText: "ex: 94271564656",
      line: 1,
      controller: _cpfController,
      textInputType: TextInputType.number,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formPhone() {
    return FormDataField(
      helperText: "Telefone do cliente (somente números)",
      label: "Telefone*",
      hintText: "ex: 5144916523",
      line: 1,
      controller: _phoneController,
      textInputType: TextInputType.number,
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
              _createCarnet();
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
      title: Text("Criar Carnê"),
      centerTitle: true,
      actions: [_buttonInfo("Criar Carnê", "Cria um carnê.\n\n", Colors.white)],
    );
  }

  void _createCarnet() {
    setState(() => _loading = true);

    Map<String, dynamic> body = {
      "expire_at": _expireDateController.text,
      "items": [
        {
          "name": _nameItemController.text,
          "value": int.parse(_valueController.text),
          "amount": int.parse(_amountController.text)
        }
      ],
      "customer": {
        "name": _nameController.text,
        "cpf": _cpfController.text,
        "phone_number": _phoneController.text
      },
      "repeats": int.parse(_repeatsController.text),
      "split_items": false
    };
    gn.call("createCarnet", body: body).then((value) {
      setState(() => _loading = false);
      _showMessage("Carnê Criado!", Theme.of(context).accentColor,
          MediaQuery.of(context).size.height);
    }).catchError((error) {
      setState(() => _loading = false);
      _showMessage(
          error.toString(), Colors.red, MediaQuery.of(context).size.height);
    });
  }
}
