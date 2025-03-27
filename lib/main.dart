import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:wakelock/wakelock.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/rendering.dart'; 
import 'package:image_gallery_saver/image_gallery_saver.dart'; 
import 'dart:ui' as ui;
import 'dart:math' as math; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Sample App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: {
        PlotPage.routeName: (context) => PlotPage(),
        HelpPage.routeName: (context) => HelpPage(),
        AboutPage.routeName: (context) => AboutPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
  static const routeName = '/';
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _ipController = TextEditingController();
  late double number = 1.2;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      loadSavedData();
      Wakelock.enable();
      _loadSavedNumber();
    });
  }

  void loadSavedData() async {
    String savedIpAddress = await getSavedIpAddress();
    if (savedIpAddress.isNotEmpty) {
      _ipController.text = savedIpAddress;
    }
  }

  Future<void> _loadSavedNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double savedNumber = prefs.getDouble('number') ?? 1.2;
    setState(() {
      number = savedNumber;
    });
  }

  Future<void> _saveNumber(double newNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('number', newNumber);
    setState(() {
      number = newNumber;
    });
  }

  Future<String> getSavedIpAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('ipAddress') ?? '';
  }

  void saveUserData(String ipAddress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ipAddress', ipAddress);
  }

  Socket? socket;
  List<List<String?>> dataList = [];
  int dataCount = 0;
  double progressPercentage = 0.0;
  int num = 10; //number of data points

  void connectToSocket() async {
    String ipAddress = _ipController.text;
    int port = 80;
    saveUserData(ipAddress);
    String savedIpAddress = await getSavedIpAddress();
    _connectToSocket(ipAddress, port);
  }
  void _connectToSocket(String ipAddress, int port) async {
    print('connected to socket');
    try {
      dataCount = 0;
      progressPercentage = 0.0;
      socket = await Socket.connect(ipAddress, port);
      
    } catch (e) {
      print('Error connecting to socket: $e');
      reconnect(); 
    }
  }

  void reconnect() async {
    await Future.delayed(Duration(seconds: 3)); // Delay before attempting reconnection
    connectToSocket();
  }
  // sample data points 
  void processData() {
    dataList.add(['1.0', '2.5', '0.5']);  
    dataList.add(['1.5','3.0', '1.2']);  
    dataList.add(['2.0', '4.1', '1.8']);  
    dataList.add(['2.5', '3.7', '0.9']);  
    dataList.add(['3.0', '5.5', '2.3']);  
    dataList.add(['3.5', '6.4', '2.7']);  
    dataList.add(['4.0', '7.1', '3.0']);  
    dataList.add(['4.5', '5.9', '1.5']);  
    dataList.add(['5.0', '8.0', '4.0']);  
    dataList.add(['5.5', '4.6', '1.1']);  
  }

  void navigateToPlotPage() {
    Navigator.of(context).pushNamed(PlotPage.routeName, arguments: dataList);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Sample'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 12.0),
            if (progressPercentage<100 && progressPercentage>0.0)
              Text(
                    '${(((dataCount-1) / 10) * 100.0).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            SizedBox(height: 12.0),
              if (progressPercentage==0.0)
                Text(
                  'Enter IP Address:',
                  style: TextStyle(fontSize: 15.0),
                ),
              if (progressPercentage==0.0)
                Container(
                  alignment: Alignment.center,
                  child:TextFormField(
                    controller: _ipController,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'IP Address',
                    ),
                  ),
                ),
              SizedBox(height: 12.0),
              if (progressPercentage==0.0)
                Text(
                  'Connecting...',
                  style: TextStyle(fontSize: 15.0,
                  color: Colors.lightBlueAccent,
                  height: 2.5,),
                ),
            ElevatedButton(
              onPressed: () {  
                connectToSocket();
                _saveNumber(number);
                print('start pressed');
              },
              child: Text('Start'),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('My Sample'),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
              },
            ),
            ListTile(
              title: const Text('Resulted graph'),
              onTap: () {
                Navigator.pushNamed(context, PlotPage.routeName, arguments: dataList);
              },
            ),
            ListTile(
              title: const Text('Help'),
              onTap: () {
                Navigator.pushNamed(context, '/help');
              },
            ),
            ListTile(
              title: const Text('About'),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DataArguments {
  final List<List<String?>> dataList;
  final double value;

  DataArguments(this.dataList, this.value);
}

class PlotPage extends StatelessWidget {
  static const routeName = '/plot';
  final GlobalKey chartKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    final dataList = arguments is List<List<String?>> ? arguments : [];

    final data = dataList.map((entry) {
      final x = double.tryParse(entry[1]!);
      final y = double.tryParse(entry[2]!);
      if (x != null && y != null) {
        return _ChartData(x, y);
      } else {
        return null;
      }
    }).whereType<_ChartData>().toList();

    final series = [
      charts.Series<_ChartData, double>(
        id: 'Data',
        domainFn: (_ChartData data, _) => data.x,
        measureFn: (_ChartData data, _) => data.y,
        data: data,
      ),
    ];

    final chart = RepaintBoundary(
      key: chartKey,
      child: charts.LineChart(
        series,
        animate: true,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Resulted graph'),
      ),
      body: 
      Row(
          children: [
            Expanded(
              flex: 0,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RotatedBox(
                      quarterTurns: -1,
                      child: Text('y (a.u.)',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[ 
                      Text(
                        'Sample plot',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                        Expanded(
                          child: RepaintBoundary(
                            key: chartKey,
                            child: Container(
                              color: Colors.white, 
                              child: SizedBox(
                                child: chart,
                              ),
                            ),
                          ),
                        ),
                      Text(
                        'x (a.u.)',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 8),
                      IconButton(
                        onPressed: () => _saveChartAsImage(chartKey),
                        icon: Icon(Icons.save),
                      ),
                      Text('Save graph'),
                    ],
                  ),
              ),
            ),
          ],
        ),
    );
  }
} 

Future<void> _saveChartAsImage(GlobalKey chartKey) async {
  try {
    RenderRepaintBoundary boundary =
        chartKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();

    // Create a new canvas with a white background
    final size = ui.Size(image.width.toDouble(), image.height.toDouble());
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    canvas.drawColor(Colors.white, BlendMode.src);
 
    // Draw the chart image on the canvas
    final paint = Paint();
    paint.filterQuality = FilterQuality.high;
    final rect = ui.Rect.fromLTRB(0, 0, size.width, size.height);
    canvas.drawImageRect(image, rect, rect, paint);

    // Create a new canvas to draw the texts on the image
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas2 = Canvas(recorder);

    // Set the text properties
    TextPainter textPainter = TextPainter(
      // textDirection: TextDirection.ltr,
    );
    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: 12,
    );

    // Draw the texts on the image
    textPainter.text = TextSpan(
      text: 'y (a.u.)',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
    textPainter.layout();
    canvas2.save();
    canvas2.rotate(-math.pi / 2); // Rotate by -90 degrees
    textPainter.paint(canvas2, Offset(-270, 0)); // Adjust position as needed
    canvas2.restore();

    textPainter.text = TextSpan(
      text: 'Sample plot',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas2, Offset(150, 0));

    textPainter.text = TextSpan(
      text: 'x (a.u.)',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas2, Offset(150, 400));

    // Convert the canvas to an image
    ui.Image resultImage = await recorder.endRecording().toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
    ByteData? resultByteData = await resultImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List resultPngBytes = resultByteData!.buffer.asUint8List();

    var status = await Permission.storage.status;
    if (status.isGranted) {
      await ImageGallerySaver.saveImage(resultPngBytes);
      showDialog(
        context: chartKey.currentContext!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Chart Saved'),
            content: Text('The image has been saved to your gallery.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    } else {
      await Permission.storage.request();
      status = await Permission.storage.status;
      if (status.isGranted) {
        await ImageGallerySaver.saveImage(resultPngBytes);
        showDialog(
          context: chartKey.currentContext!,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Chart Saved'),
              content: Text('The image has been saved to your gallery.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Permission denied');
      }
    }
  } catch (e) {
    showDialog(
      context: chartKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred while saving the chart: $e.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

class _ChartData {
  final double x;
  final double y;
  _ChartData(this.x, this.y);
}

class HelpPage extends StatelessWidget {
  static const routeName = '/help';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                  'Any help is appreciated :)',
                  style: TextStyle(fontSize: 20.0,
                  color: Colors.cyan,
                  fontWeight: FontWeight.normal,
                  height: 1.5,),
                ),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  static const routeName = '/about';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                  'My Sample App',
                  style: TextStyle(fontSize: 20.0,
                  color: Colors.cyan,
                  fontWeight: FontWeight.normal,
                  height: 1.5,),
                ),
            Text(
                  'Copyright (C) 2024.',
                  style: TextStyle(fontSize: 15.0,
                  color: Colors.blueGrey,
                  height: 1.5,),
                ),
          ],
        ),
      ),
    );
  }
}

