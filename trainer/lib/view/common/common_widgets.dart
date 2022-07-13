
import 'package:flutter/material.dart';

Widget buildButton({
    String buttonText = "",
    required VoidCallback onPressed,
    Color backgroundColor = Colors.blueAccent}) {
  return SizedBox(
    height: 50,
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,//change background color of button
        onPrimary: Colors.white,//change text color of button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 15.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 20),
        ),
      ),

    ),
  );
}

Widget buildTextField({String label = "", TextEditingController? controller}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
    child: TextField(
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label
      ),
      controller: controller,
    ),
  );
}