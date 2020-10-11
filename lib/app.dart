import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:somalivisamobile/account/login/bloc/login_bloc.dart';
import 'package:somalivisamobile/account/login/login_repository.dart';
import 'package:somalivisamobile/account/register/bloc/register_bloc.dart';
import 'package:somalivisamobile/account/settings/settings_screen.dart';
import 'package:somalivisamobile/main/bloc/main_bloc.dart';
import 'package:somalivisamobile/routes.dart';
import 'package:somalivisamobile/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:somalivisamobile/shared/repository/account_repository.dart';
import 'package:somalivisamobile/themes.dart';
import 'account/settings/bloc/settings_bloc.dart';
import 'package:somalivisamobile/shared/models/entity_arguments.dart';

import 'account/login/login_screen.dart';
import 'account/register/register_screen.dart';


// jhipster-merlin-needle-import-add - JHipster will add new imports here

class SomalivisamobileApp extends StatelessWidget {
  const SomalivisamobileApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Somalivisamobile app',
      theme: Themes.jhLight,
      routes: {
        SomalivisamobileRoutes.login: (context) {
          return BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(loginRepository: LoginRepository()),
            child: LoginScreen());
        },
        SomalivisamobileRoutes.register: (context) {
          return BlocProvider<RegisterBloc>(
            create: (context) => RegisterBloc(accountRepository: AccountRepository()),
            child: RegisterScreen());
        },
        SomalivisamobileRoutes.main: (context) {
          return BlocProvider<MainBloc>(
            create: (context) => MainBloc(accountRepository: AccountRepository())
              ..add(Init()),
            child: MainScreen());
        },
      SomalivisamobileRoutes.settings: (context) {
        return BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(accountRepository: AccountRepository())
            ..add(LoadCurrentUser()),
          child: SettingsScreen());
        },
        // jhipster-merlin-needle-route-add - JHipster will add new routes here
      },
    );
  }
}
