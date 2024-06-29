import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';


class ChangePIN extends StatelessWidget {
  const ChangePIN({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(7, 15, 43, 1),
      appBar: AppBar(
        title: const Text("Change PIN", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(7, 15, 43, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Enter new PIN",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
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
                  onCompleted: (pin) {
                    // Simpan PIN baru ke Hive atau tempat penyimpanan yang sesuai
                    Hive.box('setting').put('pin', pin);
                    Navigator.pop(context); // Kembali ke halaman sebelumnya setelah berhasil mengubah PIN
                  },
                  onChanged: (value) {},
                  beforeTextPaste: (text) {
                    return false;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}