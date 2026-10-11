import 'package:flutter/material.dart';

import '../design/typography.dart';
import '../l10n/l10n.dart';

/// Rounded search box with a search icon and a clear button.
class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.hint,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
  });

  final String hint;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: widget.keyboardType,
      textInputAction: TextInputAction.search,
      style: AppText.body,
      onChanged: (value) {
        widget.onChanged(value);
        setState(() {});
      },
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: const Icon(Icons.search_rounded, size: 22),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: context.l10n.commonClearSearch,
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: _clear,
              ),
      ),
    );
  }
}
