/// Domain model for an authenticated user.
class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.nickname,
    this.onboardingDone = false,
  });

  final String id;
  final String email;
  final String nickname;

  /// Whether the user has finished baseline + psych test + persona onboarding.
  final bool onboardingDone;

  AppUser copyWith({
    String? id,
    String? email,
    String? nickname,
    bool? onboardingDone,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      onboardingDone: onboardingDone ?? this.onboardingDone,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as String,
        email: json['email'] as String,
        nickname: json['nickname'] as String,
        onboardingDone: json['onboardingDone'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'nickname': nickname,
        'onboardingDone': onboardingDone,
      };
}
