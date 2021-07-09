import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stripe_app/bloc/pay/pay_bloc.dart';
import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_app/services/stripe_service.dart';
import 'package:stripe_payment/stripe_payment.dart';

class PayTotalButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final bloc = BlocProvider.of<PayBloc>(context);

    return Container(
      width: width,
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        color: Colors.white
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              Text(
                '${bloc.state.amountToPay} ${bloc.state.currency}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),

          BlocBuilder<PayBloc, PayState>(
            builder: (context, state) {
              return _PayButton(state);
            },
          )
        ],
      ),
    );
  }
}

class _PayButton extends StatelessWidget {

  final PayState state;

  const _PayButton(this.state);

  @override
  Widget build(BuildContext context) {

    return state.isCardActive
    ? buildCardPay(context)
    : buildAppleAndGooglePay(context);
  }

  Widget buildCardPay(BuildContext context) {
    return MaterialButton(
      height: 45,
      minWidth: 170,
      shape: StadiumBorder(),
      elevation: 0,
      color: Colors.black,
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.solidCreditCard,
            color: Colors.white,
          ),
          Text(
            '  Pay',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22
            ),
          ),
        ],
      ),
      onPressed: () async {
        _processCardPayment(context);
      },
    );
  }

  Widget buildAppleAndGooglePay(BuildContext context) {
    return MaterialButton(
      height: 45,
      minWidth: 150,
      shape: StadiumBorder(),
      elevation: 0,
      color: Colors.black,
      child: Row(
        children: [
          Icon(
            Platform.isAndroid
            ? FontAwesomeIcons.google
            : FontAwesomeIcons.apple,
            color: Colors.white,
          ),
          Text(
            '  Pay',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22
            ),
          ),
        ],
      ),
      onPressed: () async {
        
        final stripeService = StripeService();
        final bloc = BlocProvider.of<PayBloc>(context);

        final response = await stripeService.payWithAppleAndGooglePay(
          amount: bloc.state.amountToPayString, 
          currency: bloc.state.currency!
        );

        if (response.ok) {
          showAlert(
            context, 
            'Tarjeta ok', 
            'Todo correcto'
          );
        } else {
          showAlert(
            context, 
            'Algo salió mal', 
            response.message!
          );
        }
      },
    );
  }

  _processCardPayment(BuildContext context) async {
    showLoading(context);
    final stripeService = StripeService();
    final bloc = BlocProvider.of<PayBloc>(context);
    final card = bloc.state.card!;

    final response = await stripeService.payWithExistingCard(
      amount: bloc.state.amountToPayString, 
      currency: bloc.state.currency!, 
      card: CreditCard(
        number: card.cardNumber,
        name: card.cardHolderName,
        expMonth: int.parse(card.expDate.split('/')[0]),
        expYear: int.parse(card.expDate.split('/')[1]),
      )
    );

    Navigator.pop(context);

    if (response.ok) {
      showAlert(
        context, 
        'Tarjeta ok', 
        'Todo correcto'
      );
    } else {
      showAlert(
        context, 
        'Algo salió mal', 
        response.message!
      );
    }
  }
}

