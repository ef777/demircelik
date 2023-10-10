import 'package:demircelik/views/anaview.dart';
import 'package:demircelik/views/eu-usa-scrap(sac)/sac-usa-eu-data.dart';
import 'package:demircelik/views/karsilastir/karsi-data.dart';
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
                    "demircevher.png",
                title: "Demir Cevheri",
              ),
              AreaContainer(
                onTap: () => context.navigateToPage(KarsilastirDetay (id:"1",
              
                title: "İnşaat Demiri",
                )),
                image:
                    "insaatdemiri.png",
                title: "İnşaat Demiri",
              ),
              
              
              AreaContainer(
                onTap: () => context.navigateToPage(KarsilastirDetay (id:"2",
              
                title: "Sıcak Haddelenmiş Sac Fiyatı",
                )),
                image:
                    "sicaksac.png",
                title: "Sıcak Haddelenmiş Sac Fiyatı",
              ),
               AreaContainer(
                onTap: () => context.navigateToPage(KarsilastirDetay (id:"3",
              
                title: "Soguk Haddelenmiş Sac Fiyatı",
                )),
                image:
                    "soguksac.png",
                title: "Soğuk Haddelenmiş Sac",
              ), AreaContainer(
                onTap: () => context.navigateToPage(KarsilastirDetay (id:"4",
              
                title: "Galvaniz sac",
                )),
                image:
                    "galvanizsac.png",
                title: "Galvaniz sac",
              ),
                AreaContainer(
                onTap: () => context.navigateToPage(KarsilastirDetay (id:"6",
              
                title: "Hurda",
                )),
                image:
                    "ithalhurda.png",
                title: "Hurda",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
