import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:stripe_app/bloc/pay/pay_bloc.dart';
import 'package:stripe_app/data/cards.dart';
import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_app/pages/card_page.dart';
import 'package:stripe_app/widgets/pay_total_button.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;
    final bloc = BlocProvider.of<PayBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pagar'),
        actions: [
          IconButton(
            onPressed: () async {
              showAlert(context, 'Titulo', 'mensaje');

              // await Future.delayed(Duration(seconds: 1));
              // Navigator.pop(context);
            },
            icon: Icon(Icons.add)
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            height: size.height,
            width: size.width,
            top: 200,
            child: PageView.builder(
              controller: PageController(
                viewportFraction: 0.85
              ),
              physics: BouncingScrollPhysics(),
              itemCount: cards.length,
              itemBuilder: (_, int index) { 
                final currentCard = cards[index];
                return GestureDetector(
                  onTap: () {
                    bloc.add(OnSelectCard(currentCard));
                    Navigator.push(context, navigateFadeIn(context, CardPage()));
                  },
                  child: Hero(
                    tag: currentCard.cardNumber,
                    child: CreditCardWidget(
                      cardNumber: currentCard.cardNumber, 
                      expiryDate: currentCard.expDate, 
                      cardHolderName: currentCard.cardHolderName, 
                      cvvCode: currentCard.cvv, 
                      showBackView: false
                    ),
                  ),
                );
              },
              
            ),
          ),

          Positioned(
            bottom: 0,
            child: PayTotalButton()
          )
        ],
      )
    );
  }
}