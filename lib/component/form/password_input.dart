import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final String labelText;
  final bool isObscure;
  final ValueChanged<bool> onVisibilityToggle;

  const PasswordInput({
    super.key,
    required this.labelText,
    this.isObscure = true,
    required this.onVisibilityToggle,
  });

  @override
  PasswordInputState createState() => PasswordInputState();
}

class PasswordInputState extends State<PasswordInput> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isObscure;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        obscureText: _isObscure,
        decoration: InputDecoration(
          labelText: widget.labelText,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          suffixIcon: IconButton(
            icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
                widget.onVisibilityToggle(_isObscure);
              });
            },
          ),
        ),
      ),
    );
  }
}
