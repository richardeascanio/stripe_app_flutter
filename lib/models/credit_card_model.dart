class CreditCardModel {
  String cardNumberHidden;
  String cardNumber;
  String brand;
  String cvv;
  String expDate;
  String cardHolderName;

  CreditCardModel({
    required this.cardNumberHidden,
    required this.cardNumber,
    required this.brand,
    required this.cvv,
    required this.expDate,
    required this.cardHolderName
  });
}