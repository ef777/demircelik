
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppMessageButton extends StatelessWidget {

  final String textim;

   WhatsAppMessageButton({
    required this.textim,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _sendWhatsAppMessage(context),
      child: Icon(Icons.message), 
    );
  }

  void _sendWhatsAppMessage(BuildContext context) async {
    var whatsappUrl = await
        "whatsapp://send?phone=+902165456000" +
            "&text=${Uri.encodeComponent(textim)}";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

}