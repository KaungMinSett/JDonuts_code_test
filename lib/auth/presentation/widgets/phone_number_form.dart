import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/domain/result.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth_providers.dart';
import '../../domain/auth_repository.dart';
import '../../domain/phone_validator.dart';
import 'app_legal_notice.dart';
import 'input_text_field.dart';

class PhoneNumberForm extends ConsumerStatefulWidget {
  const PhoneNumberForm({
    required this.isLogin,
    required this.initialPhone,
    required this.header,
    super.key,
  });

  final bool isLogin;
  final String initialPhone;
  final Widget header;

  @override
  ConsumerState<PhoneNumberForm> createState() => _PhoneNumberFormState();
}

class _PhoneNumberFormState extends ConsumerState<PhoneNumberForm> {
  late final _phoneController = TextEditingController(
    text: widget.initialPhone,
  );
  final _phoneFocus = FocusNode();
  bool _hasBlurred = false;
  bool _isCheckingPhone = false;
  AuthFailure? _phoneLookupFailure;

  @override
  void initState() {
    super.initState();
    _phoneFocus.addListener(_showValidationOnBlur);
  }

  @override
  void dispose() {
    _phoneFocus.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showValidationOnBlur() {
    // Keep the inline format error hidden until the user leaves the field.
    if (!_phoneFocus.hasFocus && !_hasBlurred) {
      setState(() => _hasBlurred = true);
    }
  }

  void _clearLookupFailure(String _) {
    // A lookup result applies only to the number submitted.
    if (_phoneLookupFailure != null) {
      setState(() => _phoneLookupFailure = null);
    }
  }

  Future<void> _continueWithPhone() async {
    final normalizedPhone = normalizeMyanmarPhone(_phoneController.text);
    if (normalizedPhone == null || _isCheckingPhone) return;

    // Lock the field and Continue while the fake account lookup is in flight.
    _phoneFocus.unfocus();
    setState(() {
      _isCheckingPhone = true;
      _phoneLookupFailure = null;
    });

    try {
      final result = await ref
          .read(authRepositoryProvider)
          .checkRegisteredPhone(normalizedPhone);
      // Back can be pressed while the lookup is still running.
      if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;
      _handlePhoneLookup(normalizedPhone, result);
    } finally {
      if (mounted) setState(() => _isCheckingPhone = false);
    }
  }

  void _handlePhoneLookup(
    String normalizedPhone,
    Result<void, AuthFailure> result,
  ) {
    switch (result) {
      case Success():
        _openOtp(normalizedPhone, isLogin: true);
      case Failure(error: AuthFailure.accountNotFound) when !widget.isLogin:
        _openOtp(normalizedPhone, isLogin: false);
      case Failure(:final error):
        setState(() => _phoneLookupFailure = error);
    }
  }

  void _openOtp(String normalizedPhone, {required bool isLogin}) {
    // Keep the raw draft on this route and pass only the normalized phone to OTP.
    context.push<void>(
      '/phone/otp',
      extra: {'normalizedPhone': normalizedPhone, 'isLogin': isLogin},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            widget.header,
            const SizedBox(height: 32),
            _PhoneEntry(
              controller: _phoneController,
              focusNode: _phoneFocus,
              showFormatError: _hasBlurred,
              isCheckingPhone: _isCheckingPhone,
              lookupFailure: _phoneLookupFailure,
              onChanged: _clearLookupFailure,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32),
          child: _PhoneActions(
            controller: _phoneController,
            isCheckingPhone: _isCheckingPhone,
            onContinue: _continueWithPhone,
          ),
        ),
      ],
    );
  }
}

class _PhoneEntry extends StatelessWidget {
  const _PhoneEntry({
    required this.controller,
    required this.focusNode,
    required this.showFormatError,
    required this.isCheckingPhone,
    required this.lookupFailure,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool showFormatError;
  final bool isCheckingPhone;
  final AuthFailure? lookupFailure;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final hasInvalidFormat =
            showFormatError && normalizeMyanmarPhone(value.text) == null;

        return InputTextField(
          controller: controller,
          focusNode: focusNode,
          enabled: !isCheckingPhone,
          onChanged: onChanged,
          keyboardType: TextInputType.phone,
          textAlign: TextAlign.start,
          leadingText: myanmarCountryCode,
          hintText: strings.phoneNumberHint,
          errorText: switch (lookupFailure) {
            AuthFailure.storageUnavailable => strings.phoneLookupUnavailable,
            _ => hasInvalidFormat ? strings.phoneNumberInvalid : null,
          },
          error: lookupFailure == AuthFailure.accountNotFound
              ? _UnregisteredPhoneMessage(phoneDraft: value.text)
              : null,
        );
      },
    );
  }
}

class _UnregisteredPhoneMessage extends StatelessWidget {
  const _UnregisteredPhoneMessage({required this.phoneDraft});

  final String phoneDraft;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Semantics(
      liveRegion: true,
      child: Wrap(
        spacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            strings.phoneNotRegistered,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          AuthTextLink(
            label: strings.phoneRegisterLink,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
              decoration: TextDecoration.underline,
            ),
            // Switch to registration with the same text the user entered.
            onPressed: () =>
                context.pushReplacement('/phone', extra: phoneDraft),
          ),
        ],
      ),
    );
  }
}

class _PhoneActions extends StatelessWidget {
  const _PhoneActions({
    required this.controller,
    required this.isCheckingPhone,
    required this.onContinue,
  });

  final TextEditingController controller;
  final bool isCheckingPhone;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Update Continue without rebuilding the header or legal notice.
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) => PrimaryButton(
            label: strings.authContinue,
            loadingLabel: isCheckingPhone ? strings.phoneLookupLoading : null,
            onPressed: normalizeMyanmarPhone(value.text) == null
                ? null
                : onContinue,
          ),
        ),
        const SizedBox(height: 32),
        const AppLegalNotice(),
      ],
    );
  }
}
