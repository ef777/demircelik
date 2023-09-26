import 'package:demircelik/views/area_and_product_view.dart';
import 'package:demircelik/views/butunTurkiye.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../components/LineChart.dart';
import 'amerika_product.dart';

class AreaView extends StatelessWidget {
  const AreaView({super.key});

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
          title: const Text('Bölge Seç'),
        ),
      ),
      body: Padding(
        padding: context.paddingLow,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bölgeler",
              style:
                  context.textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
            AreaContainer(
              onTap: () => context.navigateToPage(const TurkeyProductView()),
              image:
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Flag_of_Turkey.svg/2000px-Flag_of_Turkey.svg.png",
              title: "Türkiye",
            ),
            const AreaContainer(
              image: "https://www.ab.gov.tr/files/_images/images/euablem.gif",
              title: "Avrupa Birliği",
            ),
            const AreaContainer(
              image:
                  "https://media.istockphoto.com/id/523382953/tr/foto%C4%9Fraf/usa-flag.jpg?s=612x612&w=is&k=20&c=fWLtHZrip0FkVmzZw003YgUnpvlPV_ZjthPT9_q8K8s=",
              title: "Amerika Birleşik Devleti",
            )
          ],
        ),
      ),
    );
  }
}
