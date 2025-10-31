// lib/screens/checkout_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeub/Carts/cart_controller.dart';
import 'package:storeub/screens/done_screen.dart';
import 'package:storeub/screens/cart_screen.dart';
import 'package:storeub/services/location_service.dart';
import 'package:storeub/Screens/Add_cart.dart';

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
  bool _locationLoading = false;
  String? _fetchedAddress;
  final LocationService _locationService = LocationService();

  Future<void> _handleGetLocation() async {
    setState(() {
      _locationLoading = true;
      _fetchedAddress = null;
    });
    try {
      final address = await _locationService.getCurrentAddress();
      if (mounted) {
        setState(() {
          _fetchedAddress = address;
          _locationLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _fetchedAddress = "Could not get location";
          _locationLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst("Exception: ", ""))),
        );
      }
    }
  }

  Future<void> _submitOrder() async {
    if (_fetchedAddress == null ||
        _fetchedAddress!.isEmpty ||
        _fetchedAddress!.contains("Could not")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please get your current location first.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    if (_paymentOption == PaymentMethod.card) {
      final cartController = Provider.of<CartController>(
        context,
        listen: false,
      );
      final double total = cartController.totalAmount;

      final paymentResult = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (ctx) => AddNewCardScreen(totalAmount: total),
        ),
      );

      if (paymentResult == true) {
        await _saveOrderToBackend();
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment was cancelled or failed.')),
        );
      }
    } else {
      await _saveOrderToBackend();
    }
  }

  Future<void> _saveOrderToBackend() async {
    final CartController cartController = Provider.of<CartController>(
      context,
      listen: false,
    );

    // ⚠️ TODO: استبدل هاي بالبيانات الحقيقية من Firebase Auth
    String actualUserID = "real_user_id_from_auth";
    String actualPhoneNumber = "+96278123456";

    bool orderSuccess = await cartController.placeOrder(
      deliveryAddress: _fetchedAddress!,
      contactNumber: actualPhoneNumber,
      userID: actualUserID,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

    if (!mounted) return;

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
    const String displayPhoneNumber = "+96278****78";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
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
              _buildLocationInfo(displayPhoneNumber),
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

  Widget _buildLocationInfo(String phoneNumber) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.phone_outlined, size: 24, color: Colors.black54),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Phone number : $phoneNumber',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                /* TODO: Change phone logic */
              },
              child: const Text(
                'Change',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: _locationLoading ? null : _handleGetLocation,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: _fetchedAddress == null ? Colors.grey : Colors.orange,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _locationLoading
                        ? 'Fetching location...'
                        : (_fetchedAddress ??
                            'Tap here or \'Change\' to get location'),
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          _fetchedAddress == null ? Colors.grey : Colors.black,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryOptions() {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.phone_in_talk_outlined),
          title: const Text('Call on arrival'),
          trailing: Radio<DeliveryInstruction>(
            value: DeliveryInstruction.call,
            groupValue: _deliveryOption,
            onChanged: (DeliveryInstruction? value) {
              setState(() {
                _deliveryOption = value!;
              });
            },
            activeColor: Colors.orange,
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.sms_outlined),
          title: const Text('Message on arrival'),
          trailing: Radio<DeliveryInstruction>(
            value: DeliveryInstruction.message,
            groupValue: _deliveryOption,
            onChanged: (DeliveryInstruction? value) {
              setState(() {
                _deliveryOption = value!;
              });
            },
            activeColor: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOptions() {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.add_card_outlined),
          title: const Text('Add new card'),
          trailing: Radio<PaymentMethod>(
            value: PaymentMethod.card,
            groupValue: _paymentOption,
            onChanged: (PaymentMethod? value) {
              setState(() {
                _paymentOption = value!;
              });
            },
            activeColor: Colors.orange,
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Image.asset(
            'assets/images/Vector_cash.png',
            width: 24,
            height: 24,
          ),
          title: const Text('Cash'),
          trailing: Radio<PaymentMethod>(
            value: PaymentMethod.cash,
            groupValue: _paymentOption,
            onChanged: (PaymentMethod? value) {
              setState(() {
                _paymentOption = value!;
              });
            },
            activeColor: Colors.orange,
          ),
        ),
      ],
    );
  }
}
