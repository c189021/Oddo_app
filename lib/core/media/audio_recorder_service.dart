import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// Microphone recording for the speaking screens (baseline 측정, Step 1
/// 말하기). Records AAC(m4a) into the temp directory and hands back the file
/// path — Phase 4 uploads that file to the AI server for analysis.
///
/// Degrades silently: without permission (or in tests) [start] returns false
/// and [stop] returns null, so screens keep working as pure UI.
class AudioRecorderService {
  final AudioRecorder _recorder = AudioRecorder();

  bool _recording = false;

  bool get isRecording => _recording;

  /// Starts recording into `<tmp>/<fileName>.m4a`. False when unavailable.
  Future<bool> start({required String fileName}) async {
    try {
      if (_recording || !await _recorder.hasPermission()) return false;
      final dir = await getTemporaryDirectory();
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: '${dir.path}/$fileName.m4a',
      );
      _recording = true;
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Stops and returns the recorded file's path (null when nothing recorded).
  Future<String?> stop() async {
    if (!_recording) return null;
    _recording = false;
    try {
      return await _recorder.stop();
    } catch (_) {
      return null;
    }
  }

  Future<void> dispose() async {
    try {
      await _recorder.dispose();
    } catch (_) {
      // Platform channel unavailable (tests) — nothing to release.
    }
  }
}

/// One recorder per consumer — screens read this and manage start/stop within
/// their own lifecycle.
final audioRecorderProvider = Provider.autoDispose<AudioRecorderService>((ref) {
  final service = AudioRecorderService();
  ref.onDispose(service.dispose);
  return service;
});
