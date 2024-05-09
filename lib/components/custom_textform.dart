import 'package:flutter/material.dart';
import 'package:student_hub/utils/text_util.dart';
import 'package:student_hub/utils/textform_util.dart';
import 'package:flutter/services.dart';

// define invalid inputs of textfield
enum InvalidationType {
  isBlank(message: 'Is not blank'),
  isInvalidEmail(message: 'Invalid email'),
  isInvalidPassword(
      message:
          '8-20 characters,\nat least an uppercase, a lowercase, a number and !@#\$%^&*');

  const InvalidationType({required this.message});
  final String message;
}

// generate text form field
class CustomTextForm extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final List<InvalidationType> listErros;
  final bool obscureText;
  final bool isFocus;
  final bool isBold;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormaters;
  // this function helps you handle error in a parent widget
  // for sample: handle enabling/disabling a submit button
  final void Function(String? messageError) onHelper;

  const CustomTextForm(
      {super.key,
      required this.controller,
      required this.listErros,
      required this.hintText,
      required this.onHelper,
      this.obscureText = false,
      this.isFocus = false,
      this.isBold = false,
      this.keyboardType,
      this.inputFormaters});

  @override
  State<CustomTextForm> createState() => _CustomTextFormState();
}

class _CustomTextFormState extends State<CustomTextForm> {
  String? _messageError;

  // check validation
  void _validate(String value) {
    if (widget.listErros.isEmpty) {
      setState(() {
        _messageError = null;
        widget.onHelper(_messageError);
      });
      return;
    }

    for (final error in widget.listErros) {
      switch (error) {
        case InvalidationType.isBlank:
          if (TextFormUtil.isBlank(value)) {
            setState(() {
              _messageError = InvalidationType.isBlank.message;
              widget.onHelper(_messageError);
            });
            return;
          }
        case InvalidationType.isInvalidEmail:
          if (!TextFormUtil.isValidEmail(value)) {
            setState(() {
              _messageError = InvalidationType.isInvalidEmail.message;
              widget.onHelper(_messageError);
            });
            return;
          }
        case InvalidationType.isInvalidPassword:
          if (!TextFormUtil.isValidPassword(value)) {
            setState(() {
              _messageError = InvalidationType.isInvalidPassword.message;
              widget.onHelper(_messageError);
            });
            return;
          }
        default:
          setState(() {
            _messageError = null;
            widget.onHelper(_messageError);
          });
      }
    }

    setState(() {
      _messageError = null;
      widget.onHelper(_messageError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: widget.isFocus,
      cursorColor: Theme.of(context).colorScheme.onPrimary,
      decoration: InputDecoration(
        hintText: widget.hintText,
        filled: true,
        fillColor: Theme.of(context).colorScheme.onSecondary,
        errorText: _messageError,
      ),
      controller: widget.controller,
      validator: (String? value) {
        return _messageError;
      },
      onTap: () {
        if (widget.listErros.contains(InvalidationType.isBlank)) {
          setState(() {
            _messageError = widget.controller.text.isEmpty
                ? InvalidationType.isBlank.message
                : _messageError;
            widget.onHelper(_messageError);
          });
        }
      },
      onChanged: _validate,
      style: const TextStyle(fontSize: TextUtil.textSize),
      obscureText: widget.obscureText ? true : false,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormaters,
    );
  }
}
