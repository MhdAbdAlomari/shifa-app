import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../core/l10n/error_code_l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/app_snack_bar.dart';

/// Login form.
///
/// Purely presentational. It reads status from the app-wide [AuthBloc]
/// (already provided at the top of the widget tree) and dispatches an
/// [AuthLoginRequested] event when the user submits. Navigation to the
/// role home is handled by the router's `redirect` — not by this screen.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
          AuthLoginRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // No AppBar on this screen (it's the one screen without the
    // gradient AppHeader or a plain AppBar), so the theme's default
    // systemOverlayStyle never applies here — set it explicitly for
    // the light background (item 2 fix).
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null,
      listener: (context, state) {
        showErrorSnackBar(
          context,
          localizedErrorMessage(
            l10n,
            code: state.errorCode,
            fallback: state.errorMessage!,
          ),
        );
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.background,
                Color.fromRGBO(15, 110, 86, 0.07),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _LogoMark(),
                    const SizedBox(height: AppSpacing.xl),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.surface,
                            AppColors.primary.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusCard),
                        boxShadow: AppShadows.cardElevated,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              l10n.loginTitle,
                              style: AppTextStyles.headlineLg,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              l10n.loginSubtitle,
                              style: AppTextStyles.bodyMd
                                  .copyWith(color: AppColors.textSecondary),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: l10n.loginEmailLabel,
                                hintText: l10n.loginEmailHint,
                                prefixIcon: const Icon(
                                  Icons.mail_outline,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return l10n.loginEmailRequired;
                                }
                                if (!value.contains('@')) {
                                  return l10n.loginEmailInvalid;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSpacing.md),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscure,
                              autofillHints: const [AutofillHints.password],
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submit(),
                              decoration: InputDecoration(
                                labelText: l10n.loginPasswordLabel,
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: AppColors.textSecondary,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscure
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined),
                                  onPressed: () =>
                                      setState(() => _obscure = !_obscure),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l10n.loginPasswordRequired;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            BlocBuilder<AuthBloc, AuthState>(
                              buildWhen: (p, c) => p.status != c.status,
                              builder: (context, state) {
                                return PrimaryButton(
                                  label: l10n.loginButton,
                                  isLoading: state.status ==
                                      AuthStatus.authenticating,
                                  onPressed: _submit,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          child: Image.asset(
            'assets/images/shifa_logo.png',
            width: 72,
            height: 72,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.appName,
              style:
                  AppTextStyles.headlineMd.copyWith(color: AppColors.primary),
            ),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              l10n.appTagline,
              style: AppTextStyles.labelLg.copyWith(
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
