# mdk_app_theme

MDK 제품군에서 공유하는 ThemeData, 디자인 토큰, AdaptiveTheme 연동, Riverpod 상태, 브랜드 확장을 하나의 패키지로 제공합니다. Pretendard Variable(기본)과 Paperlogy 정적 폰트를 포함하고 있으며, ThemeRegistry/ThemeController 조합으로 앱별 DI와 상태 제어를 단순화했습니다.

---

## 0. 사전 요구 사항
- Flutter `>=3.24.0`, Dart `>=3.9.2`
- peer dependencies
  - `adaptive_theme: ^3.7.2`
  - `flutter_riverpod: ^3.0.3` (예제/문서에서 사용)
- 패키지 본체는 DI 프레임워크에 의존하지 않습니다. host 앱에서 사용하는 DI(get_it, Provider 등)는 자유롭게 선택하면 됩니다.

---

## 1. 설치 & Import

`pubspec.yaml` 예시:

```yaml
dependencies:
  adaptive_theme: ^3.7.2
  flutter_riverpod: ^3.0.3
  mdk_app_theme:
    git:
      url: https://github.com/your-org/mdk_app_theme.git
      ref: main
```

런타임에서는 단일 진입점 `package:mdk_app_theme/theme_utilities.dart`를 import 합니다.

```dart
import 'package:mdk_app_theme/theme_utilities.dart';
```

```
lib/
 └── src/
     ├── adapters          # AdaptiveTheme 플랫폼 추상화
     ├── brands            # ThemeBrand, brand registry
     ├── constants         # ThemeMetrics 등 상수
     ├── controller        # ThemeRegistry, ThemeController, providers
     ├── tokens            # AppColors/AppTypography
     └── widgets           # ThemeToggle 등 UI 컴포넌트
```

---

## 2. ThemeRegistry + getIt 구성

1. 앱 시작 시 ThemeRegistry 인스턴스를 준비합니다.
2. 기본 설정만 사용한다면 `ThemeRegistry.instance.ensureDefaults()`만 호출하면 됩니다. 커스텀 Adapter/Controller가 필요하면 아래와 같이 등록합니다.
3. `ProviderScope`에서 `themeRegistryProvider`를 override 합니다.

```dart
final ThemeRegistry registry = ThemeRegistry.instance;

void registerThemeDependencies() {
  registry.registerAdapter(const AdaptiveThemePlatformAdapter());
  registry.registerController(
    (ThemePlatformAdapter adapter) => ThemeController(adapter: adapter),
  );
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        themeRegistryProvider.overrideWithValue(registry),
      ],
      child: const MyApp(),
    );
  }
}
```

필요하면 `ThemeRegistry.instance.registerAdapter(...)` 혹은 `registerController(...)`로 원하는 구현을 주입하세요. `ensureDefaults()`가 자동으로 기본 구현을 등록하므로, 아무것도 등록하지 않아도 동작합니다. 테스트/앱에서 커스텀 의존성을 써야 하면 위 API를 사용해 원하는 시점에 교체하면 됩니다. (별도의 get_it이나 기타 DI 컨테이너는 host 앱 책임입니다.)

---

## 3. AdaptiveTheme 부트스트랩

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerThemeDependencies();
  final AdaptiveThemeMode initialMode =
      await AdaptiveTheme.getThemeMode() ?? AdaptiveThemeMode.light;

  runApp(
    ProviderScope(
      overrides: [
        themeRegistryProvider.overrideWithValue(ThemeRegistry.instance),
      ],
      child: AdaptiveTheme(
        light: AppTheme.light(isWebOverride: true),
        dark: AppTheme.dark(isWebOverride: true),
        initial: initialMode,
        builder: (lightTheme, darkTheme) => MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          home: const ThemeDemoHomePage(),
        ),
      ),
    ),
  );
}
```

AdaptiveTheme Builder 안에서는 `ThemeToggle`, `ThemeControllerState`를 사용해 UI 상태를 갱신합니다.

---

## 4. ThemeController 상태 사용

`themeControllerProvider`는 Core 로직, `themeControllerStateProvider`는 Riverpod Notifier API로 (모드/브랜드)을 제공합니다.

```dart
class ThemeChip extends ConsumerWidget {
  const ThemeChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeControllerState state = ref.watch(themeControllerStateProvider);
    final ThemeControllerNotifier notifier =
        ref.read(themeControllerStateProvider.notifier);

    return FilterChip(
      label: Text(state.brand.label),
      selected: state.isDark,
      onSelected: (_) => notifier.toggleTheme(context),
    );
  }
}
```

브랜드 변경 시 `notifier.changeBrand(context, brand: ThemeBrand.midnight)`를 호출하면 AdaptiveTheme가 즉시 새 팔레트를 로드합니다.
`ThemeBrand` 타입에는 `label` extension이 기본 제공되므로 README 예제처럼 `state.brand.label`을 바로 사용할 수 있습니다.

---

## 5. 폰트 전략 (Variable vs Static)

패키지에는 `AppFontFamily` 인터페이스와 두 가지 기본 전략이 포함되어 있습니다.

| 전략 | 클래스 | 특징 |
| --- | --- | --- |
| Pretendard Variable (기본) | `defaultVariableFontFamily` | `FontVariation` 기반 가변 폰트 |
| Paperlogy Static | `paperlogyFontFamily` | 폰트 가중치별 별도 TTF |

사용 예시:

```dart
final AppTypography typography =
    AppTypography.mobile(fontFamily: paperlogyFontFamily);
```

추가 폰트가 필요하면 `AppFontFamily`를 구현해 role별 weight/variation을 정의하고 host 앱 `pubspec.yaml`에 asset을 등록하세요.

---

## 6. 색상 커스터마이징/조회

### 6-1. 특정 컴포넌트 색상 오버라이드

`AppTheme.light/dark` 호출 시 `copyWith`를 사용해 원하는 ColorScheme 값을 교체할 수 있습니다.

```dart
final ThemeData customLight = AppTheme.light().copyWith(
  colorScheme: AppTheme.light().colorScheme.copyWith(
    secondary: const Color(0xFF00C9A7),
  ),
);
```

또는 위젯 단위에서 `Theme.of(context)` 기반 스타일을 복제해 특정 속성만 덮어쓸 수도 있습니다.

```dart
ElevatedButton(
  style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
    backgroundColor: WidgetStatePropertyAll(Colors.red),
  ),
  onPressed: () {},
  child: const Text('위험 작업'),
);
```

### 6-2. 현재 테마 색상을 가져와 위젯에 적용

`AppColors`를 직접 생성하거나 `Theme.of(context).colorScheme`/`Theme.of(context).textTheme`를 사용합니다.

```dart
final ThemeController controller = ref.read(themeControllerProvider);
final ThemeBrand brand = ref.read(themeControllerStateProvider).brand;
final AppColors colors = controller.isDarkMode(context)
    ? AppColors.dark(brand)
    : AppColors.light(brand);

Container(
  color: colors.primary,
  child: Text(
    '브랜드 전용 배경',
    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: colors.surface,
        ),
  ),
);
```

또는 단순히 `Theme.of(context).colorScheme.primary`처럼 ColorScheme에서 직접 값을 인용하면 됩니다.

--- 

## 6. 예제 앱

`example/mdk_app_theme_example.dart`는 아래 시나리오를 모두 보여줍니다.
- AdaptiveTheme + ProviderScope 구성
- ThemeToggle을 통한 라이트/다크 토글
- Dropdown으로 ThemeBrand(Default ↔ Midnight) 전환
- 브랜드/색상 preview 카드, 폰트 프리뷰 텍스트

샘플 앱을 실행해 구성을 확인한 뒤 자신의 앱에 필요한 부분만 복사하세요.

---

## 7. 테스트와 문서

- `flutter test`로 AppColors/AppTypography/AppTheme/ThemeRegistry/ThemeController 상태 검증을 수행합니다.
- 마이그레이션 절차는 `docs/theme_package_migration.md`에 정리되어 있으며, 상위 앱(web_dashboard 등)에서 단계별로 체크하세요.
- 설계/토큰 정책은 `/Users/poeticdev/workspace/web_dashboard/docs/theme_design.md` 및 `docs/theme_package_checklist.md`와 동기화합니다.

### 릴리스 전략 요약
- 버전 규칙: SemVer(`0.x` 기간에는 breaking 가능). 주요 변경 시 CHANGELOG에 새 섹션 추가 후 태그(`vX.Y.Z`).
- 브랜치: `main`(개발) → `release/x.y.z`(QA/문서) → 태그/배포 → main merge.
- 자세한 절차/Smoke test 체크리스트는 `docs/release_workflow.md`에 정리되어 있습니다.

---

## 8. FAQ

**Q. AdaptiveTheme 모드가 초기 브라이트니스와 다르게 표시됩니다.**  
A. 첫 화면 build 이후 `themeControllerStateProvider.notifier.refresh(context)`를 호출해 시스템 밝기를 동기화하세요.

**Q. 커스텀 폰트를 쓰고 싶습니다.**  
A. `AppFontFamily`를 구현하고 `AppTypography.web/mobile(fontFamily: ...)`에 주입한 뒤, `pubspec.yaml` `fonts` 섹션에 asset을 추가하세요.

**Q. 브랜드를 하나 더 추가하고 싶습니다.**  
A. `lib/src/brands` 하위에 새로운 토큰 파일을 만들고 `ThemeBrand` enum과 `ThemeBrandRegistry`에 등록하세요. README/Docs에도 동일 내용을 기록하세요.

---

## 9. 기여/문의
- 디자인 가이드: `/Users/poeticdev/workspace/web_dashboard/docs/theme_design.md`
- 테마 패키지 계획: `docs/theme_package_checklist.md`
- 마이그레이션 가이드: `docs/theme_package_migration.md`
- 릴리스 플로우: `docs/release_workflow.md`
- 기여 지침/Issue 템플릿: `CONTRIBUTING.md`, `.github/ISSUE_TEMPLATE/theme_change.md`
- 이슈나 제안은 MDK 디자인-플랫폼 스쿼드 Slack 채널 또는 PR로 공유해주세요.

행복한 테마 작업 되세요! 🎨
