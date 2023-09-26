import 'package:demircelik/views/area_and_product_view.dart';
import 'package:demircelik/views/hacUsa-Eu.dart';
import 'package:demircelik/views/karsilastirdetay.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';



class KarsilastirmaMenu extends StatelessWidget {
  const KarsilastirmaMenu({super.key});

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
                onTap: () => context.navigateToPage(KarsilastirDetay (id:"5",
              
                title: "Demir Cevheri",
                )),
                image:
                    "https://geoim.bloomberght.com/2021/12/07/ver1638865879/2293767_1200x627.jpg",
                title: "Demir Cevheri",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(KarsilastirDetay (id:"1",
              
                title: "İnşaat Demiri",
                )),
                image:
                    "https://ayescelik.com/images/kangal_demir_7.jpg",
                title: "İnşaat Demiri",
              ),
              
              
              AreaContainer(
                onTap: () => context.navigateToPage(KarsilastirDetay (id:"2",
              
                title: "Sıcak Haddelenmiş Sac Fiyatı",
                )),
                image:
                    "https://www.gundogdudemircelik.com/site_document/sayfa_img/CMARE6356_resim_16_6_2017_16_b.jpg",
                title: "Sıcak Haddelenmiş Sac Fiyatı",
              ),
               AreaContainer(
                onTap: () => context.navigateToPage(KarsilastirDetay (id:"3",
              
                title: "Sıcak Haddelenmiş Sac Fiyatı",
                )),
                image:
                    "https://media.istockphoto.com/id/915059294/tr/vekt%C3%B6r/demir-fe-kimyasal-element-simgesi.jpg?s=170667a&w=0&k=20&c=PUZPzwx7iCnHuICciFxdGLbsVTUHq6jQ2mCzEZItGSs=",
                title: "Soğuk Haddelenmiş Sac",
              ), AreaContainer(
                onTap: () => context.navigateToPage(KarsilastirDetay (id:"4",
              
                title: "Galvaniz sac",
                )),
                image:
                    "https://ayescelik.com/images/kangal_demir_7.jpg",
                title: "Galvaniz sac",
              ),
                AreaContainer(
                onTap: () => context.navigateToPage(KarsilastirDetay (id:"6",
              
                title: "Hurda",
                )),
                image:
                    "https://kalkangeridonusum.com/wp-content/uploads/2021/04/hurda-demir.jpg",
                title: "Hurda",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
