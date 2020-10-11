import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:somalivisamobile/account/register/bloc/register_bloc.dart';
import 'package:somalivisamobile/keys.dart';
import 'package:somalivisamobile/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';
import 'package:somalivisamobile/shared/repository/http_utils.dart';

import 'bloc/register_models.dart';


class RegisterScreen extends StatelessWidget {
  RegisterScreen() : super(key: SomalivisamobileKeys.registerScreen);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: <Widget>[
            header(context),
            successZone(),
            registerForm()
          ]),
        ));
  }

  Widget header(BuildContext context) {
    return Column(
      children: <Widget>[
        Image(
          image:
              AssetImage('assets/images/jhipster_family_member_0_head-512.png'),
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width * 0.35,
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 20))
      ],
    );
  }

  Widget registerForm() {
    return BlocBuilder<RegisterBloc, RegisterState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Visibility(
            visible: !state.status.isSubmissionSuccess,
            child: Form(
              child: Wrap(runSpacing: 15, children: <Widget>[
                loginField(),
                emailField(),
                passwordField(),
                confirmPasswordField(),
                termsAndConditionsField(),
                validationZone(),
                submit()
              ]),
            ),
          );
        });
  }

  Widget loginField() {
    return BlocBuilder<RegisterBloc, RegisterState>(
        buildWhen: (previous, current) => previous.login != current.login,
        builder: (context, state) {
          return TextFormField(
              initialValue: state.login.value,
              onChanged: (value) { context.bloc<RegisterBloc>().add(LoginChanged(login: value)); },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText:'Login',
                  errorText: state.login.invalid ? LoginValidationError.invalid.invalidMessage : null));
        });
  }

  Widget emailField() {
    return BlocBuilder<RegisterBloc, RegisterState>(
        buildWhen: (previous, current) => previous.email != current.email,
        builder: (context, state) {
          return TextFormField(
            onChanged: (value) { context.bloc<RegisterBloc>().add(EmailChanged(email: value)); },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                labelText:'Email',
                hintText:'you@example.com',
                errorText: state.email.invalid ? EmailValidationError.invalid.invalidMessage : null),
          );
        });
  }

  Widget passwordField() {
    return BlocBuilder<RegisterBloc, RegisterState>(
        buildWhen: (previous, current) => previous.password != current.password,
        builder: (context, state) {
          return TextFormField(
              onChanged: (value) { context.bloc<RegisterBloc>().add(PasswordChanged(password: value)); },
              obscureText: true,
              decoration: InputDecoration(
                  labelText:'Password',
                  errorText: state.password.invalid ? PasswordValidationError.invalid.invalidMessage : null));
        });
  }

  Widget confirmPasswordField() {
    return BlocBuilder<RegisterBloc, RegisterState>(
        buildWhen: (previous, current) => previous.confirmPassword != current.confirmPassword,
        builder: (context, state) {
          return TextFormField(
              onChanged: (value) { context.bloc<RegisterBloc>().add(ConfirmPasswordChanged(confirmPassword: value, password: state.password.value)); },
              obscureText: true,
              decoration: InputDecoration(
                  labelText:'Confirm password',
                  errorText: state.confirmPassword.invalid ? ConfirmPasswordValidationError.invalid.invalidMessage : null));
        });
  }

  Widget termsAndConditionsField() {
    return BlocBuilder<RegisterBloc, RegisterState>(
        buildWhen: (previous, current) => previous.termsAndConditions != current.termsAndConditions,
        builder: (context, state) {
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                        onChanged: (value) { context.bloc<RegisterBloc>().add(TermsAndConditionsChanged(termsAndConditions: value)); },
                        value: state.termsAndConditions.value),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5),
                  ),
                  Text('I accept the terms of use', style: Theme.of(context).textTheme.bodyText1,),
                ],
              ),
              Visibility(
                visible: state.termsAndConditions.status != FormzInputStatus.pure && state.termsAndConditions.invalid,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text('Please accept the terms and conditions',
                    style: TextStyle(color: Theme.of(context).errorColor),
                  ),
                ),
              )
            ],
          );
        });
  }

  Widget validationZone() {
    return BlocBuilder<RegisterBloc, RegisterState>(
        buildWhen: (previous, current) => previous.status != current.status
            || previous.generalErrorKey != current.generalErrorKey,
        builder: (context, state) {
          return Visibility(
              visible: state.status.isSubmissionFailure || state.status.isInvalid && state.generalErrorKey != HttpUtils.generalNoErrorKey,
              child: Center(
                child: Text(
                  generateError(state, context),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
              ));
        });
  }

  String generateError(RegisterState state, BuildContext context) {
    String errorTranslated = '';
    if(state.generalErrorKey.toString().compareTo(RegisterBloc.passwordNotIdenticalKey) == 0){
      errorTranslated ='The passwords are not identical';
    } else if(state.generalErrorKey.toString().compareTo(RegisterBloc.emailExistKey) == 0) {
      errorTranslated ='Email already exist';
    } else if (state.generalErrorKey.toString().compareTo(RegisterBloc.loginExistKey) == 0){
      errorTranslated ='Login already taken';
    } else if (state.generalErrorKey.toString().compareTo(HttpUtils.errorServerKey) == 0) {
      errorTranslated ='Something wrong when calling the server, please try again';
    }

    return errorTranslated;
  }

  Widget submit() {
    return BlocBuilder<RegisterBloc, RegisterState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return RaisedButton(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child:  Center(
                  child: Visibility(
                    replacement: CircularProgressIndicator(value: null),
                    visible: !state.status.isSubmissionInProgress,
                    child: Text('Sign up',
                    ),
                  ),
                )),
            onPressed: state.status.isValidated ? () => context.bloc<RegisterBloc>().add(FormSubmitted()) : null,
          );
        });
  }

  Widget successZone() {
    return BlocBuilder<RegisterBloc, RegisterState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Visibility(
            visible: state.status.isSubmissionSuccess,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                    size: 125.0,
                    semanticLabel:'Register success',
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  Text('Congratulation'.toUpperCase(),
                      style: Theme.of(context).textTheme.headline1),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  Text('You have successfuly registered'),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                  ),
                  RaisedButton(
                    child: Container(
                        child: Center(
                            child: Text('Login'))),
                    onPressed: () =>
                        Navigator.pushNamed(context, SomalivisamobileRoutes.login),
                  )
                ],
              ),
            ),
          );
        });
  }
}
