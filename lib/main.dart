import 'package:flutter/material.dart';
import 'package:mqtt_chat_example/MQTTHelper.dart';
import 'package:provider/provider.dart';

import 'LoginScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider<MQTTHelper>(create: (_) => MQTTHelper()),
        ],
      child: MaterialApp(
        title: 'maliaydemir MQTT Chat Example',
        theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
        home: MultiProvider(
            providers:[
            ChangeNotifierProvider<MQTTHelper>(create: (_) => MQTTHelper()),
            ],
            child: LoginScreen(),
          ),
      ),
    );
  }
}

InputDecoration inputDecoration(String hintText, {Color? color}) {
  return InputDecoration(
    hintStyle: const TextStyle(color: Colors.black),
    suffixStyle: const TextStyle(color: Colors.black54),
    filled: true,
    fillColor: color ?? Colors.amberAccent[100],
    hintText: hintText,
    contentPadding: const EdgeInsets.all(15),
    border: InputBorder.none,
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.amber),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
