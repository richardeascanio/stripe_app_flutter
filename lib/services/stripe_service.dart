import 'package:dio/dio.dart';
import 'package:stripe_app/models/payment_intent_response.dart';
import 'package:stripe_app/models/stripe_custom_response.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeService {
  // Singleton
  StripeService._privateConstructor();
  static final StripeService _instance = StripeService._privateConstructor();
  factory StripeService() => _instance;

  String _paymentApiUrl = 'https://api.stripe.com/v1/payment_intents';
  static String _secretKey =
    'sk_test_51JBMiTLEVkmP2KrEcAsh9UHLtOIWGLyGR0w2UMNvzV1sJNBAJQS3qwVzVUMMnLdg5FWHCA9JD77b0kHSiRJo8cUD00MtRVw8dL';
  String _apiKey =
    'pk_test_51JBMiTLEVkmP2KrE5VJ2zdwi3w6ImjkjzE9hHa9ys2rLCT3mqOwAAXruOvXX0QH731QSlEtRbBMuQTWidmox2BfO00C3A4ySOv';

  final headerOptions = Options(
      contentType: Headers.formUrlEncodedContentType,
      headers: {'Authorization': 'Bearer ${StripeService._secretKey}'});

  void init() {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: this._apiKey,
        androidPayMode: 'test',
        merchantId: 'test'
      )
    );
  }

  Future payWithExistingCard({
    required String amount,
    required String currency,
    required CreditCard card, // stripe credit card model
  }) async {}

  Future<StripeCustomResponse> payWithNewCard({
    required String amount,
    required String currency,
  }) async {
    try {
      // Payment Method
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest());

      final response = await this._doPayment(
        amount: amount, 
        currency: currency, 
        paymentMethod: paymentMethod
      );

      return response;
    } catch (e) {
      return StripeCustomResponse(ok: false, message: e.toString());
    }
  }

  Future payWithAppleAndGooglePay({
    required String amount,
    required String currency,
  }) async {}

  Future<PaymentIntentResponse> _createPaymentIntent({
    required String amount,
    required String currency,
  }) async {
    try {

      final dio = Dio();
      final data = {
        'amount': amount, 
        'currency': currency
      };

      final response = await dio.post(
        _paymentApiUrl, 
        data: data, 
        options: headerOptions
      );
      return PaymentIntentResponse.fromJson(response.data);

    } catch (e) {
      return PaymentIntentResponse(
        id: '',
        object: '',
        amount: 0,
        amountCapturable: 0,
        amountReceived: 0,
        captureMethod: '',
        charges: Charges(data: [], hasMore: false, object: '', totalCount: 0, url: ''),
        clientSecret: '',
        confirmationMethod: '',
        created: 0,
        currency: '',
        livemode: false,
        metadata: Metadata(),
        paymentMethodOptions: PaymentMethodOptions(card: Card(requestThreeDSecure: '')),
        paymentMethodTypes: [],
        status: '400'
      );
    }
  }

  Future<StripeCustomResponse> _doPayment({
    required String amount,
    required String currency,
    required PaymentMethod paymentMethod,
  }) async {
    try {
      // Payment intent
      final paymentIntent = await this._createPaymentIntent(
        amount: amount, 
        currency: currency
      );

      final paymentResult = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntent.clientSecret,
          paymentMethodId: paymentMethod.id
        )
      );

      if (paymentResult.status == 'succeeded') {
        return StripeCustomResponse(ok: true);
      } else {
        return StripeCustomResponse(
          ok: false, 
          message: 'Falló: ${paymentResult.status}'
        );
      }
    } catch (e) {
      print(e.toString());
      return StripeCustomResponse(ok: false, message: e.toString());
    }
  }
}
