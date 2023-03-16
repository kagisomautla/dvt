import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkConnectivity {
  NetworkConnectivity();
  static final _instance = NetworkConnectivity();
  static NetworkConnectivity get instance => _instance;
  final _connectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;

  void initialise() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _checkStatus(result);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      if (result != ConnectivityResult.none) {
        await InternetAddress.lookup('example.com').then((result) {
          isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty ? true : false;
        });
      } else {
        isOnline = false;
      }
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({'online': isOnline});
  }

  void disposeStream() => _controller.close();
}
