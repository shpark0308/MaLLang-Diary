import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CallerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CallerPage();  // 실제 UI를 그릴 _CallerPage로 이동
  }
}

class _CallerPage extends State<CallerPage> {
  late AudioPlayer audioPlayer;
  Color _backgroundColor = Color(0xFF163345);
  Random random = Random();
  String _caller = "";
  String areaCode = "310";
  String prefix = "";
  String lastFour = "";
  List callerList = [
    "Mom",
    "Dog",
    "Wife",
    "Girlfriend",
    "Husband",
    "Boyfriend",
    "OtherHusband",
    "Garbage Man",
    "Bobs Big Shake of Bananas",
  ];
  bool _ringing = false;


  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
  }

  void _start() {
    int callerIndex = random.nextInt(callerList.length); // 우리 것은 이 Random 을 사용할 필요가 없을 것같음
    int pre = random.nextInt(899) + 100;
    int lf = random.nextInt(8999) + 1000;
    setState(() {
      prefix = pre.toString();
      lastFour = lf.toString();
      _caller = callerList[callerIndex];

    });
    _ring();
  }

  void _ring() async {
    // (1). 소스 코드
    _ringing = true;
    do {
      await audioPlayer.play(AssetSource("sample_music.mp3"));
      await Future.delayed(Duration(seconds: 3));
    } while(_ringing);

    // (2). play 에러난 부분 고치기 ( _ringing  하는 동안 반복 재생 )
    // 그러면 몇번 음악이 울리고 멈출 것인지에 대한 정책도 반영되어야 함
    /*_ringing = true;
    await audioPlayer.play(AssetSource("sample_music.mp3"));
    audioPlayer.onPlayerComplete.listen((event) async{
      if ( _ringing ){
        await Future.delayed(Duration(seconds: 3));
        await audioPlayer.seek(Duration.zero); // 처음부터 재생
        audioPlayer.resume(); // 재생
      }
    });*/

  }

  void _stopRing() {
    audioPlayer?.stop();
    _ringing = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // 디버그 배너 숨기기
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),  // 텍스트 색상 적용
        primarySwatch: Colors.blue,  // 기본 테마 색상
        visualDensity: VisualDensity.adaptivePlatformDensity,  // 화면 밀도에 맞게 적응
      ),
      home: Scaffold(
        backgroundColor: _backgroundColor,
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "CALLER",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 50),
                ),
                Text(
                  "$areaCode-$prefix-$lastFour",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 2.2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.alarm, color: Colors.white, size: 30),
                        Text("Remind Me"),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.message, color: Colors.white, size: 30),
                        Text("Message"),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          child: FloatingActionButton(
                            child: Icon(Icons.call_end, size: 34),
                            backgroundColor: Colors.red,
                            onPressed: null,
                          ),
                        ),
                        Text("Decline"),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: _stopRing,
                          child: FloatingActionButton(
                            child: Icon(Icons.phone, size: 34),
                            backgroundColor: Colors.green,
                            onPressed: null,
                          ),
                        ),
                        Text("Accept"),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 60),
                ElevatedButton(
                  //onPressed: start,  // 버튼이 눌렸을 때 실행할 함수

                  onPressed: () {  },
                  child: Text("TEMP START"),  // 버튼에 표시될 텍스트
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}