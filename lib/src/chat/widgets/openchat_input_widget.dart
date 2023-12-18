// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class OpenchatInputWidget extends StatefulWidget {
  static const INPUT_KEY = Key('INPUT_KEY');
  static const INPUT_BUTTON_KEY = Key('INPUT_BUTTON_KEY');
  final ValueChanged<String> submit;
  final bool enabled;
  final bool saying;
  const OpenchatInputWidget({
    super.key,
    required this.submit,
    required this.enabled,
    required this.saying,
  });

  @override
  State<OpenchatInputWidget> createState() => _OpenchatInputWidgetState();
}

class _OpenchatInputWidgetState extends State<OpenchatInputWidget> {
  static const buttonSize = 50.0;
  late TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              key: OpenchatInputWidget.INPUT_KEY,
              controller: _controller,
              textInputAction: TextInputAction.send,
              onFieldSubmitted: _subimit,
              enabled: widget.enabled,
              decoration: InputDecoration(
                fillColor: widget.enabled
                    ? Theme.of(context).colorScheme.background
                    : null,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(buttonSize / 2),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: ElevatedButton(
              key: OpenchatInputWidget.INPUT_BUTTON_KEY,
              onPressed:
                  widget.enabled ? () => _subimit(_controller.text) : null,
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                padding: const MaterialStatePropertyAll(EdgeInsets.zero),
              ),
              child: widget.saying
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    )
                  : const Icon(Icons.send),
            ),
          )
        ],
      ),
    );
  }

  void _subimit(String value) {
    if (widget.enabled) {
      _controller.clear();
      widget.submit(value);
    }
  }
}
