import 'package:examplesgn/credentials.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerencianet/gerencianet.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Gerencianet _gn;
  bool _showBalance = false;
  String _balanceValue = "";

  @override
  void initState() {
    super.initState();
    this._gn = Gerencianet(CREDENTIALS);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      drawer: _drawer(),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerBody(),
        _balance(),
        _shortcut("Atalhos Transação", [
          {"title": "Criar", "subtitle": "Transação", "route": "charge/create"},
          {
            "title": "Consultar",
            "subtitle": "Transação",
            "route": "charge/detail"
          },
          {
            "title": "Associar Boleto",
            "subtitle": "Transação",
            "route": "charge/pay/billet"
          },
        ]),
        _shortcut("Atalhos Carnês", [
          {"title": "Criar", "subtitle": "Carnê", "route": "carnet/create"},
          {"title": "Cancelar", "subtitle": "Carnê", "route": "carnet/detail"},
          {
            "title": "Reenviar Parcela",
            "subtitle": "Carnê",
            "route": "carnet/parcel/resend"
          },
        ]),
        _shortcut("Atalho Notificação", [
          {
            "title": "Consultar",
            "subtitle": "Notificação",
            "route": "notification/get"
          },
        ]),
        _shortcut("Atalhos Assinatura", [
          {
            "title": "Criar",
            "subtitle": "Assinatura",
            "route": "subscription/create"
          },
          {
            "title": "Criar",
            "subtitle": "Plano",
            "route": "subscription/plan/create"
          },
          {
            "title": "Listar",
            "subtitle": "Planos",
            "route": "subscription/plan/list"
          },
        ]),
        _shortcut("Atalho Outros", [
          {
            "title": "Consultar",
            "subtitle": "Parcelas",
            "route": "others/installments"
          },
        ]),
        _shortcut("Atalhos GN", [
          {
            "title": "Visualizar Configuração",
            "subtitle": "CONTA",
            "route": "gn/account/settings/detail"
          },
          {"title": "Criar", "subtitle": "CHAVE", "route": "gn/key/create"},
          {"title": "Listar", "subtitle": "CHAVE", "route": "gn/key/list"},
        ]),
        _shortcut("Atalhos Pix", [
          {
            "title": "Criar Cobrança",
            "subtitle": "PIX",
            "route": "pix/charge/create"
          },
          {"title": "Listar", "subtitle": "PIX", "route": "pix/charge/list"},
          {
            "title": "Consultar WebHook",
            "subtitle": "PIX",
            "route": "pix/webhook/list"
          },
        ]),
      ],
    );
  }

  Widget _balance() {
    return Container(
      height: 45,
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Saldo disponível", style: TextStyle(color: Color(0xFF848484))),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            height: 28,
            width: 100,
            child: Center(
              child: _balanceValue != "" && _showBalance
                  ? Text(
                      "R\$ $_balanceValue",
                      style: TextStyle(fontSize: 20),
                    )
                  : Container(),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: _balanceValue != "" && _showBalance
                  ? Colors.white
                  : Color(0xFF848484).withOpacity(0.3),
            ),
          ),
          IconButton(
              enableFeedback: false,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              color: Colors.white,
              icon: Icon(
                  _showBalance
                      ? Icons.remove_red_eye_rounded
                      : Icons.remove_red_eye_outlined,
                  size: 20,
                  color: Theme.of(context).accentColor),
              onPressed: _getBalanceValue)
        ],
      ),
    );
  }

  Widget _shortcut(String title, List options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleBody(title),
        Row(
          children: [
            for (var option in options)
              _contentShortcut(
                  option['title'], option['subtitle'], option['route']),
          ],
        )
      ],
    );
  }

  Widget _contentShortcut(String title, String subtitle, String route) {
    return Expanded(
        child: GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        margin: EdgeInsets.all(2),
        color: Colors.white,
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                  color: Color(0xFF848484),
                  fontSize: 12,
                  fontWeight: FontWeight.w300),
            ),
            Text(
              subtitle.toUpperCase(),
              style: TextStyle(color: Color(0xFF00b4c5), fontSize: 13),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _titleBody(String title) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Text(title,
          style: TextStyle(color: Color(0xFF848484)),
          textAlign: TextAlign.start),
    );
  }

  Widget _headerBody() {
    return Container(
        height: 110,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: EdgeInsets.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Olá, Seja Bem Vindo!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Este app contém exemplos das funcionalidades disponíveis \n do plugin Gerencianet para Flutter",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ));
  }

  Widget _drawer() {
    return Drawer(
        child: Padding(
      padding: EdgeInsets.only(top: 30),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _menuOption("", [
            {
              "title": "Transação",
              "items": [
                {'title': 'Criar', 'route': 'charge/create'},
                {'title': 'Criar c/ Boleto', 'route': 'charge/create/billet'},
                {'title': 'Criar c/ Cartão', 'route': 'charge/create/card'},
                {'title': 'Consultar', 'route': 'charge/detail'},
                {'title': 'Cancelar', 'route': 'charge/cancel'},
                {'title': 'Marcar Como Pago', 'route': 'charge/settle'},
                {
                  'title': 'Acrescentar Histórico',
                  'route': 'charge/historic/create'
                },
                {'title': 'Reenviar', 'route': 'charge/resend'},
                {'title': 'Atualizar', 'route': 'charge/update'},
                {
                  'title': 'Atualizar Metadata',
                  'route': 'charge/update/metadata'
                },
                {'title': 'Associar Boleto', 'route': 'charge/pay/billet'},
                {'title': 'Associar Cartão', 'route': 'charge/pay/card'},
                {'title': 'Criar Link', 'route': 'charge/link'},
                {'title': 'Atualizar Link', 'route': 'charge/link/update'},
                {'title': 'Reenviar Link', 'route': 'charge/link/resend'},
              ]
            }
          ]),
          _menuOption("", [
            {
              "title": "Carnês",
              "items": [
                {'title': 'Criar', 'route': 'carnet/create'},
                {'title': 'Cancelar', 'route': 'carnet/cancel'},
                {'title': 'Reenviar', 'route': 'carnet/resend'},
                {'title': 'Consultar', 'route': 'carnet/detail'},
                {'title': 'Atualizar Metadata', 'route': 'carnet/update'},
                {
                  'title': 'Acrescentar Histórico',
                  'route': 'carnet/historic/create'
                },
                {'title': 'Marcar Como Pago', 'route': 'carnet/settle'},
                {'title': 'Cancelar Parcela', 'route': 'carnet/parcel/cancel'},
                {'title': 'Reenviar Parcela', 'route': 'carnet/parcel/resend'},
                {
                  'title': 'Marcar Como Pago (Parcela)',
                  'route': 'carnet/parcel/settle'
                },
                {'title': 'Atualizar Parcela', 'route': 'carnet/parcel/update'},
              ]
            },
          ]),
          _menuOption("", [
            {
              "title": "Notificações",
              "items": [
                {'title': 'Obter', 'route': 'notification/get'},
              ]
            }
          ]),
          _menuOption("", [
            {
              "title": "Assinaturas",
              "items": [
                {'title': 'Criar Plano', 'route': 'subscription/plan/create'},
                {'title': 'Listar Planos', 'route': 'subscription/plan/list'},
                {
                  'title': 'Atualizar Plano',
                  'route': 'subscription/plan/update'
                },
                {'title': 'Deletar Plano', 'route': 'subscription/plan/delete'},
                {'title': 'Criar Assinatura', 'route': 'subscription/create'},
                {
                  'title': 'Consultar Assinatura',
                  'route': 'subscription/detail'
                },
                {
                  'title': 'Cancelar Assinatura',
                  'route': 'subscription/cancel'
                },
                {
                  'title': 'Atualizar Assinatura',
                  'route': 'subscription/update'
                },
                {
                  'title': 'Assinatura - Boleto',
                  'route': 'subscription/pay/billet'
                },
                {
                  'title': 'Acrescentar Histórico Assinatura',
                  'route': 'subscription/historic/create'
                },
              ]
            }
          ]),
          _menuOption("", [
            {
              "title": "Outros",
              "items": [
                {'title': 'Consultar Parcelas', 'route': 'others/installments'}
              ]
            }
          ]),
          _menuOption("GN", [
            {
              "title": "Conta",
              "items": [
                {'title': 'Saldo', 'route': 'gn/account/balance'},
                {
                  'title': 'Consultar Configurações',
                  'route': 'gn/account/settings/detail'
                },
                {
                  'title': 'Modificar Configurações',
                  'route': 'gn/account/settings/edit'
                }
              ]
            },
            {
              "title": "Chaves",
              "items": [
                {'title': 'Criar', 'route': 'gn/key/create'},
                {'title': 'Deletar', 'route': 'gn/key/delete'},
                {'title': 'Listar', 'route': 'gn/key/list'},
              ]
            }
          ]),
          _menuOption("PIX", [
            {
              "title": "Cobrança:",
              "items": [
                {'title': 'Criar', 'route': 'pix/charge/create'},
                {
                  'title': 'Criar Imediata',
                  'route': 'pix/charge/create/immediate'
                },
                {'title': 'Consultar', 'route': 'pix/charge/detail'},
                {'title': 'Listar', 'route': 'pix/charge/list'},
                {'title': 'Atualizar', 'route': 'pix/charge/update'}
              ]
            },
            {
              "title": "Location:",
              "items": [
                {'title': 'Criar', 'route': 'pix/location/create'},
                {'title': 'Consultar', 'route': 'pix/location/detail'},
                {'title': 'Gerar QrCode', 'route': 'pix/location/qrcode'},
                {'title': 'Listar', 'route': 'pix/location/list'},
                {'title': 'Desvincular', 'route': 'pix/location/unset'}
              ]
            },
            {
              "title": "Pix:",
              "items": [
                {'title': 'Consultar', 'route': 'pix/detail'},
                {
                  'title': 'Consultar Devolução',
                  'route': 'pix/devolution/detail'
                },
                {'title': 'Solicitar Devolução', 'route': 'pix/devolution'},
                {'title': 'Listar Recebidos', 'route': 'pix/received'},
                {'title': 'Enviar', 'route': 'pix/send'}
              ]
            },
            {
              "title": "Webhook:",
              "items": [
                {'title': 'Deletar', 'route': 'pix/webhook/delete'},
                {'title': 'Consultar', 'route': 'pix/webhook/detail'},
                {'title': 'Listar', 'route': 'pix/webhook/list'},
                {'title': 'Configurar', 'route': 'pix/webhook/config'},
              ]
            },
          ]),
        ],
      ),
    ));
  }

  Widget _menuOption(String title, List options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: 2, color: Colors.white.withOpacity(0.5)),
        title != ""
            ? Container(
                padding: EdgeInsets.only(left: 15, top: 15),
                child: Text(title.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5), fontSize: 18)),
              )
            : Container(),
        for (var option in options)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: title != "" ? 28 : 15, top: 15),
                child: Text(option['title'].toUpperCase(),
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: title != "" ? 14 : 18)),
              ),
              for (var item in option['items'])
                ListTile(
                  leading: Padding(
                    padding: EdgeInsets.only(top: 5, left: 12),
                    child:
                        Image.asset('assets/images/icon-logo.png', height: 15),
                  ),
                  title: new Text(
                    item['title'],
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, item['route']);
                  },
                ),
            ],
          )
      ],
    );
  }

  Widget _appBar() {
    return AppBar(
      elevation: 0,
      title: Image.asset('assets/images/logo.png', height: 25),
      centerTitle: true,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Image.asset("assets/images/icon-logo.png", height: 20),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        },
      ),
      actions: [
        IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, "settings");
            })
      ],
    );
  }

  void _getBalanceValue() async {
    dynamic response = await this._gn.call('gnDetailBalance');
    this._balanceValue = response['saldo'];
    setState(() => this._showBalance = !this._showBalance);
  }
}
