import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mqtt_web_app/NeoPixStrip.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

const String machineCode = "8d41a302a6c5c83599556bb362a6816f";

class LightChanger extends StatefulWidget {
  LightChanger({Key key}) : super(key: key);

  @override
  _LightChangerState createState() => _LightChangerState();
}

class _LightChangerState extends State<LightChanger> {
  Future mqttFuture;

  Icon connecting = Icon(
    Icons.settings_ethernet_outlined,
    color: Colors.white70,
    size: 60,
  );

  String _chosenValue = "banana";

  @override
  void initState() {
    super.initState();

    mqttFuture = _getMqtt();
  }

  onConnected() {
    print("HOLY CRAP THIS CONNECTED");
  }

  onDisconnected() {
    print("WTF IT DISCONNECTED");
  }

  onSubscribed(String sub) {
    print("We are subscribed to $sub");
  }

  Future<MqttBrowserClient> connect() async {
    MqttBrowserClient client =
        MqttBrowserClient('ws://mqtt.eclipseprojects.io/mqtt', 'itsame');
    client.port = 80;
    client.logging(on: false);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    // client.onUnsubscribed = onUnsubscribed;
    client.onSubscribed = onSubscribed;
    // client.onSubscribeFail = onSubscribeFail;
    // client.pongCallback = pong;
    // client.on

    // final connMessage = MqttConnectMessage()
    //     .authenticateAs('username', 'password')
    //     .keepAliveFor(60)
    //     .withWillTopic('willtopic')
    //     .withWillMessage('Will message')
    //     .startClean()
    //     .withWillQos(MqttQos.atLeastOnce);
    // client.connectionMessage = connMessage;

    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);

      // print('Received message:$payload from topic: ${c[0].topic}>');
    });

    return client;
  }

  _idLights() {
    final builder = MqttClientPayloadBuilder();
    String lightsOn =
        '{ "effect":"solid", "color": {"r": 255, "g":255, "b":255 } }';
    String lightsOff = '{ "effect":"solid", "color": {"r": 0, "g":0, "b":0 } }';

    // Subscribe to status to find current color
    mqttFuture.then((value) {
      value.subscribe('stat/8d41a302a6c5c83599556bb362a6816f/led1/color',
          MqttQos.atLeastOnce);

      for (int i = 0; i < 10; i++) {
        // Flash on
        builder.addString(lightsOn);
        value.publishMessage('cmnd/8d41a302a6c5c83599556bb362a6816f/led1/color',
            MqttQos.atLeastOnce, builder.payload);
        builder.clear();

        // Future.delayed(Duration(seconds: 1));

        // Flash off
        builder.addString(lightsOff);
        value.publishMessage('cmnd/8d41a302a6c5c83599556bb362a6816f/led1/color',
            MqttQos.atLeastOnce, builder.payload);
        builder.clear();
      }
    });
  }

  _getMqtt() async {
    MqttBrowserClient client = await connect();
    return client;
  }

  MqttBrowserClient client;
  MqttConnectionState connectionState;

  StreamSubscription subscription;

  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(50, 50, 50, .5),
        body: FutureBuilder(
            future: mqttFuture,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text("Wut");
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding: EdgeInsets.all(25), child: connecting)
                          ]),
                      Text(
                        "Connecting to NET Lab",
                        style: TextStyle(color: Colors.white70, fontSize: 24),
                      ),
                    ],
                  );
                case ConnectionState.done:
                  return Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                    child:
                                        Text("Change the dang lights will ya")),
                                FlatButton(
                                    color: Colors.green,
                                    onPressed: _idLights,
                                    child: Text("Identify Lightstrip"))
                              ]),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: ColorPicker(
                              onColorChanged: changeColor,
                              pickerColor: pickerColor,
                              showLabel: true,
                              pickerAreaHeightPercent: .8,
                              pickerAreaBorderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  DropdownButton<String>(
                                    value: _chosenValue,
                                    //elevation: 5,
                                    items: <String>['lbs', 'kgs', 'banana']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                        ),
                                      );
                                    }).toList(),
                                    hint: Text(
                                      "Unit",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        _chosenValue = value;
                                      });
                                    },
                                  ),
                                ],
                              )),
                          SingleChildScrollView(
                            child: Padding(
                                padding: EdgeInsets.all(5),
                                child: NeoPixStrip()),
                            scrollDirection: Axis.horizontal,
                          )
                        ],
                      ));
              }
            }));
  }
}
