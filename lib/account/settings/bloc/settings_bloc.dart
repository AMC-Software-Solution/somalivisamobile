import 'dart:async';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';
import 'package:somalivisamobile/account/settings/bloc/settings_models.dart';
import 'package:somalivisamobile/shared/models/user.dart';
import 'package:somalivisamobile/shared/repository/account_repository.dart';
import 'package:somalivisamobile/shared/repository/http_utils.dart';

part 'settings_events.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AccountRepository _accountRepository;
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  SettingsBloc({@required AccountRepository accountRepository}) : assert(accountRepository != null),
        _accountRepository = accountRepository, super(const SettingsState());

  static final String loginExistKey = 'error.userexists';
  static final String emailExistKey = 'error.emailexists';
  static final String successKey = 'success.settings';

  @override
  void onTransition(Transition<SettingsEvent, SettingsState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is FirstnameChanged) {
       yield* onFirstnameChange(event);
    } else if (event is LastnameChanged) {
      yield* onLastnameChange(event);
    } else if (event is EmailChanged) {
      yield* onEmailChange(event);
    }    else if (event is FormSubmitted) {
      yield* onSubmit();
    } else if (event is LoadCurrentUser) {
      yield* onLoadCurrentUser();
    }
  }

  Stream<SettingsState> onSubmit() async* {
    if (state.formStatus.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      SettingsAction action = SettingsAction.none;
      try {

        User newCurrentUser = User(state.currentUser.login, state.email.value,
            state.currentUser.password,null, state.firstname.value, state.lastname.value);

        String result = await _accountRepository.saveAccount(newCurrentUser);

        if (result.compareTo(HttpUtils.successResult) != 0) {
          yield state.copyWith(status: FormzStatus.submissionFailure,
              generalNotificationKey: result);
        } else {
          yield state.copyWith(currentUser: newCurrentUser,
              status: FormzStatus.submissionSuccess, action: action
          , generalNotificationKey: successKey);
        }
      } catch (e) {
        yield state.copyWith(status: FormzStatus.submissionFailure,
            generalNotificationKey: HttpUtils.errorServerKey);
      }
    }
  }


  Stream<SettingsState> onEmailChange(EmailChanged event) async* {
    final email = EmailInput.dirty(event.email);
    yield state.copyWith(
      email: email,
      status: Formz.validate([state.firstname, email, state.lastname]),
    );
  }

  Stream<SettingsState> onLastnameChange(LastnameChanged event) async* {
    final lastname = LastnameInput.dirty(event.lastname);
    yield state.copyWith(
      lastname: lastname,
      status: Formz.validate([state.firstname, lastname, state.email]),
    );
  }

  Stream<SettingsState> onFirstnameChange(FirstnameChanged event) async* {
     final firstname = FirstnameInput.dirty(event.firstname);
     yield state.copyWith(
       firstname: firstname,
       status: Formz.validate([firstname, state.lastname, state.email]),
    );
  }

  Stream<SettingsState> onLoadCurrentUser() async* {
    User currentUser = await _accountRepository.getIdentity();
    final firstname = FirstnameInput.dirty(currentUser?.firstName != null ? currentUser.firstName: '');
    final lastname = LastnameInput.dirty(currentUser?.lastName != null ? currentUser.lastName: '');
    final email = EmailInput.dirty(currentUser?.email != null ? currentUser.email: '');

    yield state.copyWith(
        firstname: firstname,
        lastname: lastname,
        email: email,
        currentUser: currentUser,
        status: Formz.validate([firstname, lastname, email]));

    emailController.text = currentUser.email;
    lastNameController.text = currentUser.lastName;
    firstNameController.text = currentUser.firstName;
  }

  @override
  Future<void> close() {
    emailController.dispose();
    lastNameController.dispose();
    firstNameController.dispose();
    return super.close();
  }
}
