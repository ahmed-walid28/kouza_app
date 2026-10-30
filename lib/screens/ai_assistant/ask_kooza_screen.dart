import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/chat_message_model.dart';
import '../../services/ai_assistant_service.dart';

class AskKoozaScreen extends StatefulWidget {
  const AskKoozaScreen({super.key});

  @override
  State<AskKoozaScreen> createState() => _AskKoozaScreenState();
}

class _AskKoozaScreenState extends State<AskKoozaScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AiAssistantService _aiService = AiAssistantService();
  bool _isLoading = false;

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'أهلاً بيك يا غالي! أنا كوزة مساعدك الزراعي الذكي 🌾\n'
          'اسألني عن أي حاجة تخص التسميد، الري، خدمة المحاصيل، أو حل مشاكل التربة.. وأنا معاك خطوة بخطوة!',
      isUser: false,
      timestamp: DateTime.now(),
      suggestedActions: const [
        'أرضي رملية.. أعمل إيه؟',
        'ليه ورق النبات بيصفر؟',
        'أفضل ميعاد لزراعة القمح',
        'نصائح للري وقت الحرارة',
      ],
    ),
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    final query = text.trim();
    if (query.isEmpty) return;

    _textController.clear();
    setState(() {
      _messages.add(ChatMessage(
        text: query,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });
    _scrollToBottom();

    final response = await _aiService.getResponse(query);

    if (mounted) {
      setState(() {
        _messages.add(response);
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(AppStrings.assistantTitle),
          actions: [
            IconButton(
              tooltip: 'بدء محادثة جديدة',
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _messages.clear();
                  _messages.add(
                    ChatMessage(
                      text: 'أهلاً بيك من جديد مع كوزة! جاهز للإجابة على كل استفساراتك الزراعية 🌱',
                      isUser: false,
                      timestamp: DateTime.now(),
                      suggestedActions: const [
                        'أرضي رملية.. أعمل إيه؟',
                        'ليه ورق النبات بيصفر؟',
                        'أفضل ميعاد لزراعة القمح',
                      ],
                    ),
                  );
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Disclaimer Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: const Color(0xFFFFF9C4),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: Color(0xFFF57F17)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'نصائح كوزة إرشادية؛ في حالات الأمراض الحرجة يُرجى استشارة مهندس زراعي مختص.',
                      style: TextStyle(
                        fontFamily: 'Saudi',
                        fontSize: 11,
                        color: Color(0xFF5D4037),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Messages List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),

            // Loading Indicator
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(child: Image.asset(AppAssets.logo)),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'كوزة بيكتبلك الرد... 🌱',
                      style: TextStyle(
                        fontFamily: 'Saudi',
                        fontSize: 12,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

            // Input Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        style: const TextStyle(fontFamily: 'Saudi', fontSize: 14),
                        decoration: InputDecoration(
                          hintText: AppStrings.assistantHint,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 1.5),
                          ),
                        ),
                        onSubmitted: _sendMessage,
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      radius: 22,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white, size: 20),
                        onPressed: () => _sendMessage(_textController.text),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: message.isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: message.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!message.isUser) ...[
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: AppColors.primaryLight),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      AppAssets.logo,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.person, size: 20, color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? AppColors.primary
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: message.isUser
                          ? const Radius.circular(18)
                          : const Radius.circular(4),
                      bottomRight: message.isUser
                          ? const Radius.circular(4)
                          : const Radius.circular(18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      fontFamily: 'Saudi',
                      fontSize: 14,
                      height: 1.45,
                      color: message.isUser
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              if (message.isUser) const SizedBox(width: 8),
            ],
          ),

          // Suggested Action Chips if available
          if (!message.isUser &&
              message.suggestedActions != null &&
              message.suggestedActions!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(right: 44.0),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: message.suggestedActions!.map((action) {
                  return ActionChip(
                    label: Text(
                      action,
                      style: const TextStyle(
                        fontFamily: 'Saudi',
                        fontSize: 11,
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: const Color(0xFFE8F5E9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: AppColors.primaryLight.withValues(alpha: 0.4),
                      ),
                    ),
                    onPressed: () => _sendMessage(action),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
