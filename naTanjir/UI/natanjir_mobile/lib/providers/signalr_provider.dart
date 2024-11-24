import 'dart:async';
import 'dart:ffi';
import 'package:flutter/foundation.dart';
import 'package:natanjir_mobile/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/itransport.dart';

class SignalRProvider with ChangeNotifier {
  late HubConnection _hubConnection;
  Timer? _reconnectTimer;
  Timer? _connectionIdTimeoutTimer;
  bool _isReconnecting = false;
  SignalRProvider._privateConstructor();

  static final SignalRProvider _instance =
      SignalRProvider._privateConstructor();

  factory SignalRProvider() {
    return _instance;
  }
  int _messageCount = 0;
  Future<void> initializeMessageCount() async {
    final messages = await getMessages();
    _messageCount = messages.length;
    notifyListeners();
  }

  Future<void> startConnection() async {
    _hubConnection = HubConnectionBuilder()
        .withUrl(
          'http://10.0.2.2:5212/notifications-hub',
        )
        .build();

    try {
      await _hubConnection.start();
      print('SignalR konekcija uspješna.');
      _startConnectionIdTimeout();
    } catch (e) {
      print('Greška prilikom konektovanja: $e');
      _scheduleReconnect();
    }

    _hubConnection.on('ReceiveConnectionId', (arguments) {
      _connectionIdTimeoutTimer?.cancel();
      print("Connection id: $arguments");
      AuthProvider.connectionId = arguments?[0];
    });

    _hubConnection.on('ReceiveMessage', (arguments) async {
      final message = arguments?[0]?.toString() ?? '';
      if (message.isNotEmpty) {
        print("Poruka: $message");
        await _saveMessage(message);
        _messageCount++;

        notifyListeners();
        if (onNotificationReceived != null) {
          onNotificationReceived!(message);
        }
      }
    });
  }

  void _startConnectionIdTimeout() {
    _connectionIdTimeoutTimer = Timer(Duration(seconds: 3), () {
      print("Nije primljen ConnectionId. Pokušaj ponovnog povezivanja.");
      _restartConnection();
    });
  }

  void _scheduleReconnect() {
    if (_isReconnecting) return;

    _isReconnecting = true;
    _reconnectTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
      print("Pokušavam ponovo uspostaviti SignalR konekciju...");
      try {
        await startConnection();
        if (_hubConnection.state == HubConnectionState.Connected) {
          timer.cancel();
          _isReconnecting = false;
          print("SignalR ponovo povezan.");
        }
      } catch (e) {
        print("Ponovno povezivanje neuspješno: $e");
      }
    });
  }

  Future<void> _restartConnection() async {
    if (_hubConnection.state == HubConnectionState.Connected) {
      await _hubConnection.stop();
    }
    await startConnection();
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

  Future<void> _saveMessage(String message) async {
    final prefs = await SharedPreferences.getInstance();
    final username = AuthProvider.username;

    if (username != null) {
      final key = 'messages_$username';
      final messages = prefs.getStringList(key) ?? [];
      messages.add(message);
      await prefs.setStringList(key, messages);
    } else {
      print("Korisnik nije prijavljen.");
    }
  }

  Future<List<String>> getMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final username = AuthProvider.username;

    if (username != null) {
      return prefs.getStringList('messages_$username') ?? [];
    } else {
      print("Korisnik nije prijavljen.");
      return [];
    }
  }

  Future<void> clearMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final username = AuthProvider.username;

    if (username != null) {
      await prefs.remove('messages_$username');
      notifyListeners();
      _messageCount = 0;
    } else {
      print("Korisnik nije prijavljen.");
    }
  }

  int get messageCount => _messageCount;
  void Function(String message)? onNotificationReceived;
}
