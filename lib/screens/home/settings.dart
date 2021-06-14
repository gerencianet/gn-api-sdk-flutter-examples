import 'package:examplesgn/components/form.dart';
import 'package:examplesgn/credentials.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController _clientIdController = new TextEditingController();
  TextEditingController _clientSecretController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _sandbox = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      bottomSheet: _bottomSheet(),
      backgroundColor: Theme.of(context).backgroundColor,
      body: _body(),
    );
  }

  @override
  void initState() {
    super.initState();
    _clientIdController.text = CREDENTIALS['client_id'];
    _clientSecretController.text = CREDENTIALS['client_secret'];
    _sandbox = CREDENTIALS['sandbox'];
  }

  Widget _body() {
    return SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.only(top: 15, left: 5, right: 5),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _form(_formClientId()),
                    _form(_formClientSecret()),
                    _checkForm(
                        Checkbox(
                            value: _sandbox,
                            onChanged: (bool newValue) {
                              setState(() => _sandbox = newValue);
                            }),
                        "Sandbox")
                  ],
                ))));
  }

  Widget _checkForm(Widget checkbox, String text) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 25),
      child: Row(
        children: [
          Expanded(child: Text(text)),
          SizedBox(height: 24.0, width: 24.0, child: checkbox),
        ],
      ),
    );
  }

  Widget _form(Widget form) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 50, top: 15),
        child: form);
  }

  Widget _formClientSecret() {
    return FormDataField(
      helperText: "Client Secret da aplicação",
      label: "Client Secret*",
      line: 1,
      controller: _clientSecretController,
      textInputType: TextInputType.text,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _formClientId() {
    return FormDataField(
      helperText: "Client ID da aplicação",
      label: "Client ID*",
      line: 1,
      controller: _clientIdController,
      textInputType: TextInputType.text,
      validator: (value) => value.isEmpty ? "Campo Obrigatório!" : null,
    );
  }

  Widget _appBar() {
    return AppBar(
      elevation: 0,
      title: Text("Configuração"),
      centerTitle: true,
    );
  }

  Widget _bottomSheet() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: TextButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          final FormState form = _formKey.currentState;
          if (form.validate()) {
            _update();
          } else {
            _showMessage("Preencha os campos obrigatórios!", Colors.red, 25);
          }
        },
        child: Text(
          "SALVAR",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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

  void _update() {
    CREDENTIALS['client_id'] = _clientIdController.text;
    CREDENTIALS['client_secret'] = _clientSecretController.text;
    CREDENTIALS['sandbox'] = _sandbox;
    _showMessage("Informações atualizadas!", Theme.of(context).accentColor,
        MediaQuery.of(context).size.height);
  }
}
