// lib/data/mock_resources.dart
import '../models/resource.dart';

final List<Resource> allResources = [
  Resource(id: 'R001', title: 'How to network without feeling awkward', description: 'Practical tips to build genuine professional connections.', type: ResourceType.article, category: 'Social', popularity: 92, tags: ['networking', 'social', 'career'], duration: '5 min read'),
  Resource(id: 'R002', title: '3-minute guide to managing your time', description: 'Simple frameworks that actually work for busy students.', type: ResourceType.guide, category: 'Productivity', popularity: 90, tags: ['time', 'productivity'], duration: '3 min'),
  Resource(id: 'R003', title: 'The science of self-confidence', description: 'What research says about building real confidence.', type: ResourceType.article, category: 'Confidence', popularity: 88, tags: ['confidence', 'science', 'self'], duration: '7 min read'),
  Resource(id: 'R004', title: 'Career exploration: Where to start', description: 'A simple framework for discovering what career suits you.', type: ResourceType.guide, category: 'Career', popularity: 87, tags: ['career', 'exploration'], duration: '5 min'),
  Resource(id: 'R005', title: 'Understanding compound interest', description: 'How investing early can change your financial future.', type: ResourceType.video, category: 'Finance', popularity: 85, tags: ['finance', 'investing'], duration: '8 min video'),
  Resource(id: 'R006', title: 'How to have difficult conversations', description: 'A step-by-step approach to navigating tough talks.', type: ResourceType.article, category: 'Communication', popularity: 83, tags: ['communication', 'relationships'], duration: '6 min read'),
  Resource(id: 'R007', title: 'The power of morning routines', description: 'How starting your day intentionally changes everything.', type: ResourceType.video, category: 'Productivity', popularity: 88, tags: ['habits', 'morning', 'routine'], duration: '6 min video'),
  Resource(id: 'R008', title: 'Emotional intelligence in practice', description: 'Real examples of using EQ in daily student life.', type: ResourceType.presentation, category: 'Social', popularity: 82, tags: ['EQ', 'emotions', 'social'], duration: '10 slides'),
  Resource(id: 'R009', title: 'Building a LinkedIn profile that works', description: 'Step-by-step guide to standing out on LinkedIn.', type: ResourceType.template, category: 'Career', popularity: 86, tags: ['LinkedIn', 'career', 'branding'], duration: '5 min'),
  Resource(id: 'R010', title: 'Mindfulness for college students', description: 'Simple mindfulness techniques that fit into a student lifestyle.', type: ResourceType.guide, category: 'Wellbeing', popularity: 89, tags: ['mindfulness', 'wellbeing', 'peace'], duration: '4 min'),
  Resource(id: 'R011', title: 'Public speaking: start here', description: 'Overcome stage fright and speak with impact.', type: ResourceType.video, category: 'Communication', popularity: 84, tags: ['speaking', 'confidence', 'communication'], duration: '9 min video'),
  Resource(id: 'R012', title: 'Goal-setting framework for students', description: 'A simple system to set and actually achieve goals.', type: ResourceType.template, category: 'Self', popularity: 87, tags: ['goals', 'planning', 'achievement'], duration: '5 min'),
];

final List<Map<String, String>> doYouKnowFacts = [
  {'title': 'Students who reflect daily improve faster', 'description': 'Research shows journaling for 5 minutes daily boosts self-awareness by 30%.', 'category': 'Self', 'emoji': '💡'},
  {'title': 'Networking can start in your own class', 'description': 'Your classmates are your first network. Engage them as future collaborators.', 'category': 'Career', 'emoji': '🤝'},
  {'title': 'Sleep is your secret study tool', 'description': 'A well-rested brain retains 40% more information than a sleep-deprived one.', 'category': 'Wellbeing', 'emoji': '😴'},
  {'title': 'Your strengths may surprise you', 'description': '70% of people underestimate at least 3 of their natural strengths.', 'category': 'Self', 'emoji': '⚡'},
  {'title': 'Financial literacy starts with curiosity', 'description': 'Understanding one financial concept per week can transform your relationship with money.', 'category': 'Finance', 'emoji': '📈'},
  {'title': 'Confidence grows through action, not waiting', 'description': 'Confidence follows action — not the other way around. Start before you feel ready.', 'category': 'Confidence', 'emoji': '🚀'},
];
