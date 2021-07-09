import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stripe_app/bloc/pay/pay_bloc.dart';
import 'package:stripe_app/widgets/pay_total_button.dart';

class CardPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final bloc = BlocProvider.of<PayBloc>(context);
    final currentCard = bloc.state.card!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pagar'),
        leading: IconButton(
          onPressed: () {
            bloc.add(OnDeactivateCard());
            Navigator.pop(context);
          }, 
          icon: Icon(
            Platform.isIOS 
            ? Icons.arrow_back_ios_new
            : Icons.arrow_back
          )
        ),
      ),
      body: Stack(
        children: [

          Container(), // Se coloca el container para que el Stack abarque toda la pantalla

          Hero(
            tag: currentCard.cardNumber,
            child: CreditCardWidget(
              cardNumber: currentCard.cardNumber, 
              expiryDate: currentCard.expDate, 
              cardHolderName: currentCard.cardHolderName, 
              cvvCode: currentCard.cvv, 
              showBackView: false
            ),
          ),

          Positioned(
            bottom: 0,
            child: PayTotalButton()
          )
        ],
      ),
    );
  }
}