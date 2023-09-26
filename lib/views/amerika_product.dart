import 'package:demircelik/views/area_and_product_view.dart';
import 'package:demircelik/views/hacUsa-Eu.dart';
import 'package:demircelik/views/scrap-Us-China.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import 'butunTurkiye.dart';

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
                    "https://www.atolye10.com/wp-content/uploads/2018/04/ahsap-dilim-kutuk.jpg",
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
                    "https://www.gundogdudemircelik.com/site_document/sayfa_img/CMARE6356_resim_16_6_2017_16_b.jpg",
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
                image: "https://ayescelik.com/images/kangal_demir_7.jpg",
                title: "Çelik Hurda Fiyatı",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
