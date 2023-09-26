
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
                    "https://media.istockphoto.com/id/915059294/tr/vekt%C3%B6r/demir-fe-kimyasal-element-simgesi.jpg?s=170667a&w=0&k=20&c=PUZPzwx7iCnHuICciFxdGLbsVTUHq6jQ2mCzEZItGSs=",
                title: "Demir Fiyatı",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(TurkeyAllPage(
                  appbarTitle: "Kütük Fiyatı",
                  title: "Kütük",
                  href: "Kütük",
                )),
                image:
                    "https://www.atolye10.com/wp-content/uploads/2018/04/ahsap-dilim-kutuk.jpg",
                title: "Kütük Fiyatı",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(TurkeyAllPage(
                  appbarTitle: "Çelik Hasır Fiyatı",
                  title: "Çelik Hasır",
                  href: "Çelik Hasır",
                )),
                image:
                    "https://kalkangeridonusum.com/wp-content/uploads/2021/04/hurda-demir.jpg",
                title: "Çelik Hasır Fiyatı",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(TurkeyAllPage(
                  appbarTitle: "Yerli Hurda Fiyatı",
                  title: "Yerli Hurda",
                  href: "Yerli Hurda",
                )),
                image:
                    "https://kalkangeridonusum.com/wp-content/uploads/2021/04/hurda-demir.jpg",
                title: "Yerli Hurda",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(TurkeyAllPage(
                  appbarTitle: "Yerli Hurda Fiyatı",
                  title: "İthal Hurdar",
                  href: "İthal Hurda",
                )),
                image:
                    "https://kalkangeridonusum.com/wp-content/uploads/2021/04/hurda-demir.jpg",
                title: "İthal Hurda",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(TurkeyAllPage(
                  appbarTitle: "Demir Cevheri Fiyatı",
                  title: "Demir Cevheri",
                  href: "Demir Cevheri",
                )),
                image:
                    "https://geoim.bloomberght.com/2021/12/07/ver1638865879/2293767_1200x627.jpg",
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
                    "https://media.istockphoto.com/id/915059294/tr/vekt%C3%B6r/demir-fe-kimyasal-element-simgesi.jpg?s=170667a&w=0&k=20&c=PUZPzwx7iCnHuICciFxdGLbsVTUHq6jQ2mCzEZItGSs=",
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
                    "https://media.istockphoto.com/id/915059294/tr/vekt%C3%B6r/demir-fe-kimyasal-element-simgesi.jpg?s=170667a&w=0&k=20&c=PUZPzwx7iCnHuICciFxdGLbsVTUHq6jQ2mCzEZItGSs=",
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
                    "https://media.istockphoto.com/id/915059294/tr/vekt%C3%B6r/demir-fe-kimyasal-element-simgesi.jpg?s=170667a&w=0&k=20&c=PUZPzwx7iCnHuICciFxdGLbsVTUHq6jQ2mCzEZItGSs=",
                title: "Galvaniz Sac",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(TurkeyAllPage(
                  appbarTitle: "Nervurlu Kangal Fiyatı",
                  title: "Nervurlu Kangal",
                  href: "Nervürlü Kangal",
                )),
                image: "https://ayescelik.com/images/kangal_demir_7.jpg",
                title: "Nervurlu Kangal Fiyatı",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(TurkeyAllPage(
                  appbarTitle: "Düz Kangal Fiyatı",
                  title: "Düz Kangal",
                  href: "Düz Kangal",
                )),
                image: "https://ayescelik.com/images/kangal_demir_7.jpg",
                title: "Düz Kangal Fiyatı",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
