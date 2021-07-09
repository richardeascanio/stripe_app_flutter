import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stripe_app/models/credit_card_model.dart';
import 'package:stripe_app/widgets/pay_total_button.dart';

class CardPage extends StatelessWidget {

  final currentCard = CreditCardModel(
    cardNumberHidden: '4242',
    cardNumber: '4242424242424242',
    brand: 'visa',
    cvv: '213',
    expDate: '01/25',
    cardHolderName: 'Fernando Herrera'
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagar'),
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