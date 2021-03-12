library network_status_bar;

import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

///- by Lê Duy Thọ v0.1.5
///Usage:
// class OnlineOffinePage extends StatelessWidget {
//  OnlineOffinePage({
//    Key key,
//  }) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(
//          'network status bar',
//        ),
//      ),
//      body: NetworkStatusBar(
//        child: Container(
//          height: 300,
//          color: Colors.yellow,
//        ),
//      ),
//    );
//  }
//}

enum NetworkStatusBarDirection {
  fromTop,
  fromBottom,
}

class NetworkStatusBar extends StatefulWidget {
  NetworkStatusBar({
    Key key,
    this.direction = NetworkStatusBarDirection.fromTop,
    this.backgroundOnlineColor = Colors.green,
    this.backgroundOfflineColor = Colors.red,
    this.textOnlineColor = Colors.white,
    this.textOfflineColor = Colors.white,
    this.textOnline = 'Đã kết nối mạng',
    this.textOffline = 'Không có kết nối mạng',
    this.fontSize = 16,
    this.marginTop = 0.0,
    this.marginBottom = 0.0,
    @required this.child,
  }) : super(key: key);

  final NetworkStatusBarDirection direction;

  final Color backgroundOnlineColor;
  final Color backgroundOfflineColor;
  final Color textOnlineColor;
  final Color textOfflineColor;

  final String textOnline;
  final String textOffline;
  final double fontSize;
  final double marginTop;
  final double marginBottom;

  final Widget child;

  @override
  _NetworkStatusBarState createState() => _NetworkStatusBarState();
}

class _NetworkStatusBarState extends State<NetworkStatusBar>
    with TickerProviderStateMixin {
  ConnectivityBloc _connectivity = ConnectivityBloc();

  AnimationController _animationController;
  Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _initAnimation();
  }

  @override
  void dispose() {
    _connectivity.disposeStream();
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        (widget.direction == NetworkStatusBarDirection.fromTop)
            ? _statusBarFromTop()
            : _statusBarFromBottom(),
      ],
    );
  }

  Widget _statusBarFromTop() {
    return _streamContainer();
  }

  Widget _statusBarFromBottom() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: _streamContainer(),
    );
  }

  Widget _streamContainer() {
    return Container(
      margin:
          EdgeInsets.only(top: widget.marginTop, bottom: widget.marginBottom),
      child: StreamBuilder(
        stream: _connectivity.myStream,
        builder: (context, snapshot) {
          String string;
          Color bgColor;
          String text = '';
          Color textColor;

          if (snapshot.hasData) {
            ConnectivityResult result = snapshot.data;
            switch (result) {
              case ConnectivityResult.none:
                string = "Offline";
                text = widget.textOffline;
                textColor = widget.textOfflineColor;
                bgColor = widget.backgroundOfflineColor;
                break;
              case ConnectivityResult.mobile:
                string = "Mobile: Online";
                text = widget.textOnline;
                textColor = widget.textOnlineColor;
                bgColor = widget.backgroundOnlineColor;
                break;
              case ConnectivityResult.wifi:
                string = "WiFi: Online";
                text = widget.textOnline;
                textColor = widget.textOnlineColor;
                bgColor = widget.backgroundOnlineColor;
                break;
            }

            return SlideTransition(
              position: _animation,
              child: Container(
                color: bgColor,
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: widget.fontSize,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center();
        },
      ),
    );
  }

  void _initConnectivity() {
    _connectivity.myStream.listen((source) {
      _startAnimation();
    });
  }

  void _initAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      value: this,
    );

    double yBegin =
        (widget.direction == NetworkStatusBarDirection.fromTop) ? -1 : 1;

    _animation = Tween<Offset>(
      begin: Offset(0, yBegin),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Timer(Duration(milliseconds: 900), () {
          if (_animationController != null) _animationController.reverse();
        });
      }
    });
  }

  void _startAnimation() {
    Timer(Duration(milliseconds: 600), () {
      if (_animationController != null) _animationController.forward();
    });
  }
}

class ConnectivityBloc {
//  ConnectivityBloc._internal();
//  static final ConnectivityBloc _instance = ConnectivityBloc._internal();
//  static ConnectivityBloc get instance => _instance;

  ConnectivityBloc() {
    initConnect();
  }

  StreamController controller = StreamController.broadcast();

  StreamSubscription<ConnectivityResult> subscriptionConnect;

  Stream get myStream => controller.stream;

  bool firstLoad = true; // add

  void initConnect() async {
    Connectivity connectivity = Connectivity();
    //ConnectivityResult check = await connectivity.checkConnectivity();

    subscriptionConnect = connectivity.onConnectivityChanged.listen((result) {
      if (firstLoad == false ||
          (firstLoad == true && result == ConnectivityResult.none))
        controller.sink.add(result);
      firstLoad = false;
    });
  }

  Future<bool> isConnectInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      //print('INTERNET CONNECTED');
      return true;
    }
    //print('NO INTERNET');
    return false;
  }

  void disposeStream() async {
    controller.close();
    subscriptionConnect.cancel();
  }
}
