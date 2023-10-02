import 'package:demircelik/views/anaview.dart';
import 'package:demircelik/views/eu-usa-scrap(sac)/sac-usa-eu-data.dart';
import 'package:demircelik/views/usa-ch-scrap(hurda)/hurda-us-ch-data.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../defiyat-tr/tr-data.dart';

class AmerikaProductView extends StatelessWidget {
  const AmerikaProductView({super.key});

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
      body: Padding(
        padding: context.paddingLow,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AreaContainer(
                onTap: () => context.navigateToPage(hacUsaEu(
                  isAvrupa: false,
                  appbarTitle: "Sıcak Haddelenmiş Sac Fiyatı",
                  title: "Sıcak Haddelenmiş Sac",  
                  href: "usasicakhac",
                )),
                image:
                    "sicaksac.png",
                title: "Sıcak Haddelenmiş Sac Fiyatı",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(hacUsaEu(
                  isAvrupa: false,
                  appbarTitle: "Soğuk Haddelenmiş Sac Fiyatı",
                  title: "Soğuk Haddelenmiş Sac",
                  href: "usasogukhac",
                )),
                image:
                    "soguksac.png",
                title: "Soğuk Haddelenmiş Sac",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(UsAndChinaScrapmons(
                  isUSA: true,
                  appbarTitle: "Çelik Hurda Fiyatı",
                  title: "Çelik Hurda",
                  href:
                      "https://www.scrapmonster.com/prices/united-states-1-hms-price-history-chart-1-44",
                )),
                image: "ithalhurda.png",
                title: "Çelik Hurda Fiyatı",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
