import 'package:examplesgn/components/form.dart';
import 'package:examplesgn/credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerencianet/gerencianet.dart';

class CreateChargeCard extends StatefulWidget {
  @override
  _CreateChargeCardState createState() => _CreateChargeCardState();
}

class _CreateChargeCardState extends State<CreateChargeCard> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _cpfController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _paymentTokenController = new TextEditingController();
  TextEditingController _streetController = new TextEditingController();
  TextEditingController _numberController = new TextEditingController();
  TextEditingController _neighborhoodController = new TextEditingController();
  TextEditingController _zipcodeController = new TextEditingController();
  TextEditingController _cityController = new TextEditingController();
  TextEditingController _stateController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _birthController = new TextEditingController();
  TextEditingController _nameItemController = new TextEditingController();
  TextEditingController _amountController = new TextEditingController();
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
                _headerForm("Item",
                    "Os campos abaixo são referentes ao item a ser associado a transação.\n"),
                _form(_formNameItem()),
                _form(_formAmount()),
                _form(_formValue()),
                _headerForm("Endereço",
                    "Os campos abaixo são referentes ao endereço da cobrança."),
                _form(_formStreet()),
                _form(_formNumber()),
                _form(_formNeighborhood()),
                _form(_formZipcode()),
                _form(_formCity()),
                _form(_formState()),
                _headerForm("Cliente",
                    "Os campos abaixo são referentes ao cliente a ser vinculado a transação."),
                _form(_formName()),
                _form(_formEmail()),
                _form(_formBirth()),
                _form(_formCpf()),
                _form(_formPhone()),
                _headerForm("Cartão",
                    "O campo abaixo é referente ao token de pagamento gerado para pagamentos com cartão."),
                _form(_formPaymentToken()),
                Container(height: 100)
              ],
            )));
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
      helperText: "Valor do item, produto ou serviço. (1000 = R\$ 10,00)",
      label: "Valor*",
      hintText: "ex: 1000",
      line: 1,
      controller: _valueController,
      textInputType: TextInputType.number,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formNameItem() {
    return FormDataField(
      helperText: "Nome do item, produto ou serviço.",
      label: "Nome*",
      hintText: "Ex: Transação item 1",
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

  Widget _formBirth() {
    return FormDataField(
      helperText: "Data de nascimento do cliente (yyyy-mm-dd)",
      label: "Data de Nascimento*",
      hintText: "ex: 1977-01-15",
      line: 1,
      controller: _birthController,
      textInputType: TextInputType.number,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formEmail() {
    return FormDataField(
      helperText: "Email do cliente",
      label: "Email*",
      hintText: "ex: oldbuck@gerencianet.com.br",
      line: 1,
      controller: _emailController,
      textInputType: TextInputType.emailAddress,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formState() {
    return FormDataField(
      helperText: "Estado do endereço",
      label: "Estado*",
      hintText: "ex: MG",
      line: 1,
      controller: _stateController,
      textInputType: TextInputType.text,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formCity() {
    return FormDataField(
      helperText: "Cidade do endereço",
      label: "Cidade*",
      hintText: "ex: Ouro Preto",
      line: 1,
      controller: _cityController,
      textInputType: TextInputType.text,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formZipcode() {
    return FormDataField(
      helperText: "CEP do endereço (somente número)",
      label: "CEP*",
      hintText: "ex: 35400000",
      line: 1,
      controller: _zipcodeController,
      textInputType: TextInputType.number,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formNeighborhood() {
    return FormDataField(
      helperText: "Bairro do endereço",
      label: "Bairro*",
      hintText: "ex: Bauxita",
      line: 1,
      controller: _neighborhoodController,
      textInputType: TextInputType.text,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formNumber() {
    return FormDataField(
      helperText: "Número do endereço",
      label: "Número*",
      hintText: "ex: 123",
      line: 1,
      controller: _numberController,
      textInputType: TextInputType.text,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formStreet() {
    return FormDataField(
      helperText: "Rua do endereço",
      label: "Rua*",
      hintText: "ex: Av. JK",
      line: 1,
      controller: _streetController,
      textInputType: TextInputType.text,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formPaymentToken() {
    return FormDataField(
      helperText: "Token de pagamento",
      label: "PaymentToken*",
      line: 1,
      controller: _paymentTokenController,
      textInputType: TextInputType.text,
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
              _oneStep();
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
      title: Text("Criar Transação Cartão"),
      centerTitle: true,
      actions: [
        _buttonInfo(
            "Criar Transação Cartão",
            "Criar nova transação com pagador atribuido (cartão).\n\n",
            Colors.white)
      ],
    );
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

  void _oneStep() {
    setState(() => _loading = true);
    Map<String, dynamic> body = {
      "items": [
        {
          "name": _nameItemController.text,
          "value": int.parse(_valueController.text),
          "amount": int.parse(_amountController.text)
        }
      ],
      "payment": {
        "credit_card": {
          "installments": 1,
          "payment_token": _paymentTokenController.text,
          "billing_address": {
            "street": _streetController.text,
            "number": int.parse(_numberController.text),
            "neighborhood": _neighborhoodController.text,
            "zipcode": _zipcodeController.text,
            "city": _cityController.text,
            "state": _stateController.text
          },
          "customer": {
            "name": _nameController.text,
            "email": _emailController.text,
            "cpf": _cpfController.text,
            "birth": _birthController.text,
            "phone_number": _phoneController.text
          }
        }
      }
    };

    gn.call("oneStep",  body: body).then((value) {
      setState(() => _loading = false);
      _showMessage("Transação Criada!", Theme.of(context).accentColor,
          MediaQuery.of(context).size.height);
    }).catchError((error) {
      setState(() => _loading = false);
      _showMessage(
          error.toString(), Colors.red, MediaQuery.of(context).size.height);
    });
  }
}
