# network_status_bar

Create network status bar check your device is online/offline with simple slide animation.

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

### Installing

```yaml
dependencies:
  network_status_bar: "^0.1.4"
```

### Import

```dart
import 'package:network_status_bar/network_status_bar.dart';
```

### Usage

```dart
import 'package:flutter/material.dart';
import 'package:network_status_bar/network_status_bar.dart';

class OnlineOffinePage extends StatelessWidget {
  OnlineOffinePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'network status bar',
        ),
      ),
      body: NetworkStatusBar(
        child: Container(
          height: 300,
          color: Colors.yellow,
        ),
      ),
    );
  }
}
```

## 📷 Screenshots

<table>
  <tr>
    <td align="center">
      <img src="https://raw.githubusercontent.com/LeDuyTho/network_status_bar/master/screenshots/online.jpg" width="250px">
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/LeDuyTho/network_status_bar/master/screenshots/offline.jpg" width="250px">
    </td>
  </tr>
</table>
