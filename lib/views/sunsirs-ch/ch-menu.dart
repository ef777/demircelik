import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../eu-usa-scrap(sac)/eu-menu.dart';
import '../anaview.dart';
import '../eu-usa-scrap(sac)/sac-usa-eu-data.dart';
import '../usa-ch-scrap(hurda)/hurda-us-ch-data.dart';
import 'ch-data.dart';

class CinProductView extends StatelessWidget {
  const CinProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
            100.0), // Yükseklik değerini burada belirleyebilirsiniz
        child: AppBar(
         
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
                onTap: () => context.navigateToPage(ChinaData(
                  appbarTitle: "Sıcak Haddelenmiş Sac Fiyatı",
                  title: "Sıcak Haddelenmiş Sac",
                  href: "http://www.sunsirs.com/tr/prodetail-195.html",
                )),
                image:
                    "sicaksac.png",
                title: "Sıcak Haddelenmiş Sac Fiyatı",
              ),
                AreaContainer(
                onTap: () => context.navigateToPage(ChinaData(
                  appbarTitle: "Soğuk Haddelenmiş Sac Fiyatı",
                  title: "Soğuk Haddelenmiş Sac",
                  href: "http://www.sunsirs.com/tr/prodetail-318.html",
                )),
                image:
                    "soguksac.png",
                title: "Soğuk Haddelenmiş Sac Fiyatı",
              ),
                AreaContainer(
                onTap: () => context.navigateToPage(ChinaData(
                  appbarTitle: "Galvaniz Sac Fiyatı",
                  title: "Galvaniz Sac",
                  href: "http://www.sunsirs.com/tr/prodetail-301.html",
                )),
                image:
                    "galvanizsac.png",
                title: "Galvaniz Sac Fiyatı",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(UsAndChinaScrapmons(
                  appbarTitle: "Çelik Hurda Fiyatı",
                  title: "Çelik Hurda ",
                  href:
                      "https://www.scrapmonster.com/steel-prices/cold-rolled-coil-prices/594",
                  isUSA: false,
                )),
                image: "ithalhurda.png",
                title: "Çelik Hurda Fiyatı ",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(ChinaData(
                  appbarTitle: "Boyalı Sac Fiyatı",
                  title: "Boyalı Sac",
                  href: "http://www.sunsirs.com/tr/prodetail-300.html",
                )),
                image: "boyali-sac.jpg",
                title: "Boyalı Sac Fiyatı",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(ChinaData(
                  appbarTitle: "Paslanmaz Çelik Sac Fiyatı",
                  title: "Paslanmaz Çelik Sac",
                  href: "http://www.sunsirs.com/tr/prodetail-634.html",
                )),
                image:
                    "paslanmaz.jpg",
                title: "Paslanmaz Çelik Sac Fiyatı",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(ChinaData(
                  appbarTitle: "Çelik Profil Fiyatı",
                  title: "Çelik Profil",
                  href: "http://www.sunsirs.com/tr/prodetail-262.html",
                )),
                image:
                    "celikpro.jpg",
                title: "Çelik Profil Fiyatı",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(ChinaData(
                  appbarTitle: "İnşaat Demiri Fiyatı",
                  title: "İnşaat Demiri",
                  href: "http://www.sunsirs.com/tr/prodetail-927.html",
                )),
                image:
                    "insaatdemiri.png",
                title: "İnşaat Demiri Fiyatı",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(ChinaData(
                  appbarTitle: "Demir Cevheri Fiyatı",
                  title: "Demir Cevheri",
                  href: "http://www.sunsirs.com/tr/prodetail-961.html",
                )),
                image:
                    "demircevher.png",
                title: "Demir Cevheri Fiyatı",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
