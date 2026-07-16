import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The in-progress diary run, carried across the write-flow steps until the
/// final "기록 완료하기" save.
///
/// - [transcript]: Step 2 (확인하기)에서 사용자가 수정한 대화 원문.
/// - [recordingPath]: Step 1 (말하기)에서 녹음된 음성 파일 경로 —
///   Phase 4에서 AI 서버 업로드/분석에 사용.
///
/// TODO(Phase 5): grow into a full draft (summary/keywords/scores/counsel
/// log) once the AI pipeline produces real values per step.
class DiaryDraftState {
  const DiaryDraftState({this.transcript, this.recordingPath});

  final String? transcript;
  final String? recordingPath;
}

class DiaryDraft extends Notifier<DiaryDraftState> {
  @override
  DiaryDraftState build() => const DiaryDraftState();

  void setTranscript(String transcript) => state = DiaryDraftState(
        transcript: transcript,
        recordingPath: state.recordingPath,
      );

  void setRecordingPath(String path) => state = DiaryDraftState(
        transcript: state.transcript,
        recordingPath: path,
      );

  void clear() => state = const DiaryDraftState();
}

final diaryDraftProvider =
    NotifierProvider<DiaryDraft, DiaryDraftState>(DiaryDraft.new);
