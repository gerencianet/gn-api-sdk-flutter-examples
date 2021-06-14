
import 'package:examplesgn/components/form.dart';
import 'package:examplesgn/credentials.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerencianet/gerencianet.dart';

class PixCreateImmediateCharge extends StatefulWidget {
  @override
  _PixCreateImmediateChargeState createState() => _PixCreateImmediateChargeState();
}

class _PixCreateImmediateChargeState extends State<PixCreateImmediateCharge> {
  TextEditingController _expireController = new TextEditingController();
  TextEditingController _cpfController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _valueController = new TextEditingController();
  TextEditingController _keyController = new TextEditingController();
  TextEditingController _infoController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
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
        bottomSheet: _bottomSheet(),
        body: SingleChildScrollView(
          child: _body(),
        ));
  }

  Widget _body() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            _headerForm(
                "Calendário",
                "Os campos aninhados sob o identificador calendário organizam "
                    "informações a respeito de controle de tempo da cobrança."),
            _form(_formExpire()),
            _headerForm(
                "Devedor",
                "Os campos aninhados sob o objeto devedor são opcionais e "
                    "identificam o devedor, ou seja, a pessoa ou a instituição "
                    "a quem a cobrança está endereçada. Não identifica, "
                    "necessariamente, quem irá efetivamente realizar o pagamento. "
                    "Um CPF pode ser o devedor de uma cobrança, mas pode "
                    "acontecer de outro CPF realizar, efetivamente, o pagamento "
                    "do documento. Não é permitido que o campo pagador.cpf e "
                    "campo pagador.cnpj estejam preenchidos ao mesmo tempo. "
                    "Se o campo pagador.cnpj está preenchido, então o campo "
                    "pagador.cpf não pode estar preenchido, e vice-versa. Se o"
                    " campo pagador.nome está preenchido, então deve existir ou "
                    "um pagador.cpf ou um campo pagador.cnpj preenchido"),
            _form(_formName()),
            _form(_formCpf()),
            _headerForm(
                "Valor",
                "Todos os campos que indicam valores monetários obedecem ao "
                    "formato do ID 54 da especificação EMV/BR Code para QR "
                    "Codes. O separador decimal é o caractere ponto. Não é "
                    "aplicável utilizar separador de milhar. Exemplos de "
                    "valores aderentes ao padrão: “0.00”, “1.00”, “123.99”, "
                    "“123456789.23”"),
            _form(_formValue()),
            _headerForm(
                "Chave",
                "O campo chave, obrigatório, determina a chave Pix registrada "
                    "no DICT que será utilizada para a cobrança. Essa chave "
                    "será lida pelo aplicativo do PSP do pagador para consulta "
                    "ao DICT, que retornará a informação que identificará o "
                    "recebedor da cobrança."),
            _form(_formKeyPix()),
            _headerForm(
                "Solicitação Pagador",
                "O campo solicitacaoPagador, opcional, determina um texto a ser "
                    "apresentado ao pagador para que ele possa digitar uma "
                    "informação correlata, em formato livre, a ser enviada ao "
                    "recebedor. Esse texto será preenchido, na pacs.008, pelo "
                    "PSP do pagador, no campo RemittanceInformation . O tamanho "
                    "do campo na pacs.008 está limitado a 140 caracteres."),
            _form(_formText()),
            Container(height: 100)
          ],
        ));
  }

  Widget _form(Widget form) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 50, top: 15),
        child: form);
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

  Widget _formText() {
    return FormDataField(
      helperText: "Texto a ser apresentado ao pagador ",
      label: "Informação adicional",
      hintText: "Ex: emailcliente@servidor.com.br",
      line: 3,
      controller: _infoController,
      textInputType: TextInputType.text,
    );
  }

  Widget _formKeyPix() {
    return Row(
      children: [
        Expanded(
            child: FormDataField(
          helperText: "Chave pix vinculada a Gerencianet",
          label: "Chave*",
          hintText: "Ex: emailcliente@servidor.com.br",
          line: 1,
          controller: _keyController,
          textInputType: TextInputType.text,
          validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
        )),
        IconButton(
            icon: Icon(Icons.remove_red_eye, color: Color(0xFF00b4c5)),
            onPressed: () {
              Navigator.pushNamed(context, "gn/key/list");
            }),
      ],
    );
  }

  Widget _formValue() {
    return FormDataField(
      label: "Valor*",
      helperText: " Valor original da cobrança",
      hintText: "Ex: 0.01",
      line: 1,
      controller: _valueController,
      textInputType: TextInputType.number,
      validator: (value) => value.isEmpty ? 'Campo Obrigatório!' : null,
    );
  }

  Widget _formName() {
    return FormDataField(
      label: "Nome",
      helperText: "Nome do usuário pagador",
      hintText: "Ex: Gorbadoc Oldbuck",
      line: 1,
      controller: _nameController,
      textInputType: TextInputType.name,
      validator: (value) => _cpfController.text != "" && value.isEmpty
          ? 'Campo Obrigatório!'
          : null,
    );
  }

  Widget _formCpf() {
    return FormDataField(
      label: "CPF",
      helperText: "CPF do usuário pagador",
      hintText: "Ex: 64790842096",
      line: 1,
      controller: _cpfController,
      textInputType: TextInputType.number,
      validator: (value) => _nameController.text != "" && value.isEmpty
          ? 'Campo Obrigatório!'
          : null,
    );
  }

  Widget _formExpire() {
    return FormDataField(
      label: "Expiração*",
      helperText: "Tempo de vida da cobrança em segundos",
      hintText: "Ex: 3600",
      line: 1,
      controller: _expireController,
      textInputType: TextInputType.number,
      validator: (value) => value.isEmpty ? 'Campo Obrigatório!' : null,
    );
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
            if (form.validate()) {
              _pixCreateImmediateCharge();
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
      title: Text("Criar Cobrança Pix Imediata"),
      centerTitle: true,
      actions: [
        _buttonInfo(
            "Criar cobrança Imediata",
            "Endpoint para criar uma cobrança imediata sem informar o txid. Neste caso, o txid deve ser definido pelo PSP. POST /v2/cob.\n\n",
            Colors.white)
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

  dynamic _pixCreateImmediateCharge() async {
    setState(() => _loading = true);

    dynamic body = {
      "calendario": {"expiracao": int.parse(_expireController.text)},
      "valor": {"original": _valueController.text.toString()},
      "chave": _keyController.text,
    };

    if (_infoController.text != "")
      body["solicitacaoPagador"] = _infoController.text;

    if (_nameController.text != "" && _cpfController.text != "")
      body["devedor"] = {
        "cpf": _cpfController.text,
        "nome": _nameController.text,
      };

    gn.call('pixCreateImmediateCharge', body: body).then((value) {
      setState(() => _loading = false);
      _showMessage("Cobrança Pix Criada!", Theme.of(context).accentColor,
          MediaQuery.of(context).size.height);
    }).catchError((error) {
      setState(() => _loading = false);
      _showMessage(
          error.toString(), Colors.red, MediaQuery.of(context).size.height);
    });
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

}
