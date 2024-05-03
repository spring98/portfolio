import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/rain/model/index.dart';
import 'package:portfolio/rain/painter/index.dart';
import 'dart:ui' as ui;

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  final List<Raindrop> _raindrops = [];
  AnimationController? _controller;
  ui.Image? customImage;
  bool isOn = true;

  @override
  void initState() {
    super.initState();
    initializeAnimation();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PORTFOLIO'),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/background_santa.jpg',
              fit: BoxFit.fill,
            ),
          ),
          CustomPaint(
            painter: RainPainter(_raindrops, customImage),
          ),
          Positioned(
            right: 0,
            child: Switch(
              value: isOn,
              onChanged: (value) {
                setState(() {
                  print('value: ${value}');
                  isOn = value;
                  if (isOn) {
                    _controller?.repeat();
                  } else {
                    _controller?.stop();
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> initialize() async {
    initializeAnimation();
  }

  Future<void> initializeAnimation() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 1),
      );

      _controller?.addListener(() {
        // print(DateTime.now()); // 60프레임 나옴

        setState(() {
          // print(_raindrops.length);
          _raindrops.forEach((raindrop) {
            raindrop.y += raindrop.ySpeed;
            if (raindrop.y > MediaQuery.of(context).size.height) {
              raindrop.y = 0;
              raindrop.x =
                  Random().nextDouble() * MediaQuery.of(context).size.width;
            }
          });
        });
      });
      _controller?.repeat();

      // 최초 단 한번만 값을 초기화
      for (int i = 0; i < 20; i++) {
        _raindrops.add(
          Raindrop(
            Random().nextDouble() * MediaQuery.of(context).size.width,
            Random().nextDouble() * MediaQuery.of(context).size.height,
            2 + Random().nextDouble() * 1,
          ),
        );
      }

      _loadImage();
    });
  }

  void _loadImage() async {
    final ByteData data = await rootBundle.load('assets/snow.png');
    final bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes,
        targetWidth: 20, targetHeight: 20);
    final ui.FrameInfo fi = await codec.getNextFrame();
    setState(() {
      customImage = fi.image;
    });
  }
}
