import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/stack_master_provider.dart';
import '../../core/models/stack_master_models.dart';
import '../../core/theme/app_theme.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Stack Master'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: AppTheme.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              Provider.of<StackMasterProvider>(context, listen: false)
                  .clearMessages();
            },
          ),
        ],
      ),
      body: Consumer<StackMasterProvider>(
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
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.systemBlue.withOpacity(0.12),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppTheme.systemBlue,
                      child: const Text(
                        'SM',
                        style: TextStyle(
                          color: AppTheme.white,
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
                              color: AppTheme.black,
                            ),
                          ),
                          Text(
                            'Your AI Financial Coach',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.gray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (provider.isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.systemBlue),
                        ),
                      ),
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
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: AppTheme.gray,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Start chatting with The Stack Master!',
                              style: TextStyle(
                                fontSize: 18,
                              color: AppTheme.gray,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Ask about investments, credit, or saving strategies',
                              style: TextStyle(
                                fontSize: 14,
                              color: AppTheme.gray,
                              ),
                            ),
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
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.red.withOpacity(0.1),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          provider.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          provider.clearError();
                        },
                      ),
                    ],
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
