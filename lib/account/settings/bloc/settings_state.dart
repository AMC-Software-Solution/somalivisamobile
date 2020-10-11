part of 'settings_bloc.dart';

enum SettingsAction {none, reloadForLanguage}

class SettingsState extends Equatable {
  final FirstnameInput firstname;
  final LastnameInput lastname;
  final EmailInput email;
  final FormzStatus formStatus;
  final SettingsAction action;
  final String generalNotificationKey;
  final User currentUser;

  const SettingsState({
    this.firstname = const FirstnameInput.pure(),
    this.lastname = const LastnameInput.pure(),
    this.email = const EmailInput.pure(),
    this.action = SettingsAction.none,
    this.formStatus = FormzStatus.pure,
    this.generalNotificationKey = HttpUtils.generalNoErrorKey,
    this.currentUser = const User('', '', '', '', '', '')
  });

  SettingsState copyWith({
    FirstnameInput firstname,
    LastnameInput lastname,
    EmailInput email,
    FormzStatus status,
    String generalNotificationKey,
    SettingsAction action,
    User currentUser
  }) {
    return SettingsState(
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      formStatus: status ?? this.formStatus,
      generalNotificationKey: generalNotificationKey ?? this.generalNotificationKey,
      action: action ?? this.action,
      currentUser: currentUser ?? this.currentUser
    );
  }

  @override
  List<Object> get props => [firstname, lastname, email,formStatus, generalNotificationKey];

  @override
  bool get stringify => true;
}
