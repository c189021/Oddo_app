/// Who is speaking in a counseling message.
enum CounselSpeaker { oddo, user }

/// A single line in the Step 4 counseling chat log.
class CounselMessage {
  const CounselMessage({required this.speaker, required this.text});

  final CounselSpeaker speaker;
  final String text;
}

/// One counseling session attached to a diary date (screen 50).
class CounselSession {
  const CounselSession({
    required this.date,
    required this.startedAt,
    required this.endedAt,
    required this.messages,
  });

  final DateTime date;
  final DateTime startedAt;
  final DateTime endedAt;
  final List<CounselMessage> messages;
}
