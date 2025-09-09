# VRCMX - VRChat 로그인 앱

## 🔐 실제 VRChat 계정 사용

**이제 실제 VRChat API를 사용합니다!**
- VRChat 계정의 **실제 아이디/비밀번호**를 입력하세요
- 2FA가 설정되어 있다면 2FA 인증도 지원됩니다

### ⚠️ 주의사항
- VRChat 계정 정보를 안전하게 보호하세요
- 너무 많은 로그인 시도시 일시적으로 차단될 수 있습니다
- 개발/테스트 목적으로만 사용하세요

## 🏗️ 아키텍처 (MVVM + Riverpod)

### 📂 프로젝트 구조
```
lib/
├── models/
│   ├── user.dart              # User, LoginRequest, LoginResponse 모델
│   └── auth_state.dart        # 인증 상태 (initial, loading, authenticated, requires2FA, error)
├── viewmodels/
│   └── auth_viewmodel.dart    # Riverpod 기반 로그인 로직
├── views/
│   ├── login_page.dart        # 메인 로그인 UI
│   └── two_factor_page.dart   # 2FA 인증 UI
├── services/
│   └── auth_service.dart      # VRChat API 인증 서비스 (실제 API 연동)
└── main.dart                  # 앱 엔트리포인트
```

## ✅ 구현된 기능

### 🔐 인증 시스템
- **실제 VRChat API** 연동 로그인
- HTTP Basic Authentication 구현
- 2FA 지원 (TOTP, Email OTP)
- 네트워크 에러 핸들링
- 로그아웃 기능

### 🎨 UI/UX
- Material Design 스타일
- 반응형 로딩 인디케이터
- 에러 스낵바 표시
- 2FA 다중 방법 선택 UI

### 📊 데이터 모델
- Freezed를 사용한 불변 데이터 클래스
- JSON 직렬화 지원
- 타입 안전한 상태 관리

## 🛠️ 기술 스택

### Core Framework
- **Flutter**: 크로스플랫폼 UI 프레임워크
- **Dart**: 프로그래밍 언어

### 상태 관리
- **flutter_riverpod**: 반응형 상태 관리
- **riverpod_annotation**: 코드 생성용 어노테이션
- **riverpod_generator**: 자동 Provider 생성

### 데이터 모델링
- **freezed**: 불변 데이터 클래스 생성
- **json_annotation**: JSON 직렬화
- **json_serializable**: JSON 코드 생성

### HTTP 통신
- **http**: VRChat API 호출
- **Basic Authentication**: Base64 인코딩
- **JSON 파싱**: VRChat 응답 처리

### 개발 도구
- **build_runner**: 코드 생성 도구
- **flutter_lints**: 코드 품질 검사

## 🔄 앱 플로우

1. **초기 화면**: 로그인 폼 표시
2. **로그인 시도**: 
   - 유효성 검사 → 로딩 → 인증 처리
   - 성공: 사용자 정보 표시
   - 2FA 필요: 2FA 페이지로 이동
   - 실패: 에러 메시지 표시
3. **2FA 인증** (필요시):
   - 방법 선택 (TOTP/Email/Recovery)
   - 코드 입력 → 검증 → 완료
4. **로그아웃**: 초기 상태로 복귀

## 🔧 개발 명령어

```bash
# 의존성 설치
flutter pub get

# 코드 생성
dart run build_runner build

# 앱 실행
flutter run

# 코드 분석
flutter analyze
```

## 🔗 VRChat API 연동

### API 엔드포인트
- **Base URL**: `https://api.vrchat.cloud/api/1`
- **Login**: `GET /auth/user` (Basic Auth)
- **2FA TOTP**: `POST /auth/twofactorauth/totp/verify` (Cookie Auth)
- **2FA Email OTP**: `POST /auth/twofactorauth/emailotp/verify` (Cookie Auth)
- **Logout**: `PUT /logout`

### Authentication Flow
```dart
// 1. Basic Authentication for login
final credentials = '$username:$password';
final encoded = base64Encode(utf8.encode(credentials));
final authHeader = 'Basic $encoded';

// 2. If requiresTwoFactorAuth response received:
// Extract auth cookie from Set-Cookie header

// 3. Cookie Authentication for 2FA
final headers = {
  'Content-Type': 'application/json',
  'Cookie': 'auth=$authCookie',
};
```

### 2FA Response Handling
```json
{
  "requiresTwoFactorAuth": ["totp", "otp"]
}
```

## 📝 참고사항

- **실제 VRChat API**와 연동되어 있음
- VRChat 계정 정보를 안전하게 관리하세요
- Rate Limiting에 주의하여 사용하세요
- MVVM 패턴으로 확장 가능한 구조
- 완전한 2FA 플로우 구현