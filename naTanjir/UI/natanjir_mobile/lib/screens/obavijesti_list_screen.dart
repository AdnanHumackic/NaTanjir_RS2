import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:natanjir_mobile/providers/auth_provider.dart';
import 'package:natanjir_mobile/providers/signalr_provider.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ObavijestListScreen extends StatefulWidget {
  const ObavijestListScreen({Key? key}) : super(key: key);

  @override
  State<ObavijestListScreen> createState() => _ObavijestListScreenState();
}

class _ObavijestListScreenState extends State<ObavijestListScreen> {
  final SignalRProvider _signalRProvider = SignalRProvider();
  List<String> _notifications = [];

  Future<void> _loadNotifications() async {
    final notifications = await _signalRProvider.getMessages();
    setState(() {
      _notifications = notifications;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _signalRProvider.onNotificationReceived = (message) {
      setState(() {
        _notifications.insert(0, message);
      });
    };
  }

  @override
  void dispose() {
    _signalRProvider.onNotificationReceived = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 83, 86),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Vaše obavijesti",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _notifications.isEmpty
                ? Center(
                    child: Text(
                      'Trenutno nemate obavijesti.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text(
                            _notifications[index],
                            style: TextStyle(fontSize: 16),
                          ),
                          leading: Icon(Icons.notifications,
                              color: Color.fromARGB(255, 0, 83, 86)),
                        ),
                      );
                    },
                  ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Divider(
            color: Color.fromARGB(255, 0, 83, 86),
            height: 1.0,
            thickness: 2,
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: 45,
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 83, 86),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Nije moguće odgovoriti na ove poruke.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 0,
                child: InkWell(
                  onTap: () async {
                    if (_notifications.isNotEmpty) {
                      _signalRProvider.clearMessages();
                      await QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        title: 'Obavijesti uspješno obrisane!',
                      );
                      setState(() {
                        _notifications = [];
                      });
                    } else {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: 'Nema obavijesti za obrisati!',
                      );
                    }
                  },
                  child: Container(
                    height: 45,
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Obriši obavijesti",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
