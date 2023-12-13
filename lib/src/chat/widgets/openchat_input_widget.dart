import 'package:flutter/material.dart';

class OpenchatInputWidget extends StatefulWidget {
  final ValueChanged<String> submit;
  final bool enabled;
  const OpenchatInputWidget(
      {super.key, required this.submit, required this.enabled});

  @override
  State<OpenchatInputWidget> createState() => _OpenchatInputWidgetState();
}

class _OpenchatInputWidgetState extends State<OpenchatInputWidget> {
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
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _controller,
              textInputAction: TextInputAction.send,
              onFieldSubmitted: _subimit,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          ElevatedButton(
            onPressed: widget.enabled ? () => _subimit(_controller.text) : null,
            child: const Text('Enviar'),
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
