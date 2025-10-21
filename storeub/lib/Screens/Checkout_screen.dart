// lib/screens/checkout_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeub/Carts/cart_controller.dart';
import 'package:storeub/screens/done_screen.dart';
//  PaymentSummaryWidget
import 'package:storeub/screens/cart_screen.dart';

enum DeliveryInstruction { call, message }

enum PaymentMethod { card, cash }

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  DeliveryInstruction _deliveryOption = DeliveryInstruction.call;
  PaymentMethod _paymentOption = PaymentMethod.cash;
  bool _isLoading = false;

  Future<void> _submitOrder() async {
    setState(() {
      _isLoading = true;
    });

    final cartController = Provider.of<CartController>(context, listen: false);

    bool orderSuccess = await cartController.placeOrder(
      deliveryAddress: "Name of University - (From UI)", //
      contactNumber: "+96278...78", //
      userID: "mock_user_12345", //
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

    if (!mounted) return; //

    if (orderSuccess) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (ctx) => const DoneScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send the request, Please try again'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chechout'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLocationInfo(),
              const SizedBox(height: 24),
              const Text(
                'Delivery instruction',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _buildDeliveryOptions(),
              const SizedBox(height: 24),
              const Text(
                'Pay with',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _buildPaymentOptions(),
              const SizedBox(height: 24),
              const PaymentSummaryWidget(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _submitOrder,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child:
              _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                    'Place order',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
        ),
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Row(
      children: [
        Image.asset('UX/gis_poi-map.png', width: 60, height: 60),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name of University',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                'Phone number : +96278****78',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Change', style: TextStyle(color: Colors.orange)),
        ),
      ],
    );
  }

  Widget _buildDeliveryOptions() {
    return Column(
      children: [
        RadioListTile<DeliveryInstruction>(
          title: const Text('Call on arrival'),
          secondary: const Icon(Icons.phone_in_talk_outlined),
          value: DeliveryInstruction.call,
          groupValue: _deliveryOption,
          onChanged: (DeliveryInstruction? value) {
            setState(() {
              _deliveryOption = value!;
            });
          },
          activeColor: Colors.orange,
        ),
        RadioListTile<DeliveryInstruction>(
          title: const Text('Message on arrival'),
          secondary: const Icon(Icons.sms_outlined),
          value: DeliveryInstruction.message,
          groupValue: _deliveryOption,
          onChanged: (DeliveryInstruction? value) {
            setState(() {
              _deliveryOption = value!;
            });
          },
          activeColor: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildPaymentOptions() {
    return Column(
      children: [
        RadioListTile<PaymentMethod>(
          title: const Text('Add new card'),
          secondary: const Icon(Icons.add_card_outlined),
          value: PaymentMethod.card,
          groupValue: _paymentOption,
          onChanged: null, //
        ),
        RadioListTile<PaymentMethod>(
          title: const Text('Cash'),
          secondary: Image.asset('UX/cash icon.png', width: 24, height: 24),
          value: PaymentMethod.cash,
          groupValue: _paymentOption,
          onChanged: (PaymentMethod? value) {
            setState(() {
              _paymentOption = value!;
            });
          },
          activeColor: Colors.orange,
        ),
      ],
    );
  }
}
