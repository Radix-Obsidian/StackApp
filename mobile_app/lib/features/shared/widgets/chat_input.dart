import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/ui/cupertino_tokens.dart';
import '../../../core/network/network_provider.dart';
import '../../../core/theme/app_theme.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSend;
  final bool isLoading;

  const ChatInput({
    super.key,
    required this.onSend,
    this.isLoading = false,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && !widget.isLoading) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<NetworkProvider>().isOnline;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: CupertinoTokens.background,
        border: Border(
          top: BorderSide(color: CupertinoTokens.separator, width: 1),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoTokens.secondaryBackground,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: CupertinoTokens.separator, width: 1),
                ),
                child: CupertinoTextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: !widget.isLoading && isOnline,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(color: CupertinoColors.black, fontSize: 16),
                  placeholder: 'Ask The Stack Master anything...',
                  placeholderStyle: const TextStyle(color: CupertinoColors.systemGrey, fontSize: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            CupertinoButton.filled(
              onPressed: widget.isLoading || !isOnline ? null : _sendMessage,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: widget.isLoading
                  ? const CupertinoActivityIndicator()
                  : const Icon(CupertinoIcons.paperplane_fill),
            ),
          ],
        ),
      ),
    );
  }
}
