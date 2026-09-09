import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/locale/locale_cubit.dart';
import 'blocs/unread_notifications/unread_notifications_cubit.dart';
import 'core/di.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/generated/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ShifaApp(container: AppContainer.production()));
}

/// Root widget.
///
/// The [AppContainer] is provided to the whole tree so screen-scoped
/// Blocs can pull services out of context. Two Blocs live above the
/// router: [AuthBloc] (session state — read by every screen and by the
/// router's redirect), and [UnreadNotificationsCubit] (drives the
/// notification dot in the persistent header on every screen).
class ShifaApp extends StatefulWidget {
  const ShifaApp({super.key, required this.container});

  final AppContainer container;

  @override
  State<ShifaApp> createState() => _ShifaAppState();
}

class _ShifaAppState extends State<ShifaApp> {
  late final AuthBloc _authBloc = widget.container.buildAuthBloc();
  late final UnreadNotificationsCubit _unread =
      UnreadNotificationsCubit(widget.container.notificationService);
  late final LocaleCubit _locale = LocaleCubit()..load();

  @override
  void dispose() {
    _authBloc.close();
    _unread.close();
    _locale.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AppContainer>.value(
      value: widget.container,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: _authBloc),
          BlocProvider<UnreadNotificationsCubit>.value(value: _unread),
          BlocProvider<LocaleCubit>.value(value: _locale),
        ],
        child: BlocListener<AuthBloc, AuthState>(
          // Whenever the user finishes authenticating, seed the unread
          // count. On logout, reset it so the bell renders correctly if
          // the app is later re-entered.
          listenWhen: (previous, current) =>
              previous.status != current.status,
          listener: (_, state) {
            switch (state.status) {
              case AuthStatus.authenticated:
                _unread.refresh();
              case AuthStatus.unauthenticated:
                _unread.reset();
              case AuthStatus.unknown:
              case AuthStatus.authenticating:
                break;
            }
          },
          child: Builder(
            builder: (context) {
              final router = buildAppRouter(_authBloc);
              return BlocBuilder<LocaleCubit, Locale>(
                builder: (context, locale) {
                  return MaterialApp.router(
                    title: 'Shifa',
                    debugShowCheckedModeBanner: false,
                    theme: AppTheme.light(),
                    routerConfig: router,
                    locale: locale,
                    supportedLocales: AppLocalizations.supportedLocales,
                    localizationsDelegates: const [
                      ...AppLocalizations.localizationsDelegates,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
