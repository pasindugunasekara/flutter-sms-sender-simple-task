import 'package:flutter/material.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:flutter_sms/flutter_sms.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String number;
  final ContactPicker contactPicker = new ContactPicker();
  TextEditingController controllerContact, controllerMessage;
  String body, message;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  List<String> contactlist = [];

  Future<void> initPlatformState() async {
    controllerContact = TextEditingController();
    controllerMessage = TextEditingController();
  }

  void _sendSMS(String message, List<String> recipents) async {
    String result = await sendSMS(message: message, recipients: recipents);
    setState(() => message = result);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Sms',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(title: Text("Send SmS"), backgroundColor: Colors.blue),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            // color: Colors.purple.shade50,
            child: Column(
              children: <Widget>[
                contactlist == null || contactlist.isEmpty
                    ? Container(
                        height: 0.0,
                      )
                    : Container(
                        height: 90.0,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: List<Widget>.generate(contactlist.length,
                                (int index) {
                              return contactTile(contactlist[index]);
                            }),
                          ),
                        ),
                      ),
                Divider(),
                Container(
                  child: ElevatedButton(
                    onPressed: () async {
                      Contact contact = await contactPicker.selectContact();
                      if (contact != null) {
                        number = contact.phoneNumber.number;
                        setState(() {
                          contactlist.add(number);
                          controllerContact.clear();
                        });
                      }
                    },
                    child: Text("Pick Contact"),
                  ),
                ),
                ListTile(
                  title: TextField(
                    controller: controllerContact,
                    decoration: InputDecoration(labelText: "Add Mobile Number"),
                    onChanged: (String value) => setState(() {}),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => setState(() {
                      contactlist.add(controllerContact.text.toString());
                      controllerContact.clear();
                    }),
                  ),
                ),
                ListTile(
                  title: TextField(
                    decoration:
                        InputDecoration(labelText: " Type Your Message here"),
                    controller: controllerMessage,
                    onChanged: (String value) => setState(() {}),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.save),
                    onPressed: controllerMessage.text.isEmpty
                        ? null
                        : () => setState(() {
                              body = controllerMessage.text.toString();
                              controllerMessage.clear();
                            }),
                  ),
                ),
                SizedBox(
                  width: 20,
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    if ((contactlist == null || contactlist.isEmpty) ||
                        (body == null || body.isEmpty)) {
                      setState(() =>
                          message = "At Least 1 Person or Message Required");
                    } else {
                      _sendSMS(body, contactlist);
                    }
                  },
                  child: Text("Send Massage"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        message ?? "Please Fill The Details",
                        maxLines: null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget contactTile(String name) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(color: Colors.black),
            top: BorderSide(color: Colors.black),
            left: BorderSide(color: Colors.black),
            right: BorderSide(color: Colors.black),
          )),
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => setState(() => contactlist.remove(name)),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    name,
                    textScaleFactor: 1.0,
                    style:
                        TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
