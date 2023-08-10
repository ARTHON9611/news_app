import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news_app/home.dart';

class Animate extends StatefulWidget {
  const Animate({super.key});

  @override
  State<Animate> createState() => _AnimateState();
}

class _AnimateState extends State<Animate> with TickerProviderStateMixin {
  dynamic controller;
  @override
  void initState() {
    // TODO: implement initState
    controller = FlutterGifController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      });
    });
    return Scaffold(
      body: Column(
        children: <Widget>[
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 60),
                    height: 250,
                    width: 250,
                    child: GifImage(
                      controller: controller,
                      image: const AssetImage("loading.gif"),
                    )),
                LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white, size: 30),
                Container(
                    margin: EdgeInsets.only(bottom: 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome To Our",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        Text(
                          "News App",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                        SizedBox(
                          height: 50,
                        )
                      ],
                    )),
                SpinKitSpinningLines(size: 90, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
