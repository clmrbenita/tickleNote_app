import 'package:ambw_uas_c14210125/homepage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _pinController = TextEditingController();
  final _box = Hive.box('setting');
  String message = "Enter your PIN";
  bool _pinFilled = false;

  @override
  void initState() {
    super.initState();
    if (!_box.containsKey('pin')) {
      message = "Please, create your PIN";
    }
  }

  void _handlePinSubmit(String pin) {
    if (pin.isEmpty || pin.length != 4) {
      setState(() {
        message = "PIN must be 4 digits!";
      });
      return;
    }

    if (_box.containsKey('pin')) {
      final storedPin = _box.get('pin');
      if (pin == storedPin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NotesScreen()),
        );
      } else {
        setState(() {
          message = "Incorrect PIN, try again!";
        });
      }
    } else {
      _box.put('pin', pin);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NotesScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(7, 15, 43, 1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Image.asset(
                  'lib/images/notebook.png', // Replace with your image path
                  height: 150, // Adjust height as needed
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Tickle Note",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 50),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  keyboardType: TextInputType.number,
                  textStyle: const TextStyle(color: Colors.white, fontSize: 5),
                  obscureText: true,
                  enableActiveFill: true,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 45,
                    fieldWidth: 40,
                    inactiveColor: const Color.fromRGBO(83, 92, 145, 1),
                    activeColor: const Color.fromRGBO(83, 92, 145, 1),
                    selectedColor: const Color.fromRGBO(146, 144, 195, 1),
                    selectedFillColor: const Color.fromRGBO(83, 92, 145, 1),
                    inactiveFillColor: const Color.fromRGBO(83, 92, 145, 1),
                    activeFillColor: const Color.fromRGBO(83, 92, 145, 1),

                    // activeFillColor: Colors.blue,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  controller: _pinController,
                  // onCompleted: _handlePinSubmit,
                  onCompleted: (pin) {
                    setState(() {
                      _pinFilled = true;
                    });
                    _handlePinSubmit(pin);
                  },
                  onChanged: (value) {
                    setState(() {
                      _pinFilled = value.isNotEmpty;
                    });
                  },
                  beforeTextPaste: (text) {
                    return false;
                  },
              
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: _pinFilled
                    ? () => _handlePinSubmit(_pinController.text)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(83, 92, 145, 1),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 15.0),
                  textStyle: const TextStyle(color: Colors.white, fontSize: 15),
                  disabledBackgroundColor: const Color.fromRGBO(
                      83, 92, 145, 0.5) ,
                   // Warna tombol ketika dinonaktifkan
                ),
                child: const Text(
                  "SUBMIT",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
