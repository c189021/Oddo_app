# Oddo Phase-2 로드맵 — 프로토타입 → 실제 동작 앱

> 확정된 방향 (2026-06-06 결정)
> - **백엔드**: Firebase(인증·DB·파일저장) + **Python FastAPI AI 서버**(음성/표정 분석·LLM 오케스트레이션) 하이브리드
> - **AI**: 자체 모델 없이 **외부 LLM API**(상담봇·감정분석·리포트) + 오픈소스(음성 librosa, 표정 MediaPipe)
> - **로그인**: **이메일/비밀번호 우선** (소셜은 추후)
> - **Text-to-Video 숏폼**: **마지막 단계로 미룸** (그 전까지 현재 UI 유지)
> - **탄카츄 캐릭터·앱 색상**: **맨 마지막까지 현재 그대로 유지** (최종 단계에서 일괄 교체)
>
> 진행 원칙: 위에서 아래로 순서대로. 각 Phase는 끝날 때마다 `dart fix --apply` → `flutter analyze` → `flutter test` 통과 필수 (CLAUDE.md §10).

---

## Phase 0 — 기반 공사 (모든 것의 전제)

- [ ] Firebase 프로젝트 생성 + FlutterFire CLI 연동 (`firebase_core`) — Android/iOS 등록
- [ ] 의존성 추가 (팀 합의 후 한 PR로): `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `shared_preferences`, `permission_handler`, `camera`, `record`, `speech_to_text`, `dio`, `video_player`
- [ ] flavor 완성: `main_prod.dart` 추가, `AppConfig.prod` 실값, 시크릿/키 관리 방식 결정(`--dart-define` 권장, 키를 레포에 커밋 금지)
- [ ] `core/network/api_client.dart` 구현 (dio 기반, AI 서버용 베이스클라이언트) + 예외 → `Failure` 매핑
- [ ] 로컬 영구 저장 래퍼 (`shared_preferences` 기반 `LocalStore`) — 이후 Phase에서 공용

## Phase 1 — 인증 (첫 로그인부터 실제로)

- [ ] Firebase Auth **이메일 가입/로그인/로그아웃/비밀번호 재설정** 실연결 (기존 auth repository 스캐폴드 사용, 화면은 이미 있음)
- [ ] 입력 검증 (이메일 형식, 비밀번호 규칙, 에러 메시지 — 5.로그인 실패 모달 연결)
- [ ] **로그인 유지/자동 로그인** + `route_guard.dart`의 `appRedirect` 구현 (스플래시 → 로그인 or 홈 분기)
- [ ] 마이페이지 실데이터(이메일/닉네임), 회원 탈퇴
- [ ] (추후) 소셜 로그인 — Google/Kakao/Apple 은 백로그로

## Phase 2 — 데이터 모델 & 영구 저장 (앱의 뼈대 데이터)

- [ ] Firestore 스키마 설계: `users/{uid}` + 하위 `diaries/{date}`, `reports/{date}`, `counsel_sessions/{date}`, `baseline_profile`, `persona`, `psych_results`
- [ ] **화면의 `*Dummy` 직접 읽기 → Repository/Provider 경유로 전환** (auth·diary 스캐폴드 패턴을 전 기능으로 확장, `AppConfig.useDummyData` 스위치로 더미/실데이터 전환 가능하게)
- [ ] **날짜별 콘텐츠 연결**: 일기상세/감정리포트/상담기록이 `viewingDateProvider` 날짜의 실제 데이터를 표시
- [ ] **영구 저장**: `recordedDaysProvider`(작성일 집합), 온보딩 완료, 페르소나 선택 → Firestore + 로컬 캐시 (재시작해도 유지)
- [ ] 심리테스트 결과 저장/이어하기 상태 저장

## Phase 3 — 디바이스 권한 & 미디어

- [ ] `permission_handler`로 **카메라/마이크 실제 OS 권한 요청** (9.권한 안내 화면과 연결, 거부 시 UX)
- [ ] **카메라 프리뷰** 연결: 통화형 화면들(11 튜토리얼 통화, 19 baseline 측정, 37 Step1, 44 Step4)의 내 화면 미리보기
- [ ] 마이크 **녹음 파이프라인** (`record`): baseline·Step1에서 음성 파일 확보 → Firebase Storage 업로드

## Phase 4 — AI 서버 & Baseline (논문 방법론의 심장)

- [ ] FastAPI 서버 스캐폴드 + 배포(Cloud Run 권장) — 별도 레포 or `server/` 디렉토리 (팀 결정)
- [ ] 엔드포인트: `POST /analyze/voice`(librosa: 피치/속도/에너지), `POST /analyze/face`(MediaPipe: 랜드마크/AU 근사), `POST /baseline`(측정 결과 → 프로필 산출)
- [ ] 앱 연동: baseline 측정 플로우(17~21)가 실제 녹음/영상 → 서버 분석 → `baseline_profile` 저장
- [ ] 일기 Step1의 음성/표정 분석도 같은 엔드포인트 재사용, baseline과 **비교값** 산출

## Phase 5 — 일기 루프의 AI (핵심 사용자 가치)

- [ ] **STT**: Step1 말하기 — 1차는 기기 STT(`speech_to_text`), 품질 필요 시 서버 Whisper로 교체 가능하게 경계 설계
- [ ] **Step2 확인하기**: LLM으로 대화 원문 → 요약/감정 키워드/감정 점수 생성 (AI 서버가 LLM 호출 프록시)
- [ ] **Step2 추가질문 챗**: LLM 대화 (일기 맥락 주입)
- [ ] **Step4 상담봇**: LLM + 페르소나 설정을 시스템 프롬프트로 반영, 상담 로그 저장
- [ ] **감정 리포트/행동 가이드 생성**: 상담 로그 + 분석값 + baseline 비교 → LLM 생성 → `reports/{date}` 저장
- [ ] Step3 영상 제작: **미룸** — 당분간 서버가 영상 요약 텍스트만 생성, 현재 플레이어 UI 유지

## Phase 6 — 심리테스트 & 페르소나 완성

- [ ] Big5/MBTI/성향 **채점 로직** 구현 + 결과 저장, 이어하기 실동작
- [ ] 페르소나 선택 → 저장 → **상담봇 시스템 프롬프트에 실제 반영** (챗봇 설정 화면에서 변경 가능)

## Phase 7 — 부가 기능 마감

- [ ] 알림: 일기 리마인더(로컬 알림 우선, FCM은 선택), 알림 목록 화면 실데이터
- [ ] 설정 화면들 실동작 (알림 on/off, 계정 관리 등)
- [ ] 숏폼 플레이어를 `video_player` 기반 실제 재생기로 (영상 파일이 생기는 시점에)

## Phase 8 — 최종 단계 (마지막에만)

- [ ] **Text-to-Video 결정/구현**: 실제 T2V API(Runway/Kling/Veo) vs 저비용 대체(이미지+자막 슬라이드쇼 mp4) — 예산 보고 결정
  - ★ **요구사항 (2026-07-14 확정): 생성 영상에 인물(캐릭터)의 립싱크 + 대사 오디오(한국어) 포함 목표.**
    단순 무음 영상이 아님 → 네이티브 오디오/립싱크를 지원하는 모델(예: Veo Fast/Standard)이 유리하고,
    미지원 모델(Kling/Runway)은 별도 TTS+립싱크 2단계 파이프라인 필요. 목표 길이 최대 1분
    (단일 생성은 8~10초 한계 → 세그먼트 이어붙이기, **구간 간 목소리·캐릭터 일관성**이 핵심 검증 항목).
- [ ] **탄카츄 실제 에셋 교체** — `grep -rn "교체 예정" lib` 49개 지점, `TANKACHU_POSES.md` 매핑대로
- [ ] **앱 색상/브랜딩 최종 반영** — `lib/theme/` 토큰만 바꾸면 전체 적용되는 구조임
- [ ] prod flavor 최종 점검, 아이콘/스플래시, 스토어 등록 준비

---

## 분업 제안 (features/ 폴더 단위, CLAUDE.md §11)

| 담당 | 영역 | 주요 Phase |
|---|---|---|
| A | 인프라 + auth (Firebase 셋업, 로그인, 가드) | 0, 1 |
| B | 데이터 레이어 (Firestore 스키마, repository 전환, 영구 저장) | 2 |
| C | AI 서버 (FastAPI, 음성/표정 분석, LLM 프록시) | 4, 5 |
| D | 디바이스/미디어 (권한, 카메라, 녹음) + 일기 플로우 연동 | 3, 5 |
| 공통 | 심리테스트/페르소나/알림은 위 작업과 독립적이라 병렬 가능 | 6, 7 |

> Phase 0·1·2가 끝나야 3~5가 매끄럽습니다. 0은 한 명이 빠르게 끝내고 공유하는 것을 권장.
