import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../anaview.dart';
import 'sac-usa-eu-data.dart';

class AvrupaProductView extends StatelessWidget {
  const AvrupaProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
            100.0), // Yükseklik değerini burada belirleyebilirsiniz
        child: AppBar(
          //  actions: [
          //   IconButton(
          //       onPressed: () {},
          //       icon: const Icon(Icons.qr_code_scanner_outlined))
          // ],
          toolbarHeight: 100,
          centerTitle: false,
          title: const Text('Ürün Seç'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: context.paddingLow,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AreaContainer(
                onTap: () => context.navigateToPage(hacUsaEu(
                  isAvrupa: true,
                  appbarTitle: "Sıcak Haddelenmiş Sac Fiyatı",
                  title: "Sıcak Haddelenmiş Sac",
                  href: "avrupasicakhac",
                )),
                image:
                    "soguksac.png",
                title: "Sıcak Haddelenmiş Sac Fiyatı",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
