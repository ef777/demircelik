
import 'package:demircelik/views/anaview.dart';
import 'package:demircelik/views/defiyat-tr/tr-data.dart';
import 'package:demircelik/views/defiyat-tr/tr_demir-data.dart';
import 'package:demircelik/views/firestore-tr/fireview.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class TurkeyProductView extends StatelessWidget {
  const TurkeyProductView({super.key});

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
                onTap: () => context.navigateToPage(DemirYeni(
                  title: '',
                  appbarTitle: '',
                  href: '',
                )),
                image:
                    "insaatdemiri.png",
                title: "Demir Fiyatı",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(TurkeyAllPage(
                  appbarTitle: "Kütük Fiyatı",
                  title: "Kütük",
                  href: "Kütük",
                )),
                image:
                    "kutuk.png",
                title: "Kütük Fiyatı",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(TurkeyAllPage(
                  appbarTitle: "Çelik Hasır Fiyatı",
                  title: "Çelik Hasır",
                  href: "Çelik Hasır",
                )),
                image:
                    "celikhasir.png",
                title: "Çelik Hasır Fiyatı",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(TurkeyAllPage(
                  appbarTitle: "Yerli Hurda Fiyatı",
                  title: "Yerli Hurda",
                  href: "Yerli Hurda",
                )),
                image:
                    "yerlihurda.png",
                title: "Yerli Hurda",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(TurkeyAllPage(
                  appbarTitle: "Yerli Hurda Fiyatı",
                  title: "İthal Hurdar",
                  href: "İthal Hurda",
                )),
                image:
                    "ithalhurda.png",
                title: "İthal Hurda",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(TurkeyAllPage(
                  appbarTitle: "Demir Cevheri Fiyatı",
                  title: "Demir Cevheri",
                  href: "Demir Cevheri",
                )),
                image:
                    "demircevher.png",
                title: "Demir Cevheri Fiyatı",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(FireView(
                  title: '',
                  appbarTitle: '',
                  href: '',
                  product: 'Sıcak Haddelenmiş Sac',
                  id: '1',
                )),
                image:
                    "sicaksac.png",
                title: "Sıcak Haddelenmiş Sac",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(FireView(
                  title: '',
                  appbarTitle: '',
                  href: '',
                  product: 'Soğuk Haddelenmiş Sac',
                  id: '2',
                )),
                image:
                    "soguksac.png",
                title: "Soğuk Haddelenmiş Sac",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(FireView(
                  title: '',
                  appbarTitle: '',
                  href: '',
                  id: '3',
                  product: 'Galvaniz Sac',
                )),
                image:
                    "galvanizsac.png",
                title: "Galvaniz Sac",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(TurkeyAllPage(
                  appbarTitle: "Nervurlu Kangal Fiyatı",
                  title: "Nervurlu Kangal",
                  href: "Nervürlü Kangal",
                )),
                image: "nervurlukangal.png",
                title: "Nervurlu Kangal Fiyatı",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(TurkeyAllPage(
                  appbarTitle: "Düz Kangal Fiyatı",
                  title: "Düz Kangal",
                  href: "Düz Kangal",
                )),
                image: "duzkangal.png",
                title: "Düz Kangal Fiyatı",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
