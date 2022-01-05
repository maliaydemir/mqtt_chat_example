import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:provider/provider.dart';
import 'package:mqtt_chat_example/MQTTHelper.dart';
import 'package:mqtt_chat_example/Message.dart';
import 'package:mqtt_chat_example/main.dart';

class ChatScreen extends StatefulWidget {
  final String name;

  const ChatScreen({Key? key, required this.name}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  var textC=TextEditingController();

  var scrollC=ScrollController();


  @override
  void initState() {
    context.read<MQTTHelper>().initializeMQTTClient();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Consumer<MQTTHelper>(
                builder: (context, provider, child) {
                  if(provider.status?.state!=MqttConnectionState.connected) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.amber,
                      ),
                    );
                  }
                  Future.delayed(Duration(milliseconds: 100),(){scrollC.jumpTo(scrollC.position.maxScrollExtent);});
                  return ListView.builder(
                    key: UniqueKey(),
                    controller: scrollC,
                      itemCount: provider.messages.length,
                      itemBuilder: (_, i) {
                        var msg = provider.messages[i];
                        if (msg.name == widget.name) {
                          return ListTile(
                            trailing: Text(msg.message),
                          );
                        }
                        return ListTile(
                          title: Text(msg.name + ': ' + msg.message),
                        );
                      });
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                  decoration: inputDecoration('Message'),
                    controller: textC,
                  ),
                ),
                IconButton(onPressed: (){
                  if(textC.text.isNotEmpty){
                    var model=Message(name: widget.name, message: textC.text, type: 1);
                    context.read<MQTTHelper>().publish(jsonEncode(model));
                    textC.clear();
                  }
                }, icon: const Icon(Icons.send))
              ],
            )
          ],
        ),
      ),
    );
  }
}
