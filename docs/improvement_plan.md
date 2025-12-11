**작업 목적**
`mdk_app_theme` 패키지에서 `get_it`을 하드 의존성으로 포함하지 말고, 패키지를 **DI-agnostic(특정 DI 라이브러리에 독립)** 구조로 리팩터링해야 한다. DI 구성은 host 앱의 책임으로 남겨 둔다.

---

# 📌 해야 할 작업

## 1. `get_it` 하드 의존성 제거

* `pubspec.yaml`에서 `get_it`을 dependencies에서 제거한다.
* 예제(example) 앱에서 필요하면 **dev_dependency**로만 추가한다.
* 패키지 내부(lib/src) 어떤 파일에서도 `get_it` import를 제거한다.

---

## 2. ThemeController를 DI-agnostic하게 재구성

### 목표

`ThemeController`가 어떤 DI를 사용하든 상관 없도록 만들기.

### 작업 내용

1. `ThemeController` 생성자에 모든 의존성을 **명시적으로 전달받도록** 변경한다.

   * 저장소 역할(ThemeMode load/save)
   * 시스템 모드 감지(resolver)
   * AdaptiveTheme 연동 포인트 등
2. `ThemeController` 내부에서 get_it 호출이나 singleton 이동 등을 전부 제거한다.
3. 패키지 사용자(host 앱)는 다음과 같이 원하는 DI로 조립할 수 있어야 한다:

```dart
final controller = ThemeController(
  repository: LocalThemeRepository(),
  resolver: SystemThemeModeResolver(),
);
```

---

## 3. 제공되는 Provider도 DI 독립적으로 변경

현재 Riverpod Provider를 export하려고 하는데, 다음 형태로 정리한다:

* 패키지는 **기본 Provider factory**만 제공한다.
* 실제 Provider 등록 및 override는 host 앱이 결정한다.

예:

```dart
final themeControllerProvider =
    StateNotifierProvider<ThemeController, ThemeState>(
  (ref) => ThemeController.default(),
);
```

그리고 `.default()` 구현은 생성자 호출만 포함하게 한다:

```dart
ThemeController.default()
  : this(
      repository: AdaptiveThemeRepository(),
      resolver: DefaultThemeModeResolver(),
    );
```

→ 이렇게 하면 host 앱은 자유롭게 override 가능.

---

## 4. DI Helper는 필요하다면 별도 파일로 제공

만약 get_it과의 연동 convenience를 제공하고 싶으면:

* 패키지 기본 코드(lib/src)에서는 금지
* 대신 `lib/helpers/get_it_adapter.dart` 같은 **옵션 파일**에 아래 형식으로 제공

```dart
ThemeController registerThemeControllerWithGetIt(GetIt getIt) {
  final controller = ThemeController.default();
  getIt.registerSingleton<ThemeController>(controller);
  return controller;
}
```

→ 이 파일은 get_it에 의존하지만, **핵심 패키지는 영향을 받지 않음**
→ 필요하면 host 앱에서 선택적으로 import

---

## 5. README 문서에도 반영

* “This package is DI-agnostic. You may use get_it, Riverpod, or any other DI.”
* “Example uses get_it only for demonstration, but the core library has no dependency on it.”
* “Override ThemeController freely depending on your architecture”

---

# 📌 작업 완료 기준 (Acceptance Criteria)

* `mdk_app_theme/lib/src` 내부에서 `get_it` 단 한 줄도 import되지 않는다.
* `pubspec.yaml` dependencies에서 `get_it`이 제거되어 있다.
* ThemeController는 순수하게 생성자 기반 의존성 주입 구조로 되어 있다.
* Provider는 기본 형태만 제공하며, host 앱이 커스터마이징 가능하다.
* Example에서 get_it을 사용하더라도 패키지 본체에 영향이 없다.