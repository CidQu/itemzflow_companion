import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itemzflow_companion/models/inputFormatter.dart';
import 'package:itemzflow_companion/models/ipAddres.dart';
import 'package:localstorage/localstorage.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Itemzflow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Itemzflow'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ipAdress = TextEditingController();
  final Uri _url = Uri.parse('https://pkg-zone.com');
  final LocalStorage storage = new LocalStorage('itemzflow.json');
  
  void _pkgZone() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  _saveToStorage(ip1) {
    storage.setItem('ip', ip1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildEmail(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pkgZone,
        child: const Icon(Icons.info),
      ),
    );
  }

  Widget buildEmail() => TextField(
        controller: ipAdress,
        decoration: InputDecoration(
          hintText: '192.168.1.1',
          labelText: 'PS4 Ip Address',
          prefixIcon: Icon(Icons.web),
          suffixIcon: ipAdress.text.isEmpty
              ? Container(width: 0)
              : IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () => _saveToStorage(ipAdress.text),
                ),
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        inputFormatters: [
              MyInputFormatters.ipAddressInputFilter(),
              LengthLimitingTextInputFormatter(15),
              IpAddressInputFormatter()
            ],
      );
}

