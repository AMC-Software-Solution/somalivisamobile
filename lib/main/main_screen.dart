import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:somalivisamobile/account/login/login_repository.dart';
import 'package:somalivisamobile/keys.dart';
import 'package:somalivisamobile/main/bloc/main_bloc.dart';
import 'package:somalivisamobile/shared/widgets/drawer/bloc/drawer_bloc.dart';
import 'package:somalivisamobile/shared/widgets/drawer/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class MainScreen extends StatelessWidget {
  MainScreen({Key key}) : super(key: SomalivisamobileKeys.mainScreen);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      buildWhen: (previous, current) => previous.currentUser != current.currentUser,
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Main page'),
            ),
            body: body(context),
            drawer: BlocProvider<DrawerBloc>(
                create: (context) => DrawerBloc(loginRepository: LoginRepository()),
                child: SomalivisamobileDrawer())
        );
      },
    );
  }

  Widget body(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            currentUserWidget(context),
            Padding(padding: EdgeInsets.symmetric(vertical: 10),),
            linkWidget(context, 'Jhipster Docs', 'https://www.jhipster.tech/'),
            linkWidget(context, 'Stackoverflow', 'http://stackoverflow.com/tags/jhipster/info'),
            linkWidget(context, 'Open issues', 'https://github.com/merlinofcha0s/generator-jhipster-flutter/issues?state=open'),
            linkWidget(context, 'Gitter', 'https://gitter.im/jhipster/generator-jhipster'),
            linkWidget(context, 'Jhipster twitter', 'https://twitter.com/jhipster')
          ],
        ),
      ],
    );
  }

  Widget currentUserWidget(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
        buildWhen: (previous, current) => previous.currentUser != current.currentUser,
        builder: (context, state) {
        String login = state.currentUser.login;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Current user: ' + login, style: Theme.of(context).textTheme.headline3),
            Padding(padding: EdgeInsets.symmetric(vertical: 5),),
            SizedBox(width: MediaQuery.of(context).size.width * 0.80,
                child: Text('Welcome to your Jhipster flutter app', textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3)),
          ],
        );
      }
    );
  }

  Widget linkWidget(BuildContext context, String text, String url){
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: RaisedButton(
          onPressed: () => _launchURL(url),
          child: Container(
            child: Text(text, textAlign: TextAlign.center,),
            width: MediaQuery.of(context).size.width * 0.5,)
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
