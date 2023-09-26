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
                    "https://www.gundogdudemircelik.com/site_document/sayfa_img/CMARE6356_resim_16_6_2017_16_b.jpg",
                title: "Sıcak Haddelenmiş Sac Fiyatı",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(UsAndChinaScrapmons(
                  appbarTitle: "Çelik Hurda Fiyatı",
                  title: "Çelik Hurda ",
                  href:
                      "https://www.scrapmonster.com/steel-prices/cold-rolled-coil-prices/594",
                  isUSA: false,
                )),
                image: "https://ayescelik.com/images/kangal_demir_7.jpg",
                title: "Çelik Hurda Fiyatı ",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(ChinaData(
                  appbarTitle: "Soğuk Haddelenmiş Sac Fiyatı",
                  title: "Soğuk Haddelenmiş Sac",
                  href: "http://www.sunsirs.com/tr/prodetail-318.html",
                )),
                image:
                    "https://www.gundogdudemircelik.com/site_document/sayfa_img/CMARE6356_resim_16_6_2017_16_b.jpg",
                title: "Soğuk Haddelenmiş Sac Fiyatı",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(ChinaData(
                  appbarTitle: "Galvaniz Sac Fiyatı",
                  title: "Galvaniz Sac",
                  href: "http://www.sunsirs.com/tr/prodetail-301.html",
                )),
                image:
                    "https://www.galvanizlisac.biz/galvaniz/galeri/galvanizli-sac-dkp-sac-boyali-sac-trapes-siyah-sac17.jpg",
                title: "Galvaniz Sac Fiyatı",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(ChinaData(
                  appbarTitle: "Boyalı Sac Fiyatı",
                  title: "Boyalı Sac",
                  href: "http://www.sunsirs.com/tr/prodetail-300.html",
                )),
                image: "https://www.eryilmazmetal.com/tr/img/boyali-sac.jpg",
                title: "Boyalı Sac Fiyatı",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(ChinaData(
                  appbarTitle: "Paslanmaz Çelik Sac Fiyatı",
                  title: "Paslanmaz Çelik Sac",
                  href: "http://www.sunsirs.com/tr/prodetail-634.html",
                )),
                image:
                    "https://www.karacapaslanmaz.com/imaj/makale-gorselleri/paslanmaz-saclar-karaca-paslanmaz.jpg",
                title: "Paslanmaz Çelik Sac Fiyatı",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(ChinaData(
                  appbarTitle: "Çelik Profil Fiyatı",
                  title: "Çelik Profil",
                  href: "http://www.sunsirs.com/tr/prodetail-262.html",
                )),
                image:
                    "https://cdn.karacametal.com/yuklemeler/blog/celik-profil-ne-demek.jpg",
                title: "Çelik Profil Fiyatı",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(ChinaData(
                  appbarTitle: "İnşaat Demiri Fiyatı",
                  title: "İnşaat Demiri",
                  href: "http://www.sunsirs.com/tr/prodetail-927.html",
                )),
                image:
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQCil7H94aMSWJzlz3QHYAdZa3OvCkVuM-pCZbtpk3UTDhhBWs4IdT2MLbxqlD-0xlwRJI&usqp=CAU",
                title: "İnşaat Demiri Fiyatı",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(ChinaData(
                  appbarTitle: "Demir Cevheri Fiyatı",
                  title: "Demir Cevheri",
                  href: "http://www.sunsirs.com/tr/prodetail-961.html",
                )),
                image:
                    "https://cdn1.ntv.com.tr/gorsel/zNggTEdUQEWWKyHJ6_uYJw.jpg?width=952&height=540&mode=both&scale=both",
                title: "Demir Cevheri Fiyatı",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
