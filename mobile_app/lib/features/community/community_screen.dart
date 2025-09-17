import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/api/stackapp_api_client.dart';
import '../../core/models/community_models.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  bool _loadingChallenges = true;
  bool _loadingStories = true;
  List<StackChallenge> _challenges = const [];
  List<SuccessStory> _stories = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final c = await StackAppApiClient.getStackChallenges();
      final s = await StackAppApiClient.getSuccessStories();
      setState(() {
        _challenges = c;
        _stories = s;
      });
    } catch (_) {
      // Keep empty lists on error
    } finally {
      setState(() { _loadingChallenges = false; _loadingStories = false; });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: AppTheme.black,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.surface,
              child: const TabBar(
                indicatorColor: AppTheme.brightGold,
                labelColor: AppTheme.brightGold,
                unselectedLabelColor: AppTheme.gray,
                tabs: [
                  Tab(text: 'Challenges'),
                  Tab(text: 'Success Stories'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildChallengesTab(),
                  _buildSuccessStoriesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stack Building Challenges',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.black,
            ),
          ),
          const SizedBox(height: 16),
          
          if (_loadingChallenges)
            const Center(child: CircularProgressIndicator())
          else ...[
            for (final ch in _challenges) ...[
              _buildChallengeCard(
                title: ch.name,
                description: ch.description,
                reward: ch.reward,
                participants: ch.participants,
                difficulty: ch.difficulty,
                onJoin: () => _showJoinChallengeDialog(ch.name),
              ),
              const SizedBox(height: 16),
            ]
          ]
        ],
      ),
    );
  }

  Widget _buildSuccessStoriesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Community Success Stories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.black,
            ),
          ),
          const SizedBox(height: 16),
          
          if (_loadingStories)
            const Center(child: CircularProgressIndicator())
          else ...[
            for (final s in _stories) ...[
              _buildSuccessStoryCard(
                user: s.user,
                achievement: s.achievement,
                story: s.story,
                category: s.category,
                verified: s.verified,
              ),
              const SizedBox(height: 16),
            ]
          ]
        ],
      ),
    );
  }

  Widget _buildChallengeCard({
    required String title,
    required String description,
    required String reward,
    required int participants,
    required String difficulty,
    required VoidCallback onJoin,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.brightGold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.black,
                  ),
                ),
              ),
                Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(difficulty).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  difficulty,
                  style: TextStyle(
                    color: _getDifficultyColor(difficulty),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.gray,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.card_giftcard,
                color: AppTheme.brightGold,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                reward,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.brightGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.people,
                color: AppTheme.gray,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '$participants participants',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.gray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onJoin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.brightGold,
                foregroundColor: AppTheme.black,
              ),
              child: const Text('Join Challenge'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStoryCard({
    required String user,
    required String achievement,
    required String story,
    required String category,
    required bool verified,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.brightGold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.brightGold,
                child: Text(
                  user[0],
                  style: const TextStyle(
                    color: AppTheme.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.black,
                          ),
                        ),
                        if (verified) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.verified,
                            color: AppTheme.brightGold,
                            size: 16,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      achievement,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.brightGold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.emeraldGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    color: AppTheme.emeraldGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            story,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.white,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return AppTheme.emeraldGreen;
      case 'intermediate':
        return AppTheme.brightGold;
      case 'advanced':
        return Colors.red;
      default:
        return AppTheme.gray;
    }
  }

  void _showJoinChallengeDialog(String challengeName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Join $challengeName',
          style: const TextStyle(color: AppTheme.white),
        ),
        content: const Text(
          'This feature will connect to the StackApp backend to join community challenges and track your progress.',
          style: TextStyle(color: AppTheme.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: AppTheme.brightGold),
            ),
          ),
        ],
      ),
    );
  }
}
