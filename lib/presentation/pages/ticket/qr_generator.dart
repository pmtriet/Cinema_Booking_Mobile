import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGenerator extends StatelessWidget {
  const QRGenerator({super.key, required this.data});
  final String data;

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: 200,
      gapless: false,
      backgroundColor: Colors.white,
      embeddedImage: const AssetImage('assets/icons/logo.png'),
      embeddedImageStyle: const QrEmbeddedImageStyle(
        size: Size(100, 100),
      ),
      errorStateBuilder: (cxt, err) {
        return const Center(
          child: Text( 
            'Opps! Something went wrong...',
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
