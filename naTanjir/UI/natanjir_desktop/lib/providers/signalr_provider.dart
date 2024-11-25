import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:natanjir_desktop/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/itransport.dart';

class SignalRProvider with ChangeNotifier {
  late HubConnection _hubConnection;
  Timer? _reconnectTimer;
  Timer? _connectionIdTimeoutTimer;
  bool _isReconnecting = false;

  late String _baseUrl;
  late String _endpoint;

  SignalRProvider._privateConstructor(String endpoint) {
    _endpoint = endpoint;
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:5212/");
  }

  static final SignalRProvider _instance =
      SignalRProvider._privateConstructor("");

  factory SignalRProvider(String endpoint) {
    _instance._endpoint = endpoint;
    return _instance;
  }

  Future<void> startConnection() async {
    final url = '$_baseUrl$_endpoint';

    _hubConnection = HubConnectionBuilder().withUrl(url).build();

    try {
      await _hubConnection.start();
      _startConnectionIdTimeout();
    } catch (e) {
      _scheduleReconnect();
    }

    _hubConnection.on('ReceiveConnectionId', (arguments) {
      _connectionIdTimeoutTimer?.cancel();
      AuthProvider.connectionId = arguments?[0];
    });

    _hubConnection.on('ReceiveMessage', (arguments) async {
      final message = arguments?[0]?.toString() ?? '';
      if (message.isNotEmpty) {
        notifyListeners();
        if (onNotificationReceived != null) {
          onNotificationReceived!(message);
        }
      }
    });
  }

  void _startConnectionIdTimeout() {
    _connectionIdTimeoutTimer = Timer(Duration(seconds: 3), () {
      _restartConnection();
    });
  }

  void _scheduleReconnect() {
    if (_isReconnecting) return;

    _isReconnecting = true;
    _reconnectTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
      try {
        await startConnection();
        if (_hubConnection.state == HubConnectionState.Connected) {
          timer.cancel();
          _isReconnecting = false;
        }
      } catch (e) {}
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
    }
  }

  void Function(String message)? onNotificationReceived;
}
