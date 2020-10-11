import 'dart:async';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:somalivisamobile/shared/models/user.dart';
import 'package:somalivisamobile/shared/repository/account_repository.dart';

part 'main_events.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final AccountRepository _accountRepository;

  MainBloc({@required AccountRepository accountRepository}) : assert(accountRepository != null),
        _accountRepository = accountRepository, super(const MainState());

  @override
  void onTransition(Transition<MainEvent, MainState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is Init) {
       yield* onInit(event);
    }
  }

  Stream<MainState> onInit(Init event) async* {
    User currentUser = await _accountRepository.getIdentity();


    yield state.copyWith(
      currentUser: currentUser,
    );
  }
}
