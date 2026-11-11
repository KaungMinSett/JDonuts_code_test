import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/domain/result.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth_providers.dart';
import '../../domain/date_of_birth_validator.dart';
import 'app_legal_notice.dart';
import 'birthday_fields.dart';
import 'birthday_picker_sheet.dart';

class DateOfBirthForm extends ConsumerStatefulWidget {
  const DateOfBirthForm({
    required this.normalizedPhone,
    required this.firstName,
    required this.lastName,
    required this.header,
    super.key,
  });

  final String normalizedPhone;
  final String firstName;
  final String? lastName;
  final Widget header;

  @override
  ConsumerState<DateOfBirthForm> createState() => _DateOfBirthFormState();
}

class _DateOfBirthFormState extends ConsumerState<DateOfBirthForm> {
  DateTime? _birthday;
  bool _isRegistering = false;
  bool _registrationFailed = false;

  Future<void> _openBirthdayPicker() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final previousBirthday = _birthday;
    final initialDate =
        previousBirthday != null && !previousBirthday.isAfter(today)
        ? previousBirthday
        : today;

    final birthday = await showModalBottomSheet<DateTime>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      sheetAnimationStyle: MediaQuery.disableAnimationsOf(context)
          ? AnimationStyle.noAnimation
          : null,
      builder: (_) =>
          BirthdayPickerSheet(initialDate: initialDate, latestDate: today),
    );

    // Cancel and dismissal leave the last confirmed date in place.
    if (!mounted || birthday == null) return;
    setState(() {
      _birthday = birthday;
      _registrationFailed = false;
    });
  }

  DateOfBirthError? _validateBirthday(DateTime birthday) {
    return validateDateOfBirth(
      year: birthday.year,
      month: birthday.month,
      day: birthday.day,
      today: DateTime.now(),
    );
  }

  Future<void> _register() async {
    final birthday = _birthday;
    if (birthday == null ||
        _isRegistering ||
        _validateBirthday(birthday) != null) {
      return;
    }

    // Disable another submission before the asynchronous storage work starts.
    setState(() {
      _isRegistering = true;
      _registrationFailed = false;
    });

    try {
      final result = await ref
          .read(authRepositoryProvider)
          .register(
            normalizedPhone: widget.normalizedPhone,
            firstName: widget.firstName,
            lastName: widget.lastName,
            dateOfBirth: birthday,
          );
      if (!mounted) return;

      switch (result) {
        case Success():
          // Registration has created the session. Leave the auth steps behind.
          context.go('/welcome');
        case Failure():
          setState(() => _registrationFailed = true);
      }
    } finally {
      if (mounted) setState(() => _isRegistering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final birthday = _birthday;
    final error = birthday == null ? null : _validateBirthday(birthday);
    final errorText = switch (error) {
      DateOfBirthError.invalidDate => strings.birthdayInvalidDate,
      DateOfBirthError.futureDate => strings.birthdayFutureDate,
      DateOfBirthError.underage => strings.birthdayUnderage(
        minimumRegistrationAge,
      ),
      null => null,
    };

    return PopScope<void>(
      canPop: !_isRegistering,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              widget.header,
              const SizedBox(height: 32),
              BirthdayFields(
                birthday: birthday,
                errorText: errorText,
                onTap: _isRegistering ? null : _openBirthdayPicker,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: _RegistrationActions(
              canRegister: birthday != null && error == null,
              isRegistering: _isRegistering,
              registrationFailed: _registrationFailed,
              onContinue: _register,
            ),
          ),
        ],
      ),
    );
  }
}

class _RegistrationActions extends StatelessWidget {
  const _RegistrationActions({
    required this.canRegister,
    required this.isRegistering,
    required this.registrationFailed,
    required this.onContinue,
  });

  final bool canRegister;
  final bool isRegistering;
  final bool registrationFailed;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (registrationFailed)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Semantics(
              liveRegion: true,
              child: Text(
                strings.registrationSaveFailed,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ),
        PrimaryButton(
          label: strings.authContinue,
          loadingLabel: isRegistering ? strings.registrationSaving : null,
          onPressed: canRegister ? onContinue : null,
        ),
        const SizedBox(height: 32),
        const AppLegalNotice(),
      ],
    );
  }
}
