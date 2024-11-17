import 'dart:ffi';
import 'package:flutter/foundation.dart';
import 'package:natanjir_desktop/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

class SignalRProvider with ChangeNotifier {
  late HubConnection _hubConnection;

  SignalRProvider._privateConstructor();

  static final SignalRProvider _instance =
      SignalRProvider._privateConstructor();

  factory SignalRProvider() {
    return _instance;
  }

  Future<void> startConnection() async {
    _hubConnection = HubConnectionBuilder()
        .withUrl(
          'http://localhost:5212/notifications-hub',
        )
        .build();

    try {
      await _hubConnection.start();
      print('SignalR konekcija uspješna.');
    } catch (e) {
      print('Greška prilikom konektovanja: $e');
    }

    _hubConnection.on('ReceiveConnectionId', (arguments) {
      print("Connection id: $arguments");
      AuthProvider.connectionId = arguments?[0];
    });

    _hubConnection.on('ReceiveMessage', (arguments) async {
      final message = arguments?[0]?.toString() ?? '';
      if (message.isNotEmpty) {
        print("Poruka: $message");

        notifyListeners();
        if (onNotificationReceived != null) {
          onNotificationReceived!(message);
        }
      }
    });
  }

  bool isConnected() {
    return _hubConnection.state == HubConnectionState.Connected;
  }

  Future<void> stopConnection() async {
    if (_hubConnection.state == HubConnectionState.Connected) {
      await _hubConnection.stop();
      print('SignalR zaustavljen.');
    }
  }

  void Function(String message)? onNotificationReceived;
}
