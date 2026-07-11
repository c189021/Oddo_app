import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config_provider.dart';
import 'repositories/persona_repository.dart';

/// Swap point: dummy vs Firestore, chosen by [AppConfig].
final personaRepositoryProvider = Provider<PersonaRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.useDummyData) {
    return PersonaDummyRepository();
  }
  return PersonaFirestoreRepository();
});
