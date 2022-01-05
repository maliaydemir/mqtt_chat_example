import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_chat_example/Message.dart';

class MQTTHelper with ChangeNotifier {
  MqttServerClient? _client;
  final String _identifier = UniqueKey().toString();
  final String _host = 'broker.hivemq.com';
  final String _topic = '/maliaydemir/chat';

  List<Message> messages = [];

  MqttClientConnectionStatus? get status => _client?.connectionStatus;

  void initializeMQTTClient() {
    _client = MqttServerClient(_host, _identifier);
    _client!.port = 1883;
    _client!.keepAlivePeriod = 20;
    _client!.onDisconnected = onDisconnected;
    _client!.autoReconnect=true;
    _client!.onAutoReconnected=onReconnected;
    _client!.secure = false;
    _client!.logging(on: true);

    _client!.onConnected = onConnected;
    _client!.onSubscribed = onSubscribed;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(_identifier)
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    _client!.connectionMessage = connMess;
    _client!.connect();
  }

  void onDisconnected() {
    print('MQTT Disconnected');
    notifyListeners();
  }

  void onConnected() {
    print('MQTT Connected');
    if(messages.length>0)
      return;
    _client!.subscribe(_topic, MqttQos.atLeastOnce);
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      var model = Message.fromJson(jsonDecode(pt));
      messages.add(model);
      notifyListeners();
    });
    notifyListeners();
  }

  void onSubscribed(String topic) {
    print('MQTT Subscribed to $topic');
  }

  void publish(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(_topic, MqttQos.exactlyOnce, builder.payload!);
  }

  void onReconnected() {
    notifyListeners();
  }
}
