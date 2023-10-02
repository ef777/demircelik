import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class PanelLogin extends StatefulWidget {
  @override
  _PanelLoginState createState() => _PanelLoginState();
}

class _PanelLoginState extends State<PanelLogin> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Burada kullanıcı adı ve şifre doğrulamasını gerçekleştirin
    if (username == 'admin' && password == 'admin') {
Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return  ProductSelectionPage();
                  },
                ),
              );      
    } else {
      // Kullanıcı adı veya şifre yanlışsa hata mesajı gösterilebilir
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Hata'),
            content: Text('Kullanıcı adı veya şifre yanlış.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Tamam'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giriş Yap'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Kullanıcı Adı'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Şifre'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Giriş Yap'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Seçiniz'),
      ),
      body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              ListTile(
                title: const Text('Sıcak Haddelenmiş Sac'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AdminPage(product: 'Sıcak Haddelenmiş Sac', id: 1)),
                  );
                },
              ),
              ListTile(
                title: const Text('Soğuk Haddelenmiş Sac'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AdminPage(product: 'Soğuk Haddelenmiş Sac', id: 2)),
                  );
                },
              ),
              ListTile(
                title: const Text('Galvaniz Sac'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AdminPage(product: 'Galvaniz Sac', id: 3)),
                  );
                },
              ),
              // Add more products here
            ],
          )),
    );
  }
}

class AdminPage extends StatefulWidget {
  final String product;
  final int id;

  AdminPage({Key? key, required this.product, required this.id})
      : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController _priceController = TextEditingController();
  String _selectedUnit = 'USD';
  String _selectedCountryId = '1';
  String _selectedProductId = '1';
  DateTime selectedDate = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    _selectedProductId = widget.id.toString();
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _showAddDialog(
    BuildContext context,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ekle'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _priceController,
                  decoration: InputDecoration(hintText: 'Fiyatı giriniz'),
                  keyboardType: TextInputType.number,
                ),
               
                Text('Seçili tarih: ${formatter.format(selectedDate)}'),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Tarih Seç'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ekle'),
              onPressed: () {
                FirebaseFirestore.instance.collection(widget.product).add({
                  'price': _priceController.text,
                  'date': formatter.format(selectedDate),
                  'unit': _selectedUnit,
                  'id': _selectedProductId,
                  'countryId': _selectedCountryId,
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.product} Admin Panel'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddDialog(context),
          tooltip: 'Add product',
          child: const Icon(Icons.add),
        ),
        body: Container(
          color: Colors.white,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(widget.product)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return const Text('Loading...');
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(snapshot.data!.docs[index]['price']),
                  subtitle: Text(
                      'Tarih: ${snapshot.data!.docs[index]['date']}\n'
                      'Birim: ${snapshot.data!.docs[index]['unit']}\n'
                      // 'ID: ${snapshot.data!.docs[index]['id']}\n'
                      //'Country ID: ${snapshot.data!.docs[index]['countryId']}'
                      ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _priceController.text =
                              snapshot.data!.docs[index]['price'];
                          _selectedUnit = snapshot.data!.docs[index]['unit'];
                          _selectedProductId = snapshot.data!.docs[index]['id'];
                          _selectedCountryId =
                              snapshot.data!.docs[index]['countryId'];
                          selectedDate = DateFormat('dd/MM/yyyy')
                              .parse(snapshot.data!.docs[index]['date']);
                          FirebaseFirestore.instance
                              .collection(widget.product)
                              .doc(snapshot.data!.docs[index].id)
                              .delete();
                          _showAddDialog(context);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection(widget.product)
                              .doc(snapshot.data!.docs[index].id)
                              .delete();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
