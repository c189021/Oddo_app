import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The in-progress diary's transcript, carried from Step 2 (확인하기 — where
/// the user edits the STT text) to the final "기록 완료하기" save.
///
/// TODO(Phase 5): grow into a full draft (summary/keywords/scores/counsel
/// log) once the AI pipeline produces real values per step.
class DiaryDraft extends Notifier<String?> {
  @override
  String? build() => null;

  void setTranscript(String transcript) => state = transcript;

  void clear() => state = null;
}

final diaryDraftProvider =
    NotifierProvider<DiaryDraft, String?>(DiaryDraft.new);
