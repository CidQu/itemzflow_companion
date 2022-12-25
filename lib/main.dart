import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:itemzflow_companion/models/inputFormatter.dart';
import 'package:itemzflow_companion/models/ipAddres.dart';
import 'package:localstorage/localstorage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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


  _initiate() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () { },
      );
      AlertDialog alert = AlertDialog(
        title: Text("FTP Connection"),
        content: Text("Make sure you are using the same wifi as your PS4."),
        actions: [
          okButton,
        ],
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } else if (connectivityResult == ConnectivityResult.wifi) {
      FTPConnect ftpConnect = FTPConnect(ipAdress.text);
      try {
        await ftpConnect.connect();
      } catch (e) {
        Widget okButton = TextButton(
          child: Text("OK"),
          onPressed: () { },
        );
        AlertDialog alert = AlertDialog(
          title: Text("There is a problem!"),
          content: Text("Check your connection, make sure Itemzflow is running and FTP is on"),
          actions: [
            okButton,
          ],
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }
      await ftpConnect.disconnect();
      storage.setItem('ip', ipAdress.text);
      storage.setItem('done', 'tamam');
    } else {
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () { },
      );
      AlertDialog alert = AlertDialog(
        title: Text("There is a problem!"),
        content: Text("Check your connection or open issue on CidQu/itemzflow_companion"),
        actions: [
          okButton,
        ],
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Enter PS4 IP in order to use App.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10,),
            Text('Make sure Itemzflow is open.'),
            SizedBox(height: 10,),
            buildEmail(),
            SizedBox(height: 20,),
            ElevatedButton(onPressed:() => {}, child: Text('Continue'))
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

