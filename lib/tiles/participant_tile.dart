import 'package:flutter/material.dart';
import 'package:videosdk/videosdk.dart';

import '/models/image.dart' as imgMdl;
import '/utils/image_utils.dart';

class ParticipantTile extends StatefulWidget {
  final imgMdl.Image image;
  final Participant participant;

  const ParticipantTile({super.key, required this.image, required this.participant});

  @override
  State<ParticipantTile> createState() => _ParticipantTileState();
}

class _ParticipantTileState extends State<ParticipantTile> {
  Stream? videoStream;

  @override
  void initState() {
    widget.participant.streams.forEach((key, Stream stream) {
      setState(() {
        if (stream.kind == 'video') {
          videoStream = stream;
        }
      });
    });
    _initStreamListeners();
    super.initState();
  }

  _initStreamListeners() {
    widget.participant.on(Events.streamEnabled, (Stream stream) {
      if (stream.kind == 'video') {
        setState(() {
          videoStream = stream;
        });
      }
    });
    widget.participant.on(Events.streamDisabled, (Stream stream) {
      if (stream.kind == 'video') {
        setState(() {
          videoStream = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: videoStream != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 300, vertical: 300),
              child: SizedBox(
                height: 200,
                width: 200,
                child: RTCVideoView(
                  mirror: true,
                  filterQuality: FilterQuality.high,
                  videoStream?.renderer as RTCVideoRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              ),
            )
          : const CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 100,
              child: Center(
                child: Icon(
                  Icons.person,
                  color: Colors.black,
                  size: 100,
                ),
              ),
            ),
    );
  }
}
