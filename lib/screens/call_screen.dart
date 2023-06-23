import 'package:flutter/material.dart';
import "package:videosdk/videosdk.dart";

import '/models/user.dart';
import '/models/image.dart' as imgMdl;
import '/utils/video_sdk_utils.dart';
import '/tiles/participant_tile.dart';

class CallScreen extends StatefulWidget {
  final String meetingId;
  final User user;
  final imgMdl.Image image;

  const CallScreen({super.key, required this.meetingId, required this.user, required this.image});

  @override
  State<CallScreen> createState() => CallScreenState();
}

class CallScreenState extends State<CallScreen> {
  late Room _currentRoom;
  late List<bool> _expandableState;
  Map<String, Participant> participants = {};
  bool _micEnabled = false;
  bool _camEnabled = false;

  @override
  void initState() {
    _currentRoom = VideoSDK.createRoom(
        roomId: widget.meetingId,
        token: videoSDKtoken,
        displayName: widget.user.login!,
        micEnabled: _micEnabled,
        camEnabled: _camEnabled,
        defaultCameraIndex: 1);
    _setMeetingEventListener();
    _currentRoom.join();
    _expandableState = List.generate(1, (index) => false);
    super.initState();
  }

  void _setMeetingEventListener() {
    _currentRoom.on(Events.roomJoined, () {
      setState(() {
        participants[_currentRoom.localParticipant.id] = _currentRoom.localParticipant;
      });
    });
    _currentRoom.on(Events.participantJoined, (Participant participant) => setState(() => participants[participant.id] = participant));
    _currentRoom.on(Events.participantLeft, (String participantId) {
      if (participants.containsKey(participantId)) {
        setState(() {
          participants.remove(participantId);
        });
      }
    });
    _currentRoom.on(Events.roomLeft, () {
      participants.clear();
      Navigator.pop(context);
    });
  }

  Future<bool> _onWillPop() async {
    _currentRoom.leave();
    return true;
  }

  Widget _flexableItem(double width, int index) {
    bool isExpanded = _expandableState[index];
    return GestureDetector(
      onTap: () {
        setState(() {
          _expandableState[index] = !isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: !isExpanded ? width * 0.6 : width * 1.2,
        height: !isExpanded ? width * 0.6 : width * 1.2,
        child: ParticipantTile(
          participant: participants.values.elementAt(index),
          image: widget.image,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        return _onWillPop();
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 38, 35, 55),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 13, 12, 17),
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text(
              'VideoCall',
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: participants.isEmpty
                  ? const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.transparent,
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 123, 118, 155),
                      ),
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        return ParticipantTile(
                          participant: participants.values.elementAt(index),
                          image: widget.image,
                        );
                      },
                      itemCount: participants.length,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RawMaterialButton(
                    onPressed: () {
                      _micEnabled ? _currentRoom.muteMic() : _currentRoom.unmuteMic();
                      setState(() {
                        _micEnabled = !_micEnabled;
                      });
                    },
                    shape: const CircleBorder(),
                    elevation: 2,
                    fillColor: _micEnabled ? Colors.deepPurple : Colors.white,
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      _micEnabled ? Icons.mic : Icons.mic_off,
                      color: _micEnabled ? Colors.white : Colors.deepPurple,
                      size: 20,
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      _currentRoom.leave();
                    },
                    shape: const CircleBorder(),
                    elevation: 2,
                    fillColor: Colors.redAccent,
                    padding: const EdgeInsets.all(15),
                    child: const Icon(
                      Icons.call_end,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      _camEnabled ? _currentRoom.disableCam() : _currentRoom.enableCam();
                      setState(() {
                        _camEnabled = !_camEnabled;
                      });
                    },
                    shape: const CircleBorder(),
                    elevation: 2,
                    fillColor: _camEnabled ? Colors.deepPurple : Colors.white,
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      _camEnabled ? Icons.videocam_rounded : Icons.videocam_off_rounded,
                      color: _camEnabled ? Colors.white : Colors.deepPurple,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
