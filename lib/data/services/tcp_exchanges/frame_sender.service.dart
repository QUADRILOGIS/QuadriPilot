import 'dart:convert';
import 'dart:io';

class FrameSenderService {
  final Socket socket;

  FrameSenderService(this.socket);

  void sendFrame(List<int> frame) {
    socket.add(frame);
  }

  void sendMessage(String message) {
    List<int> frame = utf8.encode(message);
    sendFrame(frame);
  }
}
