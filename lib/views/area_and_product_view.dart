import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demircelik/avrupa_product.dart';
import 'package:demircelik/cin_product.dart';
import 'package:demircelik/views/adminpage.dart';
import 'package:demircelik/views/amerika_product.dart';
import 'package:demircelik/views/butunTurkiye.dart';
import 'package:demircelik/views/karsilastir.dart';

import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile_view.dart';

String? id;
String? login;

class AreaAndCouView extends StatefulWidget {
  const AreaAndCouView({super.key});

  @override
  State<AreaAndCouView> createState() => _AreaAndCouViewState();
}

class _AreaAndCouViewState extends State<AreaAndCouView> {
  late Stream<DocumentSnapshot> _userStream;

  @override
  void initState() {
    // TODO: implement initState
    print(id);
    super.initState();

    _userStream =
        FirebaseFirestore.instance.collection('users').doc(id).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: () async {
      // Geri düğmesinin işlevsiz hale getirilmesini sağlayan boş bir Future döndürülüyor.
      return false;
    },
    child: Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
            176.0), // Yükseklik değerini burada belirleyebilirsiniz
        child: AppBar(
          leading: const SizedBox.shrink(),
          actions: [
            IconButton(
                onPressed: () {
                  context.navigateToPage(const ProfilViews());
                },
                icon: const Icon(Icons.person)),
            IconButton(
                onPressed: () {
                  context.navigateToPage(PanelLogin());
                },
                icon: const Icon(Icons.admin_panel_settings_outlined))
          ],
          toolbarHeight: 176,
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hoşgeldin',
                style:
                    context.textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
              const SizedBox(
                height: 6,
              ),
              /*   StreamBuilder<DocumentSnapshot>(
                stream: _userStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Hata: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  return Text(snapshot.data!["isim"] == null
                      ? "Test User"
                      : snapshot.data!["isim"]);
                },
              ), */
              const SizedBox(
                height: 18,
              ),
              const Text('Bölge Seçin'),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: context.paddingLow,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   "Bölgeler",
            //   style:
            //       context.textTheme.titleLarge?.copyWith(color: Colors.white),
            // ),
            AreaContainer(
              onTap: () => context.navigateToPage(const TurkeyProductView()),
              image:
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Flag_of_Turkey.svg/2000px-Flag_of_Turkey.svg.png",
              title: "Türkiye Cumhuriyeti",
            ),
            AreaContainer(
              onTap: () => context.navigateToPage(const AvrupaProductView()),
              image: "https://www.ab.gov.tr/files/_images/images/euablem.gif",
              title: "Avrupa Birliği",
            ),
            AreaContainer(
              onTap: () => context.navigateToPage(const AmerikaProductView()),
              image:
                  "https://media.istockphoto.com/id/523382953/tr/foto%C4%9Fraf/usa-flag.jpg?s=612x612&w=is&k=20&c=fWLtHZrip0FkVmzZw003YgUnpvlPV_ZjthPT9_q8K8s=",
              title: "Amerika Birleşik Devleti",
            ),
            AreaContainer(
              onTap: () => context.navigateToPage(const CinProductView()),
              image:
                  "https://ulkelerbayraklar.com/wp-content/uploads/2017/12/%C3%A7in-halk-cumhuriyeti-bayra%C4%9F%C4%B1.png",
              title: "Çin Halk Cumhuriyei",
            ),
            Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => context.navigateToPage( KarsilastirmaMenu()),
        child: Container(
          height: 68,
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 3),
                  color: Colors.grey.withOpacity(.07))
            ],
            borderRadius: context.lowBorderRadius,
            //   color: Colors.white,
            color: const Color.fromRGBO(24, 31, 44, 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              
              
               Center(child: Text(
                  "Karşılaştır",
                  style: context.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                )),
              ],
            ),
          ),
        ),
      ),
    )
 
          
          ],
        ),
      ),
    ));
  }
}

class AreaContainer extends StatelessWidget {
  const AreaContainer({
    super.key,
    required this.title,
    required this.image,
    this.onTap,
  });
  final String title;
  final String image;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 68,
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 3),
                  color: Colors.grey.withOpacity(.07))
            ],
            borderRadius: context.lowBorderRadius,
            //   color: Colors.white,
            color: const Color.fromRGBO(24, 31, 44, 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      image,
                      height: 60,
                      fit: BoxFit.cover,
                      width: 60,
                    )),
                SizedBox(
                  width: context.width * .02,
                ),
                Text(
                  title,
                  style: context.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class AreaWidget extends StatelessWidget {
//   const AreaWidget({
//     super.key,
//     required this.title,
//     this.onTap,
//   });
//   final String title;
//   final Function()? onTap;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 88,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//               spreadRadius: 1,
//               blurRadius: 1,
//               offset: const Offset(0, 1),
//               color: Colors.grey.withOpacity(.01))
//         ],
//         borderRadius: context.lowBorderRadius,
//         //   color: Colors.white,
//         color: const Color.fromRGBO(24, 31, 44, 1),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               title,
//               style: context.textTheme.titleLarge
//                   ?.copyWith(color: Colors.white, fontSize: 28),
//             ),
//             InkWell(
//               onTap: onTap,
//               child: Container(
//                 height: 52,
//                 width: 52,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white,
//                 ),
//                 child: Icon(Icons.arrow_forward_ios_rounded),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
