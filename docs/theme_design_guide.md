# 디자인 시스템 색상 개선 가이드 (Methodology)

"촌스러운" 색상 조합을 해결하고 심미적이고 접근성 높은 UI를 만들기 위한 방법론을 제안합니다. 단순히 Hex 코드를 변경하는 것이 아니라, 체계적인 시스템(System)을 도입해야 합니다.

## 1. 지각적 균일 색 공간 (Perceptually Uniform Color Space) 도입

사람의 눈은 같은 채도/수치라도 파란색보다 노란색/초록색을 더 밝게 인식합니다. 기존 RGB/HSL 방식은 이를 반영하지 못해 색상 간 조화가 깨지기 쉽습니다.

- **제안**: **HCT (Hue, Chroma, Tone)** 또는 **OKLCH** 색 공간을 사용하세요.
- **이유**: 수치상의 밝기가 아닌 "사람 눈에 보이는 밝기(Tone)"를 기준으로 색을 정렬할 수 있어, 어떤 색상을 조합해도 일관된 대비(Contrast)를 유지할 수 있습니다.

## 2. 0-100 토날 팔레트 (Tonal Palette) 시스템

브랜드 컬러 하나(Key Color)를 선정하면, 그 색상에 대한 13~15단계의 밝기 변형(Tonal Palette)을 자동으로 생성하여 사용합니다.

- **Key Color 추출**: 브랜드의 메인 컬러 (예: Midnight Blue, Daylight Orange)
- **Palette 생성**:
  - 0 (Black) ~ 100 (White) 단계 생성.
  - 이때 Hue(색상)와 Chroma(채도)는 유지하되 Tone(밝기)만 변경합니다.

### 추천 매핑 공식 (Material 3 기반)

| Semantic Role  | Light Mode (Tone) | Dark Mode (Tone) | 이유                                             |
| -------------- | ----------------- | ---------------- | ------------------------------------------------ |
| **Primary**    | 40                | 80               | 다크 모드에서는 파스텔 톤(80)을 써야 눈이 편안함 |
| **On Primary** | 100 (White)       | 20               | 텍스트 가독성 확보                               |
| **Container**  | 90                | 30               | 은은한 강조 배경                                 |
| **Surface**    | 98~99             | 6~10             | 완전한 흰색/검은색 대신 틴트가 들어간 배경 사용  |

## 3. 브랜드별 구체적인 개선 전략

### 🌙 Midnight Brand (Dark Theme Focus)

현재 문제: 다크 모드에서도 Primary가 너무 쨍함(Light와 동일 값 사용), 배경이 단순한 검정/회색임.

- **Surface Tinting**: 배경색(Surface)을 `#121212` 같은 무채색 대신, **Primary Color가 5%~8% 섞인 아주 어두운 남색(Deep Navy)** 계열(Tone 6)을 사용하세요. 깊이감이 생기고 훨씬 고급스러워집니다.
- **Desaturated Primary**: 다크 모드의 포인트 컬러는 채도를 낮추고 명도를 높여(Tone 80) "형광등" 같은 느낌을 없애야 합니다.

### ☀️ Orange Day Brand (Light Theme Focus)

현재 문제: 이름은 "Orange"인데 Primary가 파란색(`0098D8`)임. 따뜻한 느낌 부족.

- **Identity Fix**: Primary Key Color를 **Deep Orange** 또는 **Terracotta** 계열로 변경하세요.
- **Warm Neutrals**: 배경색(Surface)을 차가운 흰색(`FFFFFF`) 대신, **Cream**이나 **Warm Grey** (노란끼가 아주 살짝 도는 회색) 톤으로 잡으세요. 종이 질감의 따뜻함을 줄 수 있습니다.
- **Complementary Accent**: 보조색(Secondary)으로 **Teal**이나 **Forest Green** 같은 차분한 청록색을 쓰면 주황색의 활기를 잡아주면서 세련된 보색 대비를 이룹니다.

## 4. 추천 도구 (Tools)

디자이너 없이도 수학적으로 아름다운 팔레트를 뽑을 수 있는 도구들입니다.

1.  **Material Theme Builder**: Key Color만 넣으면 다크/라이트 모드 전체 토큰을 HCT 기반으로 자동 생성해줍니다.
2.  **Adobe Color (Accessibility Tools)**: 대비비(Contrast Ratio)가 AA/AAA 등급을 만족하는지 실시간 확인 가능합니다.
3.  **Huemint**: 머신러닝을 사용하여 브랜드 컬러에 어울리는 배경/억양색 조합을 추천해줍니다.
