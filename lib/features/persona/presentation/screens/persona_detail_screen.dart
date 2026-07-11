import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../data/dummy/persona_dummy.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../../../widgets/app_background.dart';
import '../../../../widgets/oddo_chip.dart';
import '../../../../widgets/oddo_text_field.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/progress_dots.dart';
import '../../data/models/persona_config.dart';
import '../../data/persona_providers.dart';

/// Screen 30 — 챗봇 페르소나 설정 상세 (말투 / 성격 / 이름). 완료 시
/// `users/{uid}/meta/persona`에 저장 → 설정 완료 화면.
class PersonaDetailScreen extends ConsumerStatefulWidget {
  const PersonaDetailScreen({super.key});

  @override
  ConsumerState<PersonaDetailScreen> createState() =>
      _PersonaDetailScreenState();
}

class _PersonaDetailScreenState extends ConsumerState<PersonaDetailScreen> {
  bool _saving = false;
  int _toneIndex = 0; // default: 친근하고 따뜻한
  late final Set<int> _traits = {
    for (var i = 0; i < PersonaDummy.traits.length; i++)
      if (PersonaDummy.defaultTraits.contains(PersonaDummy.traits[i])) i,
  };
  late final TextEditingController _nameController =
      TextEditingController(text: PersonaDummy.defaultName);

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _toggleTrait(int i) => setState(() {
        _traits.contains(i) ? _traits.remove(i) : _traits.add(i);
      });

  Future<void> _saveAndContinue() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('챗봇 이름을 입력해주세요.')));
      return;
    }
    final config = PersonaConfig(
      name: name,
      tone: PersonaDummy.tones[_toneIndex].title,
      traits: [
        for (var i = 0; i < PersonaDummy.traits.length; i++)
          if (_traits.contains(i)) PersonaDummy.traits[i],
      ],
      updatedAt: DateTime.now(),
    );

    setState(() => _saving = true);
    try {
      await ref.read(personaRepositoryProvider).savePersona(config);
      if (mounted) await context.pushNamed(AppRoute.personaDone);
    } on AppException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final nameLength = _nameController.text.characters.length;
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                    onPressed: () {
                      if (context.canPop()) context.pop();
                    },
                  ),
                  const Expanded(
                    child: Text('페르소나 설정',
                        textAlign: TextAlign.center,
                        style: AppTypography.subtitle),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              const ProgressDots(count: 3, current: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.screenH,
                      AppSpacing.lg, AppSpacing.screenH, AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('1. 말투 선택', style: AppTypography.subtitle),
                      Gap.h12,
                      for (var i = 0; i < PersonaDummy.tones.length; i++) ...[
                        if (i > 0) Gap.h8,
                        _ToneCard(
                          tone: PersonaDummy.tones[i],
                          selected: _toneIndex == i,
                          recommended: i == 0,
                          onTap: () => setState(() => _toneIndex = i),
                        ),
                      ],
                      Gap.h24,
                      const Text('2. 성격 선택', style: AppTypography.subtitle),
                      Gap.h4,
                      const Text('원하는 만큼 선택할 수 있어요.',
                          style: AppTypography.caption),
                      Gap.h12,
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (var i = 0; i < PersonaDummy.traits.length; i++)
                            OddoChip(
                              label: PersonaDummy.traits[i],
                              selected: _traits.contains(i),
                              onTap: () => _toggleTrait(i),
                            ),
                        ],
                      ),
                      Gap.h24,
                      const Text('3. 이름 짓기', style: AppTypography.subtitle),
                      Gap.h12,
                      OddoTextField(
                        controller: _nameController,
                        hint: PersonaDummy.nameHint,
                        prefixIcon: Icons.smart_toy_outlined,
                        suffix: Text('$nameLength/${PersonaDummy.nameMaxLength}',
                            style: AppTypography.caption),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.screenH,
                    AppSpacing.xs, AppSpacing.screenH, AppSpacing.xs),
                child: PrimaryButton(
                  label: '다음',
                  loading: _saving,
                  onPressed: _saveAndContinue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToneCard extends StatelessWidget {
  const _ToneCard({
    required this.tone,
    required this.selected,
    required this.recommended,
    required this.onTap,
  });

  final PersonaTone tone;
  final bool selected;
  final bool recommended;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: selected ? AppColors.primarySoft : AppColors.surface,
          borderRadius: AppRadius.button,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 22,
              color: selected ? AppColors.primary : AppColors.border,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(tone.title,
                          style: AppTypography.body.copyWith(
                              fontWeight: FontWeight.w700,
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.textStrong)),
                      if (recommended) ...[
                        const SizedBox(width: 6),
                        const _RecommendBadge(),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(tone.description, style: AppTypography.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendBadge extends StatelessWidget {
  const _RecommendBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text('추천',
          style: AppTypography.caption.copyWith(
              color: AppColors.textOnPrimary, fontWeight: FontWeight.w700)),
    );
  }
}
