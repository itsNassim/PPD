import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

const appId = "9184bc7d6d244525a0603fff92d33104";
const token =
    "007eJxTYAiI2nfMm+39j/xvLHMWt3mbhHO8/2Y0+Vb9HXmpt6HWn80VGCwNLUySks1TzFKMTExMjUwTDcwMjNPS0iyNUoyNDQ1M6mOs0xoCGRkWirsyMjJAIIjPwZCckZiXl5pjyMAAAMtpH9I=";
const channel = "channel1";

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key? key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  CameraDirection _cameraDirection = CameraDirection.cameraFront;
  bool _isCameraOn = false; // Set default to false
  bool _isSwitchCameraEnabled = false; // Default to false

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, // Remove the app bar
      body: Stack(
        children: [
          Center(
            child: centerWidget(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0, left: 25),
              child: SizedBox(
                width: 100,
                height: 150,
                child: Center(
                  child: _localUserJoined && _isCameraOn
                      ? AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: _engine,
                            canvas: const VideoCanvas(uid: 0),
                          ),
                        )
                      : dispatcherPic(),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25.0, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      _toggleCamera();
                    },
                    icon: Icon(
                      _isCameraOn ? Icons.videocam : Icons.videocam_off,
                      size: 44,
                      color: _isCameraOn ? Colors.blue : Colors.grey,
                    ),
                  ),
                  SizedBox(
                      width:
                          20), // Add space between the second and third button
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.call_end,
                      size: 44,
                      color: Colors.redAccent,
                    ),
                  ),
                  SizedBox(
                      width:
                          20), // Add space between the first and second button
                  IconButton(
                    onPressed: _isSwitchCameraEnabled
                        ? () {
                            _switchCamera();
                          }
                        : null,
                    icon: Icon(
                      Icons.cameraswitch_outlined,
                      size: 44,
                      color: _isSwitchCameraEnabled ? Colors.blue : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }

  void _switchCamera() {
    setState(() {
      _cameraDirection = _cameraDirection == CameraDirection.cameraFront
          ? CameraDirection.cameraRear
          : CameraDirection.cameraFront;
    });
    _engine.switchCamera();
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

  void _toggleCamera() {
    setState(() {
      _isCameraOn = !_isCameraOn;
      _isSwitchCameraEnabled =
          _isCameraOn; // Enable switch camera button if camera is on
    });
    _isCameraOn ? _engine.enableVideo() : _engine.disableVideo();
  }

  Widget dispatcherPic() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
        border: Border.all(color: Colors.black, width: 1), // Black stroke
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Image.asset(
          'lib/assets/maleAvatar.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }

  Widget centerWidget() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'lib/assets/dispatcher.png',
            width: 200,
            height: 200,
          ),
          SizedBox(height: 10), // Add spacing between the image and text
          Text(
            _remoteUid != null ? 'Connected' : 'Waiting...',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
