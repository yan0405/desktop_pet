import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';
import 'dart:async';

import 'package:window_manager/window_manager.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:system_tray/system_tray.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 必须加上这一行。
  await windowManager.ensureInitialized();

  const WindowOptions windowOptions = WindowOptions(
    size: Size(100, 100),
    // center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: true,
    // titleBarStyle: TitleBarStyle.hidden,
  );
  // print(await windowManager.isVisibleOnAllWorkspaces());

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setBackgroundColor(Colors.white.withOpacity(0.0));
    await windowManager.setOpacity(1);
    await windowManager.setResizable(true);
    await windowManager.setFullScreen(true);
    await windowManager.setAlwaysOnTop(true);
    await windowManager.setMovable(true);
    await windowManager.setVisibleOnAllWorkspaces(true);
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white.withOpacity(0.0),
      ),
      debugShowCheckedModeBanner: false,
      home: MainGif()));
}

class MainGif extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MainGif> createState() => _MainGifState();
}

class _MainGifState extends State<MainGif> {
  var curDx = 0.0;
  var curDy = 1345.0;
  var step = 1;
  var isTap = false;
  bool moveRight = true;
  bool isFlipped = true;
  var defaultGif = "assets/wukong.gif";
  var firstGif = "assets/wukong.gif";
  var secondGif = "assets/goku2.gif";
  @override
  void initState() {
    // 移动方向：true为向右，false为向左
// 0.04166666666
    // TODO: implement initState
    Timer.periodic(Duration(milliseconds: 42), (Timer timer) async {
      if (!isTap) {
        Display primaryDisplay = await screenRetriever.getPrimaryDisplay();
        // 获取屏幕可用高度
        var windowHeight = primaryDisplay.visibleSize?.height ?? 820;
        var windowWidth = primaryDisplay.visibleSize?.width ?? 2560;
        windowManager.getPosition().then((value) {
          // print('=====================');
          // print(value.dx);
          // print(value.dy);
          // print(moveRight);
          // print(isFlipped);
          // curDx = value.dx;
          // curDy = value.dy;
        });
        // print(windowHeight);
        // print(windowWidth);
        if (moveRight) {
          curDx = curDx + step;
          if (curDx > windowWidth - 100) {
            moveRight = false;
            isFlipped = true; // 当向右移动到边界时，设置翻转为true
          }
        } else {
          curDx = curDx - step;
          if (curDx <= 0) {
            moveRight = true;
            isFlipped = false; // 当向左移动到边界时，设置翻转为false
          }
        }
        setState(() {
          windowManager.setPosition(Offset(curDx, curDy));
        });
      }
    });
  }

  void changeGif() {
    setState(() {
      if (defaultGif == firstGif) {
        defaultGif = secondGif;
      } else {
        defaultGif = firstGif;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          changeGif();
        },
        onTapDown: (details) {
          windowManager.startDragging();
          isTap = true;
        },
        onTapUp: (details) {
          isTap = false;
        },
        child: Transform(
          // 这里使用Transform来根据isFlipped的值翻转图片
          alignment: Alignment.center,
          transform: Matrix4.rotationY(moveRight ? pi : 0),
          child: Image.asset(
            defaultGif,
            gaplessPlayback: true,
            // fit: BoxFit.cover,
            // 确保你的GIF背景是透明的
          ),
        ),
        // child: Image.asset(
        //   'assets/aa.gif',
        //   gaplessPlayback: true,
        //   // fit: BoxFit.cover,
        //   // 确保你的GIF背景是透明的
        // ),
      ),
    );
  }
}
