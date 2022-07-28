
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
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label
      ),
      controller: controller,
    ),
  );
}

Widget buildDropdownButton({
  String label = "",
  String initialValue = "5",
  required Function(String?)? callback}) {
  var list = List<int>.generate(10, (i) => i + 1)
  .map((e) => e.toString()).toList();

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 17,
          ),
        ),
        DropdownButton(
          value: initialValue,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: list.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          }).toList(),
          onChanged: callback
        ),
      ],
    ),
  );
}

Widget buildTitleText({String text = ""}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold
      ),
      textAlign: TextAlign.left,
    ),
  );
}

Widget buildNormalText({String text = ""}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
    child: Text(
      text,
      style: const TextStyle(
          fontSize: 17,
      ),
      textAlign: TextAlign.left,
    ),
  );
}