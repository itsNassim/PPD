import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const appId = "9184bc7d6d244525a0603fff92d33104";
const token =
    "007eJxTYAiI2nfMm+39j/xvLHMWt3mbhHO8/2Y0+Vb9HXmpt6HWn80VGCwNLUySks1TzFKMTExMjUwTDcwMjNPS0iyNUoyNDQ1M6mOs0xoCGRkWirsyMjJAIIjPwZCckZiXl5pjyMAAAMtpH9I=";
const channel = "channel1";

class ReceiveCallScreen extends StatefulWidget {
  const ReceiveCallScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ReceiveCallScreenState createState() => _ReceiveCallScreenState();
}

class _ReceiveCallScreenState extends State<ReceiveCallScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  String baseUrl = 'http://10.0.2.2:8000/authentication';
  String token = '5074be2cdca19a979d8ebe5f679b32207668ee30';
  Map<String, dynamic> personData = {};
  Map<String, dynamic> appuserData = {};

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = await createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
            @override
            void initState() {
              super.initState();
              fetchData();
            }
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
          Navigator.of(context).pop(true);
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();

    await _engine.joinChannel(
      token: token,
      channelId: channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> fetchData() async {
    try {
      final responseperson = await http.get(
        Uri.parse('$baseUrl/getPersonInfo/'),
        headers: {'Authorization': 'Token $token'},
      );

      final responseappuser = await http.get(
        Uri.parse('$baseUrl/getAppUserInfo/'),
        headers: {'Authorization': 'Token $token'},
      );

      if (responseperson.statusCode == 200 &&
          responseappuser.statusCode == 200) {
        setState(() {
          personData = json.decode(responseperson.body);
          appuserData = json.decode(responseappuser.body);
        });
      } else {
        throw Exception('Failed to load data: ${responseperson.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  Widget _remoteVideo() {
    if (_remoteUid != 0) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: appId),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'User',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(62, 99, 137, 1),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 75,
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/150'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Name: ${personData['name']}' ?? 'Name: Unknown',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Phone Number: ',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Blood Type:',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Age: ',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Gender: ',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Birthday: ',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Address: ',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.local_police),
                  color: Colors.white,
                  iconSize: 36,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.local_fire_department),
                  color: Color.fromRGBO(62, 99, 137, 1),
                  iconSize: 36,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.local_hospital),
                  color: Colors.white,
                  iconSize: 36,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.report),
                  color: Color.fromRGBO(62, 99, 137, 1),
                  iconSize: 36,
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class User {
  final String name;
  final String phoneNumber;
  final String bloodType;
  final int age;
  final String gender;
  final String birthday;
  final String address;

  User({
    required this.name,
    required this.phoneNumber,
    required this.bloodType,
    required this.age,
    required this.gender,
    required this.birthday,
    required this.address,
  });
}
