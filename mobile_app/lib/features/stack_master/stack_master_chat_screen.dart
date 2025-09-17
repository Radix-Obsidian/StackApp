import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../core/providers/stack_master_provider.dart';
import '../../core/models/stack_master_models.dart';
import '../../core/ui/cupertino_tokens.dart';
import '../shared/widgets/chat_bubble.dart';
import '../shared/widgets/chat_input.dart';

class StackMasterChatScreen extends StatefulWidget {
  const StackMasterChatScreen({super.key});

  @override
  State<StackMasterChatScreen> createState() => _StackMasterChatScreenState();
}

class _StackMasterChatScreenState extends State<StackMasterChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Add welcome message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<StackMasterProvider>(context, listen: false);
      if (provider.messages.isEmpty) {
        provider.sendMessage('Hello! I\'m ready to help you stack your bread!');
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('The Stack Master'),
        backgroundColor: CupertinoTokens.background,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Provider.of<StackMasterProvider>(context, listen: false)
                .clearMessages();
          },
          child: const Icon(CupertinoIcons.delete),
        ),
      ),
      backgroundColor: CupertinoTokens.background,
      child: Consumer<StackMasterProvider>(
        builder: (context, provider, child) {
          // Scroll to bottom when new messages are added
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });

          return Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: CupertinoTokens.background,
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoTokens.separator,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: CupertinoTokens.systemBlue,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'SM',
                        style: TextStyle(
                          color: CupertinoColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'The Stack Master',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.black,
                            ),
                          ),
                          Text(
                            'Your AI Financial Coach',
                            style: TextStyle(
                              fontSize: 14,
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (provider.isLoading)
                      const CupertinoActivityIndicator(),
                  ],
                ),
              ),
              
              // Messages
              Expanded(
                child: provider.messages.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.chat_bubble_2, size: 64, color: CupertinoColors.systemGrey),
                            SizedBox(height: 16),
                            Text('Start chatting with The Stack Master!', style: TextStyle(fontSize: 18, color: CupertinoColors.systemGrey)),
                            SizedBox(height: 8),
                            Text('Ask about investments, credit, or saving strategies', style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.messages.length,
                        itemBuilder: (context, index) {
                          final message = provider.messages[index];
                          return ChatBubble(message: message);
                        },
                      ),
              ),
              
              // Error message
              if (provider.error != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE5E5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.exclamationmark_triangle_fill, color: CupertinoColors.systemRed),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(provider.error!, style: const TextStyle(color: CupertinoColors.systemRed)),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: const Icon(CupertinoIcons.clear_circled_solid, color: CupertinoColors.systemRed),
                            onPressed: provider.clearError,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              
              // Input
              ChatInput(
                onSend: (message) {
                  provider.sendMessage(message);
                },
                isLoading: provider.isLoading,
              ),
            ],
          );
        },
      ),
    );
  }
}
