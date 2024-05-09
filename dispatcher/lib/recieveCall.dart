import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:despinterface/dispatcher.dart';
import 'package:despinterface/mapScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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

class _ReceiveCallScreenState extends State<ReceiveCallScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
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
    _tabController = TabController(length: 2, vsync: this);
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

/*
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
*/
  String _currentMessage = '';
  List<String> messages = [];
  TextEditingController _messageController = TextEditingController();

  void _sendMessage(String message) {
    DateTime now = DateTime.now();
    String timestamp = DateFormat('HH:mm a').format(now);
    String messageWithTime = '$message - $timestamp';
    setState(() {
      messages.add(messageWithTime);
      _currentMessage = '';
      _messageController.clear();
    });
  }

  Widget _voluntaryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Row(
              children: [
                Text(
                  '     Voluntaries List',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        _voluntaryItem(' Touati nassim  '),
        _voluntaryItem(' chelghoum aya '),
        _voluntaryItem(' lanani ghania '),
        _voluntaryItem(' Hamma souheila '),
      ],
    );
  }

  Widget _voluntaryItem(String name) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Add functionality to call the voluntary
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(40, 40),
            backgroundColor: Color.fromRGBO(62, 99, 137, 1),
            foregroundColor: Colors.white,
          ),
          child: Icon(
            Icons.phone,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _receiveCallScreenContent() {
    return Container(
      color: const Color(0xFF333333), // Background color
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
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
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 75,
                                backgroundImage: NetworkImage(
                                    'https://via.placeholder.com/150'),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Name: ${personData['name']}' ??
                                    'Name: Unknown',
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
                              color: const Color.fromARGB(255, 62, 99, 137),
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
                              color: const Color.fromARGB(255, 62, 99, 137),
                              iconSize: 36,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            flex: 2,
            child: MapScreen(), // Adjust as needed
          ),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: ListView(
                    children: [
                      _voluntaryList(), // Add list of volunteers widget
                    ],
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        tabs: [
                          Tab(text: 'Discussion'),
                          Tab(
                              text:
                                  'Video call'), // Change the text as per your other feature
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              margin: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Discussion',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: messages.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  62, 99, 137, 1),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                messages[index],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _messageController,
                                          onChanged: (value) {
                                            setState(() {
                                              _currentMessage = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            hintText:
                                                'Type your message here...',
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          maxLines: null,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          _sendMessage(_currentMessage);
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Color.fromRGBO(62, 99, 137, 1),
                                          ),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                        child: Text('Send'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Placeholder for other feature
                            Container(
                              color: Colors.blue,
                              child: Center(
                                child: Text(
                                  'Other Feature Content',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                              // _remoteVideo(),
                            ),
                          ],
                        ),
                      ), // Add discussion and video call widgets here
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _receiveCallScreenContent(),
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
