import 'package:examplesgn/screens/default/carnet/cancel_carnet.dart';
import 'package:examplesgn/screens/default/carnet/cancel_parcel.dart';
import 'package:examplesgn/screens/default/carnet/create_carnet.dart';
import 'package:examplesgn/screens/default/carnet/create_carnet_history.dart';
import 'package:examplesgn/screens/default/carnet/detail_carnet.dart';
import 'package:examplesgn/screens/default/carnet/resend_carnet.dart';
import 'package:examplesgn/screens/default/carnet/resend_parcel.dart';
import 'package:examplesgn/screens/default/carnet/settle_carnet.dart';
import 'package:examplesgn/screens/default/carnet/settle_carnet_parcel.dart';
import 'package:examplesgn/screens/default/carnet/update_carnet_metadata.dart';
import 'package:examplesgn/screens/default/carnet/update_parcel.dart';
import 'package:examplesgn/screens/default/charge/cancel_charge.dart';
import 'package:examplesgn/screens/default/charge/create_charge.dart';
import 'package:examplesgn/screens/default/charge/create_charge_billet.dart';
import 'package:examplesgn/screens/default/charge/create_charge_card.dart';
import 'package:examplesgn/screens/default/charge/create_charge_history.dart';
import 'package:examplesgn/screens/default/charge/detail_charge.dart';
import 'package:examplesgn/screens/default/charge/link_charge.dart';
import 'package:examplesgn/screens/default/charge/pay_charge_billet.dart';
import 'package:examplesgn/screens/default/charge/pay_charge_card.dart';
import 'package:examplesgn/screens/default/charge/resend_charge.dart';
import 'package:examplesgn/screens/default/charge/resend_charge_link.dart';
import 'package:examplesgn/screens/default/charge/settle_charge.dart';
import 'package:examplesgn/screens/default/charge/update_charge.dart';
import 'package:examplesgn/screens/default/charge/update_charge_link.dart';
import 'package:examplesgn/screens/default/charge/update_charge_metadata.dart';
import 'package:examplesgn/screens/default/notifications/get_notification.dart';
import 'package:examplesgn/screens/default/others/installments.dart';
import 'package:examplesgn/screens/default/subscription/cancel_subscription.dart';
import 'package:examplesgn/screens/default/subscription/create_plan.dart';
import 'package:examplesgn/screens/default/subscription/create_subscription.dart';
import 'package:examplesgn/screens/default/subscription/create_subscription_history.dart';
import 'package:examplesgn/screens/default/subscription/delete_plan.dart';
import 'package:examplesgn/screens/default/subscription/detail_subscription.dart';
import 'package:examplesgn/screens/default/subscription/get_plans.dart';
import 'package:examplesgn/screens/default/subscription/pay_subscription_billet.dart';
import 'package:examplesgn/screens/default/subscription/update_plan.dart';
import 'package:examplesgn/screens/default/subscription/update_subscription_metadata.dart';
import 'package:examplesgn/screens/gn/account/detail_balance.dart';
import 'package:examplesgn/screens/gn/account/detail_settings.dart';
import 'package:examplesgn/screens/gn/account/edit_settings.dart';
import 'package:examplesgn/screens/gn/key/create_key.dart';
import 'package:examplesgn/screens/gn/key/delete_key.dart';
import 'package:examplesgn/screens/gn/key/list_key.dart';
import 'package:examplesgn/screens/home/settings.dart';
import 'package:examplesgn/screens/pix/charge/pix_create_immediate_charge.dart';
import 'package:examplesgn/screens/pix/charge/pix_detail_charge.dart';
import 'package:examplesgn/screens/pix/charge/pix_list_charges.dart';
import 'package:examplesgn/screens/pix/charge/pix_update_charge.dart';
import 'package:examplesgn/screens/pix/location/pix_create_location.dart';
import 'package:examplesgn/screens/pix/location/pix_detail_location.dart';
import 'package:examplesgn/screens/pix/location/pix_generate_qrcode.dart';
import 'package:examplesgn/screens/pix/location/pix_list_location.dart';
import 'package:examplesgn/screens/pix/pix/pix_detail.dart';
import 'package:examplesgn/screens/pix/pix/pix_detail_devolution.dart';
import 'package:examplesgn/screens/pix/pix/pix_devolution.dart';
import 'package:examplesgn/screens/pix/pix/pix_list_received.dart';
import 'package:examplesgn/screens/pix/pix/pix_send.dart';
import 'package:examplesgn/screens/pix/webhook/pix_config_webhook.dart';
import 'package:examplesgn/screens/pix/webhook/pix_delete_webhook.dart';
import 'package:examplesgn/screens/pix/webhook/pix_detail_webhook.dart';
import 'package:examplesgn/screens/pix/webhook/pix_list_webhook.dart';
import 'package:examplesgn/screens/pix/location/pix_unset_txid.dart';
import 'package:flutter/material.dart';
import 'package:examplesgn/screens/home/home.dart';
import 'package:examplesgn/screens/pix/charge/pix_create_charge.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerencianet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color(0xffff710f),
          backgroundColor: Color(0xfff5f5f5),
          accentColor: Color(0xFF00b4c5),
          canvasColor: Color(0xffff710f),
          textTheme: TextTheme(
            headline6: TextStyle(
                color: Color(0xffffffff),
                fontSize: 15,
                fontWeight: FontWeight.w400),
            headline5: TextStyle(
                color: Color(0xffffffff).withOpacity(0.7),
                fontSize: 17,
                fontWeight: FontWeight.w300),
          )),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        'settings': (context) => Settings(),

        'charge/detail': (context) => DetailCharge(),
        'charge/cancel': (context) => CancelCharge(),
        'charge/settle': (context) => SettleCharge(),
        'charge/historic/create': (context) => CreateChargeHistory(),
        'charge/resend': (context) => ResendCharge(),
        'charge/update': (context) => UpdateCharge(),
        'charge/update/metadata': (context) => UpdateChargeMetadata(),
        'charge/create': (context) => CreateCharge(),
        'charge/create/billet': (context) => CreateChargeBillet(),
        'charge/create/card': (context) => CreateChargeCard(),
        'charge/pay/billet': (context) => PayChargeBillet(),
        'charge/pay/card': (context) => PayChargeCard(),
        'charge/link': (context) => LinkCharge(),
        'charge/link/update': (context) => UpdateChargeLink(),
        'charge/link/resend': (context) => ResendChargeLink(),


        'carnet/create': (context) => CreateCarnet(),
        'carnet/cancel': (context) => CancelCarnet(),
        'carnet/parcel/cancel': (context) => CancelParcel(),
        'carnet/resend': (context) => ResendCarnet(),
        'carnet/parcel/resend': (context) => ResendParcel(),
        'carnet/historic/create': (context) => CreateCarnetHistory(),
        'carnet/settle': (context) => SettleCarnet(),
        'carnet/parcel/settle': (context) => SettleParcel(),
        'carnet/parcel/update': (context) => UpdateParcel(),
        'carnet/update': (context) => UpdateCarnetMetadata(),
        'carnet/detail': (context) => DetailCarnet(),





        'notification/get': (context) => GetNotification(),


        'subscription/plan/create': (context) => CreatePlan(),
        'subscription/plan/list': (context) => GetPlans(),
        'subscription/plan/update': (context) => UpdatePlan(),
        'subscription/plan/delete': (context) => DeletePlan(),
        'subscription/create': (context) => CreateSubscription(),
        'subscription/detail': (context) => DetailSubscription(),
        'subscription/cancel': (context) => CancelSubscription(),
        'subscription/update': (context) => UpdateSubscriptionMetadata(),
        'subscription/pay/billet': (context) => PaySubscriptionBillet(),
        'subscription/historic/create': (context) => CreateSubscriptionHistory(),



        'others/installments': (context) => Installments(),



        'gn/key/list': (context) => ListKey(),
        'gn/key/delete': (context) => DeleteKey(),
        'gn/key/create': (context) => CreateKey(),
        'gn/account/balance': (context) => DetailBalance(),
        'gn/account/settings/detail': (context) => DetailSettings(),
        'gn/account/settings/edit': (context) => EditSettings(),
        'pix/charge/detail': (context) => PixDetailCharge(),
        'pix/charge/create': (context) => PixCreateCharge(),
        'pix/charge/create/immediate': (context) => PixCreateImmediateCharge(),
        'pix/charge/list': (context) => PixListCharges(),
        'pix/charge/update': (context) => PixUpdateCharge(),
        'pix/location/list': (context) => PixListLocation(),
        'pix/location/unset': (context) => PixUnsetTxId(),
        'pix/location/qrcode': (context) => PixGenerateQrcode(),
        'pix/location/detail': (context) => PixDetailLocation(),
        'pix/location/create': (context) => PixCreateLocation(),
        'pix/received': (context) => PixListReceived(),
        'pix/detail': (context) => PixDetail(),
        'pix/send': (context) => PixSend(),
        'pix/devolution': (context) => PixDevolution(),
        'pix/devolution/detail': (context) => PixDetailDevolution(),
        'pix/webhook/list': (context) => PixListWebhook(),
        'pix/webhook/detail': (context) => PixDetailWebhook(),
        'pix/webhook/delete': (context) => PixDeleteWebhook(),
        'pix/webhook/config': (context) => PixConfigWebhook(),

      },
    );
  }
}
