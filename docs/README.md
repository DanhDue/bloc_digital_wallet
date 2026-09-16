# Flutter Super App Template — Documentation Hub

**Trung tâm điều hướng tài liệu kỹ thuật & quy chuẩn kiến trúc cho `bloc_digital_wallet`**

---

## 🤖 AI-Driven Development Workflow (`/epic-lifecycle`)

Mọi tác vụ phát triển — tính năng mới, refactor, hay sửa lỗi — đều được quản trị qua
**`/epic-lifecycle`**: quy trình 4 giai đoạn dành cho **Flutter, Android Native và iOS Native**.

| Giai đoạn | Skill | Output |
|-----------|-------|--------|
| 1 — Spec & Exploration | `d3nexus:brainstorming` | Approved design spec |
| 2 — HLD & Task Breakdown | `d3nexus:epic-designer` | HLD (en+vi) + BDD + Kanban tasks |
| 3 — Isolated Implementation | `d3nexus:epic-implementation` | TDD code in git worktree |
| 4 — Quality & Merge | `d3nexus:quality_check` + `finishing-a-development-branch` | Clean merge to develop |

| Platform | Template | Toolchain |
|----------|----------|-----------|
| 🟦 Flutter | `bloc_digital_wallet` | Melos + Mason (`pac_mvi_feature`, `pac_native_plugin`) |
| 🤖 Android Native | `android_digital_wallet` | Gradle + Dagger2 + WorkManager |
| 🍎 iOS Native | `ios_digital_wallet` | SPM + FactoryKit + BGTaskScheduler |

> All epics live in `.devtool/epic/<name>/` — design spec → HLD → BDD → task files —
> enabling full AI agent context reproduction in any session.

---

## 📚 Tài Liệu Theo Danh Mục

### 1. 🏗️ Kiến Trúc (Architecture)

Tài liệu quy chuẩn thiết kế và cấu trúc hệ thống:

- [Kiến trúc Clean + MVI & Dual-Mode](architecture/ARCHITECTURE.md) — Clean Architecture + MVI, phân vùng Monorepo, Dual-Mode (`enterprise` vs `lean`), `AppInitializer` pattern và quy tắc module boundary.
- [Kiến trúc Mạng & Retrofit Client](architecture/NETWORKING.md) — Network package, Dio interceptors, SSL Pinning, Token Refresh Mutex, BaseResponse và xử lý lỗi phân tầng.
- [Thiết kế hệ thống Refresh Token](architecture/REFRESH_TOKEN_DESIGN.md) — Concurrency mutex locking, Token Rotation và lưu trữ bảo mật Keychain/Keystore.

### 2. 🔬 Phân Tích Kỹ Thuật (Technical Analysis) — NEW

Các quyết định kiến trúc chuyên sâu được distill từ epics, và bản đồ requirements:

- [Super App Overview & Maturity Scorecard (EN)](technical-analysis/OVERVIEW.en.md) | [VI](technical-analysis/OVERVIEW.vi.md) — Tổng quan kiến trúc, 4 trụ cột quản trị cốt lõi, bảng điểm trưởng thành 88.5%, phân tích khoảng cách kỹ thuật Flutter vs Android DFM.
- [Flutter Super App Production Roadmap (EN)](technical-analysis/flutter_production_roadmap.en.md) | [VI](technical-analysis/flutter_production_roadmap.vi.md) — Lộ trình kỹ thuật sản xuất toàn diện: Lean Core, Quản trị RAM/ImageCache 25% cap, Permission Broker, giải quyết 3 bài toán sống còn, Backlog 7 lĩnh vực, Ma trận P0–P2 và Kế hoạch 8 bước.
- [Super App Requirements & Implementation Status](technical-analysis/super_app_requirements.md) — Bản đồ 4 trụ cột + 11 lĩnh vực → 59 requirements với implementation status (76.3% hoàn thành).
- [Logging System HLD](technical-analysis/logging_system.en.md) | [VI](technical-analysis/logging_system.vi.md) — D3NexusLogger, pluggable appenders, W3C trace context, headless native logging.
- [Super App Governance HLD](technical-analysis/super_app_governance.en.md) | [VI](technical-analysis/super_app_governance.vi.md) — 4-pillar framework, AppEventBus, module boundary CI, FeaturePublicRoutes.
- [DeepLink Engine HLD](technical-analysis/deeplink_engine.en.md) | [VI](technical-analysis/deeplink_engine.vi.md) — DeepLinkCoordinator, AuthGuard, native OS integration (App Links / Universal Links).
- [Resilience & Memory HLD](technical-analysis/resilience_and_memory.en.md) | [VI](technical-analysis/resilience_and_memory.vi.md) — AppCachedImage, MiniAppErrorBoundary, MemoryPressureObserver, OfflineBanner.

### 3. 🚀 Getting Started (Template Guides)

Hướng dẫn bắt đầu và sử dụng template:

- [Tạo dự án mới từ Template (VI)](getting-started/create-new-project-from-template.vi.md) | [EN](getting-started/create-new-project-from-template.en.md) — Quy trình 4 bước: rename, Dual-Mode, secureFiles, chạy app.
- [Hướng dẫn sử dụng Template theo Use Case (VI)](getting-started/template-usage-guide.vi.md) | [EN](getting-started/template-usage-guide.en.md) — Tạo feature, shared library, native plugin, subfeature.
- [Quick Reference](getting-started/QUICK_REFERENCE.md) — Commands, Mason bricks, Melos scripts, code templates.

### 4. ⚙️ Development (Tool Guides)

Hướng dẫn công cụ và hạ tầng:

- [Cấu hình môi trường & Flavors](development/ENVIRONMENT_SETUP.md) — Thiết lập `dev`/`stg`/`prd`, mã hóa secureFiles, `--dart-define-from-file`.
- [Lệnh Melos & CodeGen Pipeline](development/MELOS_COMMANDS.md) — Quản trị monorepo, `genAlls.sh`, `genChanged.sh`.
- [Quản lý giao diện (ThemeTailor)](development/THEME_TAILOR_GUIDE.md) — Design system & theme tokens qua `context.appThemes`.
- [Đa ngôn ngữ Type-Safe (Slang)](development/SLANG_LOCALIZATION_GUIDE.md) — Quản lý bản dịch qua `context.coreT`, cấu hình Slang.

### 5. 📋 Cheat Sheets (Quality Audit Source) — NEW

Nguồn tổng hợp cho quality audit skills:

- [Flutter Quality Rules](cheat-sheets/FLUTTER_QUALITY_RULES.md) — 8 rule sets (MVI naming, architecture layers, anti-patterns, theme, i18n, networking, token security, DI). Used by `flutter-ui-audit`, `architecture-audit`, `code-health-audit`, `security-audit`.

---

## 📁 Cấu Trúc Thư Mục

```
docs/
├── README.md                              # File này — navigation hub
│
├── architecture/                          # 🏗️ Kiến trúc cốt lõi
│   ├── ARCHITECTURE.md                    # Clean Architecture + MVI + Dual-Mode
│   ├── NETWORKING.md                      # Network package + Dio + Retrofit
│   └── REFRESH_TOKEN_DESIGN.md            # Token refresh + Mutex + Secure Storage
│
├── technical-analysis/                    # 🔬 Phân tích kỹ thuật chuyên sâu (NEW)
│   ├── OVERVIEW.(en|vi).md                # Đánh giá tổng quan & Maturity Scorecard (Focus)
│   ├── flutter_production_roadmap.(en|vi).md # Lộ trình kỹ thuật sản xuất Flutter Super App
│   ├── super_app_requirements.md          # 4-pillar + 11 domains → 59 requirements + status
│   ├── logging_system.(en|vi).md          # D3NexusLogger HLD
│   ├── super_app_governance.(en|vi).md    # Governance framework HLD
│   ├── deeplink_engine.(en|vi).md         # DeepLink router engine HLD
│   └── resilience_and_memory.(en|vi).md   # Resilience & memory HLD
│
├── getting-started/                       # 🚀 Template guides
│   ├── create-new-project-from-template.(en|vi).md
│   ├── template-usage-guide.(en|vi).md
│   └── QUICK_REFERENCE.md                 # Commands + Mason + code templates
│
├── development/                           # ⚙️ Tool guides
│   ├── ENVIRONMENT_SETUP.md               # Flavors + secureFiles
│   ├── MELOS_COMMANDS.md                  # Melos + CodeGen pipeline
│   ├── THEME_TAILOR_GUIDE.md              # ThemeTailor API + how-to
│   └── SLANG_LOCALIZATION_GUIDE.md        # Slang i18n + how-to
│
└── cheat-sheets/                          # 📋 Quality audit source (NEW)
    └── FLUTTER_QUALITY_RULES.md           # 8 rule sets for quality audit skills
```
