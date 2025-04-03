import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../signaling.dart';

class RDPConnectionScreen extends StatefulWidget {
  final String uniqueId; // Unique ID passed from HomeScreen

  RDPConnectionScreen({required this.uniqueId});

  @override
  _RDPConnectionScreenState createState() => _RDPConnectionScreenState();
}

class _RDPConnectionScreenState extends State<RDPConnectionScreen> {
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool isCameraActive = false; // Track if the camera is active

  @override
  void initState() {
    super.initState();
    _initializeRenderers();
    _setupSignaling();
  }

  Future<void> _initializeRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  void _setupSignaling() {
    signaling.onAddRemoteStream = (stream) {
      _remoteRenderer.srcObject = stream; // Set the remote stream
      setState(() {});
    };
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    signaling.hangUp(); // Ensure to hang up when disposing
    super.dispose();
  }

  Future<void> _openCamera() async {
    if (!isCameraActive) {
      await signaling.openCamera(); // Open camera using signaling
      _localRenderer.srcObject = signaling.localStream; // Set local stream to renderer
      setState(() {
        isCameraActive = true; // Mark camera as active
      });
    }
  }

  Future<void> _disableCamera() async {
    if (isCameraActive) {
      signaling.localStream?.getTracks().forEach((track) {
        track.stop(); // Stop the camera track
      });
      signaling.localStream = null; // Clear the local stream
      _localRenderer.srcObject = null; // Clear the local renderer
      setState(() {
        isCameraActive = false; // Mark camera as inactive
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the size of the square based on the platform
    double squareSize = MediaQuery.of(context).size.width > 600 ? 400 : 100;

    return Scaffold(
      appBar: AppBar(title: Text("RDP Connection")),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Remote Video Renderer without border
                Container(
                  width: squareSize,
                  height: squareSize,
                  child: _remoteRenderer.srcObject != null
                      ? RTCVideoView(_remoteRenderer)
                      : Container(), // No black box
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        signaling.openScreenShare(_localRenderer);
                      },
                      child: Text("Share Screen"),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        signaling.hangUp(); // Hang up the call
                      },
                      child: Text("Hang Up"),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _openCamera, // Open camera when button is pressed
                      child: Text("Open Camera"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Local Video Renderer positioned at the bottom left
          Positioned(
            left: 20,
            bottom: 20,
            child: Container(
              width: squareSize,
              height: squareSize,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
              ),
              child: RTCVideoView(
                _localRenderer,
                mirror: true,
              ),
            ),
          ),
          // Disable Camera Button
          if (isCameraActive)
            Positioned(
              left: 20,
              bottom: 130, // Adjust position above the local video
              child: ElevatedButton(
                onPressed: _disableCamera,
                child: Text("Disable Camera"),
              ),
            ),
        ],
      ),
    );
  }
}