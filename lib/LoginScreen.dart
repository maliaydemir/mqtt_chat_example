import 'package:flutter/material.dart';

import 'ChatScreen.dart';
import 'main.dart';

class LoginScreen extends StatelessWidget {
  String name='';

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           const  Text('maliaydemir MQTT Chat Example',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),textAlign: TextAlign.center,),
            SizedBox(height: 8,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: inputDecoration('Username'),
                onChanged: (val){
                  name=val;
                },
              ),
            ),
            TextButton(onPressed: (){
              _login(context);
            }, child: Text('LOGIN',style: TextStyle(fontSize: 24,color: Colors.black),))
          ],
        ),
      ),
    );
  }
  _login(context){
    if(name.length>3){
      Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatScreen(name:name)));
    }
  }
}
