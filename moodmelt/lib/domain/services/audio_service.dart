import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();

  Future<void> playSound(String soundName) async {
    try {
      await _player.setAsset('assets/sounds/$soundName.mp3');
      await _player.play();
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  Future<void> playBreathIn() async {
    await playSound('breath_in');
  }

  Future<void> playBreathOut() async {
    await playSound('breath_out');
  }

  void dispose() {
    _player.dispose();
  }
}
