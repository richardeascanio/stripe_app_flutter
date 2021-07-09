part of 'pay_bloc.dart';

@immutable
class PayState {
  final double? amountToPay;
  final String? currency;
  final bool isCardActive;
  final CreditCardModel? card;

  String get amountToPayString => '${(this.amountToPay! * 100).floor()}';

  PayState({
    this.amountToPay = 375.55, 
    this.currency = 'USD', 
    this.isCardActive = false, 
    this.card
  });

  PayState copyWith({
    double? amountToPay,
    String? currency,
    bool? isCardActive,
    CreditCardModel? card
  }) => PayState(
    amountToPay: amountToPay ?? this.amountToPay,
    currency: currency ?? this.currency,
    isCardActive: isCardActive ?? this.isCardActive,
    card: card ?? this.card,
  );
}
