import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:stripe_app/models/credit_card_model.dart';

part 'pay_event.dart';
part 'pay_state.dart';

class PayBloc extends Bloc<PayEvent, PayState> {
  PayBloc() : super(PayState());

  @override
  Stream<PayState> mapEventToState(PayEvent event) async* {
    if (event is OnSelectCard) {
      yield state.copyWith(isCardActive: true, card: event.card);
    } else if (event is OnDeactivateCard) {
      yield state.copyWith(isCardActive: false);
    }
  }
}
