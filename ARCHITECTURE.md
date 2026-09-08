# Shifa — Architecture Guide

Shifa is a Flutter app for a hospital's operating-room scheduling workflow. This document explains how the codebase is organized, the patterns it follows, and how you can extend it. If you're new to the project, read this end-to-end before touching code — the conventions here are chosen deliberately, and knowing them saves you from re-inventing decisions later.

Assumed reader: a Flutter developer who has used `Provider` or `setState`, and has at least seen `flutter_bloc` before. You don't need to be an expert in Bloc, MVVM, or `go_router`.

---

## 1. Folder structure

```
lib/
├── main.dart                    ← boots the app, mounts AppContainer + AuthBloc
│
├── core/                        ← app-wide plumbing, no feature logic
│   ├── constants/               ← API paths, storage keys
│   ├── di.dart                  ← AppContainer — the composition root
│   ├── error/                   ← typed exceptions (ApiException, etc.)
│   ├── network/                 ← Dio client, interceptors, token storage
│   ├── router/                  ← go_router setup + route name constants
│   └── theme/                   ← colors, text styles, spacing, ThemeData
│
├── data/                        ← everything about talking to the backend
│   ├── models/                  ← plain Dart entities (Surgery, Patient, …)
│   └── services/                ← one class per resource group (AuthService, …)
│
├── blocs/                       ← one folder per feature Bloc
│   └── <feature>/
│       ├── <feature>_bloc.dart      ← the Bloc itself
│       ├── <feature>_event.dart     ← `part of` — sealed Event class
│       └── <feature>_state.dart     ← `part of` — State + status enum
│
├── screens/                     ← one folder per user role (or `shared`)
│   ├── admin/                   ← rooms_list, staff_list
│   ├── coordinator/             ← room_timeline, schedule_surgery, …
│   ├── surgeon/                 ← my_surgeries, surgery_detail
│   ├── login/
│   ├── notifications/
│   └── splash_screen.dart
│
└── widgets/                     ← shared, presentation-only widgets
    ├── primary_button.dart, app_card.dart, status_badge.dart
    ├── app_bottom_nav_bar.dart      ← role-aware nav
    └── loading_view.dart, error_view.dart, empty_view.dart
```

### Why this shape?

- **`core/` is the boring plumbing.** Anything a feature needs — a Dio client, a route name, a color — lives here. If you're deleting a feature, you should never need to touch `core/`.
- **`data/` is a pure translation layer.** Models mirror the API schema, services turn method calls into HTTP requests and back. They know nothing about Bloc, widgets, or navigation.
- **`blocs/` and `screens/` are always in lockstep.** Every feature Bloc has a matching screen and vice versa. This is easier to navigate than grouping "all blocs on one side, all screens on the other" once the app has more than a handful of features.
- **`widgets/` holds *shared* widgets only.** One-off widgets used by a single screen live inside that screen's file as private `_Foo` classes. That's a deliberate choice: it keeps the `widgets/` folder small and easy to reason about — everything in it is genuinely reusable.

---

## 2. The Bloc pattern in Shifa

We use `flutter_bloc`. Every feature has exactly one Bloc, and the Bloc obeys three rules:

1. **The Bloc never imports `package:flutter/*` widgets.** It knows about state and events, nothing about UI. This is the single most important rule — you can test the Bloc in a pure Dart environment, and swapping the UI stack out (say, to `flutter_web`) doesn't require touching the Bloc.
2. **Screens dispatch events; they never call services directly.** If a button needs to fetch data, its `onPressed` is `context.read<SomeBloc>().add(SomeEvent())`. Not `SurgeryService.list()`.
3. **Services know nothing about Bloc or UI.** They accept parameters, return futures, and throw typed exceptions. A service could be called from a CLI tool with no changes.

### 2.1 Data flow

Here is the round-trip for any user action:

```
   ┌────────┐  event   ┌──────────┐  method   ┌──────────┐  HTTP    ┌───────┐
   │ Screen │─────────▶│   Bloc   │──────────▶│ Service  │─────────▶│  API  │
   └────────┘          └──────────┘           └──────────┘          └───────┘
        ▲                    │                     │                    │
        │                    │                     │◀───JSON────────────┘
        │                    │                     │
        │                    │◀───Model / throws───┘
        │                    │
        │      state         │
        └────────────────────┘
```

- **UI → Event**: user taps a button; the widget calls `context.read<Bloc>().add(SomeEvent())`.
- **Event → Bloc**: the Bloc's registered handler runs. It calls a service.
- **Bloc → Service → API**: the service builds an HTTP request through the Dio client. The response is decoded into a model.
- **Service → Bloc**: the model comes back (or a typed `ApiException` is thrown).
- **Bloc → State**: the Bloc emits a new `State` describing the result (loaded / error / etc.).
- **State → UI**: the screen's `BlocBuilder` rebuilds with the new state.

The two arrows that matter most are **UI → Event** and **State → UI**. Everything else is implementation detail.

### 2.2 Naming conventions

Events, states, and status enums follow a fixed pattern:

| Kind      | Convention                              | Example                          |
| --------- | --------------------------------------- | -------------------------------- |
| Bloc      | `<Feature>Bloc`                         | `RoomTimelineBloc`               |
| Event     | `<Feature><Verb>[Requested]`            | `RoomTimelineRequested`, `RoomTimelineRefreshRequested`, `RoomTimelineRangeChanged` |
| State     | `<Feature>State`                        | `RoomTimelineState`              |
| Status    | `<Feature>Status` enum                  | `RoomTimelineStatus { initial, loading, loaded, error }` |
| Files     | `snake_case.dart`                       | `room_timeline_bloc.dart`        |
| Classes   | `PascalCase`                            | `RoomTimelineBloc`               |

Events are named after **what the user did**, not what the Bloc should do. `RoomTimelineRefreshRequested`, not `RefreshData`. This keeps events describable in plain English (`"the user asked to refresh the room timeline"`) and makes them easy to log.

### 2.3 State shape

Every feature state has:

- A `status` field (an enum: `initial`, `loading`, `loaded`, `error`).
- The actual payload (`items`, `surgery`, `calendar`, etc.) — nullable during loading.
- An `errorMessage` — nullable, populated only on `error`.
- Any transient per-item flags the UI needs (e.g. `deletingId` on `RoomsListState`).

We use `Equatable` on every state class so `BlocBuilder` skips rebuilds when the state hasn't actually changed. `copyWith(clearError: true)` idioms let us reset nullable fields without accidentally re-nulling other data.

---

## 3. Layer contracts

### `data/models/`

Plain data classes. Every model has:

- Named-parameter constructor.
- `fromJson(Map<String, dynamic>)` — matches the API doc exactly.
- `toJson()` — round-trips.
- `Equatable` props.
- No business logic. If you're tempted to add a method, it probably belongs in a Bloc or a widget.

### `data/services/`

One class per API resource group (Auth, Rooms, Staff, Surgery, …). Each method:

- Takes named parameters.
- Awaits the Dio call.
- Returns a decoded model or throws a typed exception.

Services **never** touch storage, navigation, or global state. If a service needs a helper (date formatting for query params), it lives alongside as a plain function — see `date_format.dart`.

### `core/network/`

- `DioClient` wraps `Dio` with our base URL, timeouts, and interceptors.
- `AuthInterceptor` reads the bearer token from `AuthTokenStorage` on every request.
- `ErrorInterceptor` catches HTTP failures and rethrows as our typed exceptions (`UnauthenticatedException`, `ForbiddenException`, `ValidationException`, `NotFoundException`, `NetworkException`). This is where "the API is failing" turns into "the app knows how to fail". Services and Blocs downstream only need to catch `ApiException` or one of its subtypes — they never poke at HTTP status codes directly.

### `core/di.dart`

The `AppContainer` — one class that owns the singleton services. Constructed once in `main`, provided at the top of the tree via `RepositoryProvider`, and pulled out inside each screen with `context.read<AppContainer>()`. We hand-rolled this instead of pulling in `get_it` because the graph is small and explicit dependencies read better in a portfolio project.

### `core/router/app_router.dart`

`go_router` with two responsibilities:

1. **A route table** keyed on names from `app_routes.dart`.
2. **An auth-aware `redirect`** that reads the current `AuthState` and rewrites navigation:
   - `AuthStatus.unknown` → sit on splash while the token is validated.
   - `AuthStatus.unauthenticated` → force everything to `/login`.
   - `AuthStatus.authenticated` → bounce splash/login to the role's home screen.

The router listens to the `AuthBloc`'s stream via `GoRouterRefreshStream`, so login and logout re-trigger the redirect automatically.

---

## 4. Concrete example: Room Timeline, end-to-end

Let's walk through what happens when a coordinator opens the Room Timeline and pulls to refresh. This is the same flow every screen follows, so if you understand this one, you understand all ten.

### Setup

`AppContainer` was built in `main.dart` and provided to the tree. The `AuthBloc` bootstrapped by calling `GET /api/me` on startup, established `AuthStatus.authenticated`, and the router redirected to `/coordinator/timeline`.

### Step 1 — Screen mounts

`RoomTimelineScreen` (in `screens/coordinator/room_timeline_screen.dart`) is a `StatelessWidget`. Its `build` returns a `BlocProvider` that constructs `RoomTimelineBloc`:

```dart
BlocProvider(
  create: (context) => RoomTimelineBloc(
    surgeryService: context.read<AppContainer>().surgeryService,
  )..add(const RoomTimelineRequested()),
  child: const _RoomTimelineView(),
);
```

Two things worth noting:

- The Bloc's lifecycle is tied to this route. When the user navigates away, `BlocProvider` disposes it.
- The initial event (`RoomTimelineRequested`) is dispatched inline via the `..add(...)` cascade, so the Bloc starts loading before the first frame paints.

### Step 2 — Bloc handles the initial event

`_onRequested` in `blocs/room_timeline/room_timeline_bloc.dart`:

```dart
Future<void> _onRequested(RoomTimelineRequested event, Emitter<...> emit) async {
  final from = event.from ?? _startOfToday();
  final to = event.to ?? from.add(const Duration(days: 6));
  emit(state.copyWith(status: RoomTimelineStatus.loading, from: from, to: to));
  await _load(from: from, to: to, emit: emit);
}
```

It picks default dates (today .. today+6d), emits a `loading` state, and delegates to `_load`.

### Step 3 — Service is called

`_load` calls `_surgeryService.calendar(from: from, to: to)`. In `data/services/surgery_service.dart`:

```dart
Future<CalendarResponse> calendar({DateTime? from, DateTime? to}) async {
  final res = await _client.get<Map<String, dynamic>>(
    ApiConstants.surgeriesCalendar,
    queryParameters: {
      if (from != null) 'from': formatServerDate(from),
      if (to != null) 'to': formatServerDate(to),
    },
  );
  return CalendarResponse.fromJson(res.data!);
}
```

The service asks `DioClient` for a GET to `/api/surgeries/calendar?from=…&to=…`. Note: it uses `formatServerDate` (yyyy-MM-dd), not the ISO format — because the API doc's example query uses that shape.

### Step 4 — Dio sends the request

`DioClient` runs the request through two interceptors:

1. `AuthInterceptor` reads the token from `flutter_secure_storage` and sets `Authorization: Bearer <token>` on the request.
2. The request goes out.
3. Response comes back. If 200 OK, we return `CalendarResponse.fromJson(...)`. If 401/403/422/etc., `ErrorInterceptor` maps the response body into `UnauthenticatedException`, `ForbiddenException`, `ValidationException`, or `ApiException` and throws.

### Step 5 — Bloc emits the loaded state

Back in `_load`:

```dart
try {
  final calendar = await _surgeryService.calendar(from: from, to: to);
  emit(state.copyWith(
    status: RoomTimelineStatus.loaded,
    calendar: calendar,
    clearError: true,
  ));
} on ApiException catch (e) {
  emit(state.copyWith(status: RoomTimelineStatus.error, errorMessage: e.message));
}
```

Either a `loaded` state with the calendar data, or an `error` state with a user-facing message.

### Step 6 — Screen rebuilds

The screen's `BlocBuilder<RoomTimelineBloc, RoomTimelineState>` gets the new state and switches on `status`:

```dart
return switch (state.status) {
  RoomTimelineStatus.initial ||
  RoomTimelineStatus.loading =>
    state.calendar == null ? const LoadingView() : _Body(state: state),
  RoomTimelineStatus.error => ErrorView(
      message: state.errorMessage ?? 'Failed to load timeline',
      onRetry: () => context.read<RoomTimelineBloc>().add(const RoomTimelineRefreshRequested()),
    ),
  RoomTimelineStatus.loaded => _Body(state: state),
};
```

Note: on a *silent refresh* (calendar is not null but status is loading), we keep showing `_Body` — the pull-to-refresh spinner is the only loading signal, so the list never flashes.

### Step 7 — User pulls to refresh

`RefreshIndicator.onRefresh` dispatches `RoomTimelineRefreshRequested`. The Bloc runs `_load` again with the current `from`/`to` (silent — no `loading` state), calls the service, emits `loaded`, screen rebuilds. Same loop as before.

### That's the whole pattern

Every feature works exactly this way:

- Screen builds → `BlocProvider` creates Bloc → Bloc adds initial event.
- User interaction → screen dispatches event → Bloc calls service → service hits Dio → Dio returns model or throws.
- Bloc emits new state → screen's `BlocBuilder` rebuilds.

If you can trace this for Room Timeline, you can trace it for any of the other nine screens.

---

## 5. How to add a new feature

Say we've just added a `GET /api/audit-log` endpoint and want to build an "Audit Log" screen for admins. Here's the recipe:

### 1. Add the endpoint constant

In `core/constants/api_constants.dart`:

```dart
static const String auditLog = '/audit-log';
```

### 2. Add the model

Create `data/models/audit_entry.dart`. Look at any of the existing models for the shape — `Equatable`, `fromJson`, `toJson`, named-parameter constructor, no methods.

### 3. Add the service

Create `data/services/audit_service.dart`:

```dart
class AuditService {
  final DioClient _client;
  AuditService(this._client);

  Future<List<AuditEntry>> list() async {
    final res = await _client.get<Map<String, dynamic>>(ApiConstants.auditLog);
    return (res.data!['data'] as List<dynamic>)
        .map((e) => AuditEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
```

### 4. Wire it into the container

In `core/di.dart`, add a field, initialize it in the `production` factory, and expose it:

```dart
final AuditService auditService;
// ...
auditService: AuditService(dioClient),
```

### 5. Create the Bloc trio

Create `blocs/audit_log/` with three files:

- `audit_log_bloc.dart` — has `part 'audit_log_event.dart'; part 'audit_log_state.dart';` at the top and defines the Bloc class.
- `audit_log_event.dart` — `part of 'audit_log_bloc.dart';` at the top, then a sealed `AuditLogEvent` class + `AuditLogRequested`, `AuditLogRefreshRequested`.
- `audit_log_state.dart` — `part of 'audit_log_bloc.dart';`, then `AuditLogStatus` enum + `AuditLogState` class with `copyWith`.

Copy-paste from any of the "simple list" Blocs (`my_surgeries_bloc.dart` is a good template) and adapt.

### 6. Add the route

In `core/router/app_routes.dart`:

```dart
static const String adminAuditLog = 'admin.auditLog';
```

In `core/router/app_router.dart`, add a `GoRoute` and the import.

### 7. Add the screen

Create `screens/admin/audit_log_screen.dart`. Standard shell:

```dart
class AuditLogScreen extends StatelessWidget {
  const AuditLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuditLogBloc(
        auditService: context.read<AppContainer>().auditService,
      )..add(const AuditLogRequested()),
      child: const _View(),
    );
  }
}
```

The `_View` inside handles the `switch (state.status)` pattern from Room Timeline. Use `LoadingView`, `ErrorView`, `EmptyView`, `AppCard`, `PrimaryButton`, `StatusBadge` from `widgets/` — don't reinvent them.

### 8. Wire the nav bar (optional)

If admins should reach this via the bottom nav, add a `NavDestination` to `_adminDestinations` in `widgets/app_bottom_nav_bar.dart`.

### 9. Run `flutter analyze`

There should be zero issues. If there are, read them — most likely a missing import or a stale enum branch.

---

## 6. Testing philosophy (not yet implemented)

The architecture is set up for testability but tests haven't been written yet. When they are:

- **Blocs** are unit-testable with `bloc_test` and a mock service. Because the Bloc never touches Flutter, the tests run in pure Dart.
- **Services** are unit-testable with a mocked `Dio`. They shouldn't need mocking their own storage — the token storage isn't invoked in a service call directly, only inside the interceptor.
- **Screens** get widget tests that use `MockBloc` and verify the presentation logic in isolation from real network calls.

The `test/widget_test.dart` file exists as a placeholder so `flutter test` has something to run.

---

## 7. Design system

Everything visual comes from `core/theme/`:

- **Colors**: `AppColors` — primary teal, secondary teal-green, accent amber (used *only* for warnings), danger red (used *only* for emergency-priority surgeries and destructive actions), soft off-white background, plus semantic status colors.
- **Typography**: `AppTextStyles` — one sans-serif family (Inter), fixed scale from `overline` to `displayLarge`. Screens use the scale as-is; they don't hand-tune font sizes.
- **Spacing**: `AppSpacing` — geometric 4-based scale (`xs, sm, md, lg, xl, xxl`), single corner radius (12 for cards/buttons/inputs, 8 for chips, 999 for pills).
- **Theme**: `AppTheme.light()` bakes the tokens into a Material 3 `ThemeData` so widgets that read from `Theme.of(context)` (dialogs, snack bars, form fields) look right without extra styling.

Shared widgets in `widgets/`:

- `PrimaryButton` — three variants (`filled`, `outlined`, `danger`). Handles loading spinner.
- `AppCard` — the canonical container. Optional `onTap` makes it a list item.
- `StatusBadge` — colored pill. Named constructors (`.surgery`, `.room`, `.priority`, `.suggestion`) map model enums to labels + colors so screens never touch raw hex.
- `AppBottomNavBar` — role-aware nav. Different destinations per `UserRole`.
- `LoadingView` / `ErrorView` / `EmptyView` — the three universal states every list screen renders.

---

## 8. Running the app

```bash
flutter pub get
flutter run
```

The backend URL is `http://127.0.0.1:8000/api` (see `ApiConstants.baseUrl`). For the Android emulator, swap `127.0.0.1` for `10.0.2.2` — the emulator maps that back to your host.

Seeded test accounts (all password `password`):

- `admin@shifa.test` — admin
- `coord1@shifa.test` — coordinator
- `surgeon1@shifa.test` — surgeon

---

## 9. Guiding principles, summarized

1. **The Bloc is the source of truth.** Widgets read state, dispatch events. Nothing else.
2. **Services throw typed exceptions.** No raw HTTP status codes above the network layer.
3. **Every feature has the same skeleton.** Bloc + Event + State + Screen. Copy the pattern, don't invent new ones.
4. **Design tokens live in one place.** Never hardcode colors, sizes, or spacings in a screen.
5. **The router is auth-aware.** Screens don't check "can this role see me" — the router already did.
6. **`core/` is stable, `screens/` and `blocs/` grow.** If you're changing `core/` a lot, something's wrong with the abstraction.

That's it. Read one existing feature end-to-end, then build yours the same way.
