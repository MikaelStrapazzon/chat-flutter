import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../components/appBars/DefaultAppBar/default_app_bar.dart';

class QrCodePage extends StatefulWidget {
  final String idUser;

  const QrCodePage({super.key, required this.idUser});

  @override
  _QrCodePageState createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const DefaultAppBar(
            title: 'Exportar Contato', showBackButton: true),
        body: Center(
            child: QrImageView(
          data: widget.idUser,
          version: QrVersions.auto,
          size: 200.0,
          gapless: true,
          errorCorrectionLevel: QrErrorCorrectLevel.Q,
        )));
  }
}
