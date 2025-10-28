// lib/screens/checkout_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeub/Carts/cart_controller.dart';
import 'package:storeub/screens/done_screen.dart';
import 'package:storeub/screens/cart_screen.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:storeub/services/location_service.dart';

final LocationService _locationService = LocationService();

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

  //final _addressController = TextEditingController();
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
    final CartController cartController = Provider.of<CartController>(
      context,
      listen: true,
    );
    ///////////TODO ADD  INFORMATION FRO USER
    String actualUserID = "real_user_id_from_auth";
    String actualPhoneNumber = "+96278123456";
    //////////////////////////////////////

    bool orderSuccess = await cartController.placeOrder(
      deliveryAddress: _fetchedAddress!,
      ///////////TODO ADD  INFORMATION FRO USER ,   contactNumber: actualPhoneNumber,
      //       userID: actualUserID,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'), //
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
              Text(
                'Delivery instruction',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _buildDeliveryOptions(),
              const SizedBox(height: 24),
              Text(
                'Pay with',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _buildPaymentOptions(),
              const SizedBox(height: 24),
              PaymentSummaryWidget(),
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
        Icon(Icons.location_on, color: Colors.black, size: 40),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select your location',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: _locationLoading ? null : _handleGetLocation,
          child: Text('Change', style: TextStyle(color: Colors.orange)),
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
            activeColor: Colors.orange, //
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Image.asset(
            'assets/images/cash icon.png',
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
