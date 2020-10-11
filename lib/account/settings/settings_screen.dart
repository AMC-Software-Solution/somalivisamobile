import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:somalivisamobile/account/login/login_repository.dart';
import 'package:somalivisamobile/account/settings/bloc/settings_bloc.dart';
import 'package:somalivisamobile/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:somalivisamobile/shared/repository/http_utils.dart';
import 'package:formz/formz.dart';
import 'package:somalivisamobile/shared/widgets/drawer/bloc/drawer_bloc.dart';
import 'package:somalivisamobile/shared/widgets/drawer/drawer_widget.dart';

import 'bloc/settings_models.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen() : super(key: SomalivisamobileKeys.settingsScreen);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: BlocBuilder<SettingsBloc, SettingsState>(
              buildWhen: (previous, current) => previous.firstname != current.firstname
                  || current.action == SettingsAction.reloadForLanguage,
              builder: (context, state) {
                return Text('Settings');
              })
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: <Widget>[settingsForm(context)]),
        ),
        drawer: BlocProvider<DrawerBloc>(
            create: (context) => DrawerBloc(loginRepository: LoginRepository()),
            child: SomalivisamobileDrawer())
    );
  }

  Widget settingsForm(BuildContext context) {
          return Form(
            child: Wrap(runSpacing: 15, children: <Widget>[
              firstnameField(),
              lastnameNameField(),
              emailField(),
              notificationZone(),
              submit(context)
            ]),
          );
  }

  Widget firstnameField() {
    return BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (previous, current) => previous.firstname != current.firstname
            || current.action == SettingsAction.reloadForLanguage,
        builder: (context, state) {
          return TextFormField(
              controller: context.bloc<SettingsBloc>().firstNameController,
              onChanged: (value) { context.bloc<SettingsBloc>().add(FirstnameChanged(firstname: value)); },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText:'Firstname',
                  errorText: state.firstname.invalid ? FirstnameValidationError.invalid.invalidMessage : null));
        }
    );
  }

  Widget lastnameNameField() {
    return BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (previous, current) => previous.lastname != current.lastname
            || current.action == SettingsAction.reloadForLanguage,
        builder: (context, state) {
          return TextFormField(
              controller: context.bloc<SettingsBloc>().lastNameController,
              onChanged: (value) { context.bloc<SettingsBloc>().add(LastnameChanged(lastname: value)); },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText:'Lastname',
                  errorText: state.lastname.invalid ? LastnameValidationError.invalid.invalidMessage : null));
        }
    );
  }

  Widget emailField() {
    return BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (previous, current) => previous.email != current.email
            || current.action == SettingsAction.reloadForLanguage,
        builder: (context, state) {
          return TextFormField(
              controller: context.bloc<SettingsBloc>().emailController,
              onChanged: (value) { context.bloc<SettingsBloc>().add(EmailChanged(email: value)); },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText:'Email',
                  errorText: state.email.invalid ? EmailValidationError.invalid.invalidMessage : null));
        }
    );
  }

  submit(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (previous, current) => previous.formStatus != current.formStatus,
        builder: (context, state) {
        return RaisedButton(
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Visibility(
                  replacement: CircularProgressIndicator(value: null),
                  visible: !state.formStatus.isSubmissionInProgress,
                  child: Text('SAVE'),
                ),
              )),
          onPressed: state.formStatus.isValidated ? () => context.bloc<SettingsBloc>().add(FormSubmitted()) : null,
        );
      }
    );
  }

  Widget notificationZone() {
    return BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (previous, current) => previous.formStatus != current.formStatus,
        builder: (context, state) {
          return Visibility(
              visible: state.formStatus.isSubmissionFailure ||  state.formStatus.isSubmissionSuccess,
              child: Center(
                child: generateNotificationText(state, context),
              ));
        });
  }

  Widget generateNotificationText(SettingsState state, BuildContext context) {
    String notificationTranslated = '';
    MaterialColor notificationColors;
    if(state.generalNotificationKey.compareTo(SettingsBloc.successKey) == 0) {
      notificationTranslated ='Settings saved !';
      notificationColors = Theme.of(context).primaryColor;
    } else if(state.generalNotificationKey.compareTo(HttpUtils.errorServerKey) == 0) {
      notificationTranslated ='Something wrong happended with the data';
      notificationColors = Theme.of(context).errorColor;
    } else if (state.generalNotificationKey.compareTo(HttpUtils.errorServerKey) == 0) {
      notificationTranslated ='Something wrong when calling the server, please try again';
      notificationColors = Theme.of(context).errorColor;
    }

    return Text(
      notificationTranslated,
      style: TextStyle(color: notificationColors),
    );
  }
}
