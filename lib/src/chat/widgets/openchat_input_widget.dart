import 'package:flutter/material.dart';

class OpenchatInputWidget extends StatefulWidget {
  final ValueChanged<String> submit;
  final bool enabled;
  const OpenchatInputWidget({
    super.key,
    required this.submit,
    required this.enabled,
  });

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
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _controller,
              textInputAction: TextInputAction.send,
              onFieldSubmitted: _subimit,
              enabled: widget.enabled,
              decoration: InputDecoration(
                fillColor: widget.enabled
                    ? Theme.of(context).colorScheme.background
                    : null,
                filled: true,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          ElevatedButton(
            onPressed: widget.enabled ? () => _subimit(_controller.text) : null,
            style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              padding: const MaterialStatePropertyAll(EdgeInsets.all(11)),
            ),
            child: const Icon(Icons.send),
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
