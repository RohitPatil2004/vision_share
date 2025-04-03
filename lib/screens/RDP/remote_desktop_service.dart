import 'dart:convert';
import '../signaling.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class RemoteDesktopService {
  final Signaling signaling = Signaling();
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> initialize() async {
    peerConnection = await createPeerConnection(signaling.configuration);
    registerPeerConnectionListeners();
  }

  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE gathering state changed: $state');
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      print('Connection state change: $state');
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      print("Add remote stream");
      remoteStream = stream;
      signaling.onAddRemoteStream?.call(stream); // Notify signaling about the new remote stream
    };
  }

  Future<void> openScreenShare() async {
    localStream = await navigator.mediaDevices.getDisplayMedia({'video': true, 'audio': true});
    signaling.localStream = localStream;

    // Add local stream tracks to the peer connection
    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });
  }

  Future<void> hangUp() async {
    localStream?.getTracks().forEach((track) {
      track.stop();
    });
    remoteStream?.getTracks().forEach((track) {
      track.stop();
    });
    await peerConnection?.close();
  }

  Future<void> disconnect() async {
    await hangUp(); // Ensure we hang up before disconnecting
    peerConnection = null; // Clear the peer connection
    localStream = null; // Clear the local stream
    remoteStream = null; // Clear the remote stream
  }

  Future<String> createUserId() async {
    String userId = DateTime.now().millisecondsSinceEpoch.toString();
    await firestore.collection('users').doc(userId).set({'userId': userId});
    return userId;
  }

  Future<void> dispose() async {
    await disconnect(); // Call disconnect to clean up resources
  }

  Future<bool> connect(String uniqueId) async {
    try {
      // Create an offer
      RTCSessionDescription offer = await peerConnection!.createOffer();
      await peerConnection!.setLocalDescription(offer);

      // Send the offer to the remote peer
      await firestore.collection('rooms').doc(uniqueId).set({
        'offer': {
          'sdp': offer.sdp,
          'type': offer.type,
        },
      });

      // Listen for the answer from the remote peer
      firestore.collection('rooms').doc(uniqueId).snapshots().listen((snapshot) {
        if (snapshot.exists) {
          var data = snapshot.data();
          if (data != null && data['answer'] != null) {
            var answer = RTCSessionDescription(data['answer']['sdp'], data['answer']['type']);
            peerConnection!.setRemoteDescription(answer);
          }
        }
      });

      return true; // Indicate success
    } catch (e) {
      print("Error connecting to remote desktop: $e");
      return false;
    }
  }
}