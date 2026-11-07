// lib/data/mock_actions.dart
import '../models/action_item.dart';

final List<ActionItem> allActions = [
  // Career & Higher Studies
  ActionItem(id: 'A001', text: 'Explore higher studies and research', level1: 'Career', level2: 'Academic Growth', level3: 'Higher Education', tags: ['career', 'research', 'studies'], popularity: 95, emoji: '🎓', colorHex: '#1A2F6B'),
  ActionItem(id: 'A002', text: 'Find a meaningful job', level1: 'Career', level2: 'Career Clarity', level3: 'Job Search', tags: ['career', 'job', 'purpose'], popularity: 90, emoji: '💼', colorHex: '#173883'),
  ActionItem(id: 'A003', text: 'Build a strong resume', level1: 'Career', level2: 'Career Clarity', level3: 'Resume Skills', tags: ['career', 'resume'], popularity: 85, emoji: '📄', colorHex: '#4475D7'),
  ActionItem(id: 'A004', text: 'Crack my next interview', level1: 'Career', level2: 'Career Clarity', level3: 'Interview Prep', tags: ['career', 'interview'], popularity: 88, emoji: '🤝', colorHex: '#173883'),
  ActionItem(id: 'A005', text: 'Start my own business someday', level1: 'Career', level2: 'Entrepreneurship', level3: 'Startup Mindset', tags: ['entrepreneur', 'business'], popularity: 82, emoji: '🚀', colorHex: '#F2432C'),

  // Self Development
  ActionItem(id: 'A006', text: 'Recognize my strengths', level1: 'Self', level2: 'Self-Awareness', level3: 'Strengths Discovery', tags: ['self', 'strengths', 'growth'], popularity: 93, emoji: '⚡', colorHex: '#F2432C'),
  ActionItem(id: 'A007', text: 'Build my confidence', level1: 'Self', level2: 'Confidence & Self-Worth', level3: 'Self-Confidence', tags: ['confidence', 'self'], popularity: 91, emoji: '💪', colorHex: '#173883'),
  ActionItem(id: 'A008', text: 'Stop overthinking and take action', level1: 'Self', level2: 'Personal Effectiveness', level3: 'Decisiveness', tags: ['mindset', 'action'], popularity: 87, emoji: '🎯', colorHex: '#4475D7'),
  ActionItem(id: 'A009', text: 'Manage my time better', level1: 'Self', level2: 'Personal Effectiveness', level3: 'Time Management', tags: ['productivity', 'time'], popularity: 89, emoji: '⏰', colorHex: '#173883'),
  ActionItem(id: 'A010', text: 'Build better daily habits', level1: 'Self', level2: 'Personal Effectiveness', level3: 'Habit Formation', tags: ['habits', 'routine'], popularity: 86, emoji: '✅', colorHex: '#27AE60'),

  // Communication
  ActionItem(id: 'A011', text: 'Become more persuasive', level1: 'Communication', level2: 'Influence & Persuasion', level3: 'Persuasion Skills', tags: ['communication', 'influence'], popularity: 92, emoji: '🗣️', colorHex: '#F2432C'),
  ActionItem(id: 'A012', text: 'Speak confidently in public', level1: 'Communication', level2: 'Public Speaking', level3: 'Presentation Skills', tags: ['speaking', 'confidence'], popularity: 88, emoji: '🎤', colorHex: '#173883'),
  ActionItem(id: 'A013', text: 'Write more effectively', level1: 'Communication', level2: 'Written Communication', level3: 'Writing Skills', tags: ['writing', 'communication'], popularity: 80, emoji: '✍️', colorHex: '#4475D7'),
  ActionItem(id: 'A014', text: 'Have difficult conversations', level1: 'Communication', level2: 'Interpersonal Communication', level3: 'Conflict Resolution', tags: ['communication', 'relationships'], popularity: 77, emoji: '💬', colorHex: '#F2432C'),

  // Finance
  ActionItem(id: 'A015', text: 'Understand investing', level1: 'Finance', level2: 'Financial Growth', level3: 'Investment Basics', tags: ['finance', 'investing', 'money'], popularity: 90, emoji: '📈', colorHex: '#27AE60'),
  ActionItem(id: 'A016', text: 'Manage my money better', level1: 'Finance', level2: 'Financial Basics', level3: 'Budgeting', tags: ['finance', 'budget'], popularity: 85, emoji: '💰', colorHex: '#27AE60'),
  ActionItem(id: 'A017', text: 'Understand how markets work', level1: 'Finance', level2: 'Financial Growth', level3: 'Market Basics', tags: ['finance', 'markets'], popularity: 78, emoji: '📊', colorHex: '#173883'),

  // Relationships & Social
  ActionItem(id: 'A018', text: 'Become better at understanding other people', level1: 'Social', level2: 'Emotional Intelligence', level3: 'Empathy', tags: ['social', 'empathy', 'EQ'], popularity: 91, emoji: '🤍', colorHex: '#4475D7'),
  ActionItem(id: 'A019', text: 'Build meaningful friendships', level1: 'Social', level2: 'Relationships', level3: 'Friendship Building', tags: ['social', 'friendships'], popularity: 83, emoji: '👥', colorHex: '#F2432C'),
  ActionItem(id: 'A020', text: 'Handle peer pressure better', level1: 'Social', level2: 'Relationships', level3: 'Social Resilience', tags: ['social', 'peer pressure'], popularity: 79, emoji: '🛡️', colorHex: '#173883'),
  ActionItem(id: 'A021', text: 'Become a better leader', level1: 'Social', level2: 'Leadership', level3: 'Leadership Skills', tags: ['leadership', 'influence'], popularity: 86, emoji: '👑', colorHex: '#F2432C'),

  // Wellbeing
  ActionItem(id: 'A022', text: 'Feel more peaceful in daily life', level1: 'Wellbeing', level2: 'Mental Wellness', level3: 'Inner Peace', tags: ['wellbeing', 'peace', 'mental health'], popularity: 94, emoji: '🌿', colorHex: '#27AE60'),
  ActionItem(id: 'A023', text: 'Manage stress better', level1: 'Wellbeing', level2: 'Mental Wellness', level3: 'Stress Management', tags: ['stress', 'wellness'], popularity: 90, emoji: '🧘', colorHex: '#4475D7'),
  ActionItem(id: 'A024', text: 'Sleep better and feel more energized', level1: 'Wellbeing', level2: 'Physical Wellness', level3: 'Sleep & Energy', tags: ['sleep', 'energy', 'health'], popularity: 82, emoji: '😴', colorHex: '#173883'),
  ActionItem(id: 'A025', text: 'Stop comparing myself to others', level1: 'Wellbeing', level2: 'Self-Acceptance', level3: 'Comparison Trap', tags: ['mindset', 'self-worth'], popularity: 88, emoji: '🌟', colorHex: '#F2432C'),
  ActionItem(id: 'A026', text: 'Find my passion and purpose', level1: 'Wellbeing', level2: 'Life Purpose', level3: 'Purpose Discovery', tags: ['purpose', 'passion', 'meaning'], popularity: 87, emoji: '🔥', colorHex: '#F2432C'),

  // Learning
  ActionItem(id: 'A027', text: 'Study smarter, not harder', level1: 'Learning', level2: 'Academic Skills', level3: 'Study Strategies', tags: ['study', 'academic', 'learning'], popularity: 84, emoji: '📚', colorHex: '#173883'),
  ActionItem(id: 'A028', text: 'Develop a reading habit', level1: 'Learning', level2: 'Personal Growth', level3: 'Reading Habits', tags: ['reading', 'learning'], popularity: 80, emoji: '📖', colorHex: '#4475D7'),
  ActionItem(id: 'A029', text: 'Learn a new skill this month', level1: 'Learning', level2: 'Skill Building', level3: 'New Skills', tags: ['skills', 'learning'], popularity: 83, emoji: '🎯', colorHex: '#F2432C'),

  // More diverse actions
  ActionItem(id: 'A030', text: 'Create a LinkedIn profile that works', level1: 'Career', level2: 'Personal Branding', level3: 'Online Presence', tags: ['career', 'LinkedIn', 'branding'], popularity: 81, emoji: '🔗', colorHex: '#4475D7'),
  ActionItem(id: 'A031', text: 'Network without feeling awkward', level1: 'Social', level2: 'Networking', level3: 'Professional Networking', tags: ['networking', 'career', 'social'], popularity: 85, emoji: '🤝', colorHex: '#173883'),
  ActionItem(id: 'A032', text: 'Make the most of college opportunities', level1: 'Career', level2: 'Academic Growth', level3: 'College Life', tags: ['college', 'opportunities'], popularity: 88, emoji: '🏫', colorHex: '#4475D7'),
  ActionItem(id: 'A033', text: 'Deal with failure and bounce back', level1: 'Self', level2: 'Resilience', level3: 'Failure Recovery', tags: ['resilience', 'mindset'], popularity: 86, emoji: '💎', colorHex: '#F2432C'),
  ActionItem(id: 'A034', text: 'Set goals I actually achieve', level1: 'Self', level2: 'Personal Effectiveness', level3: 'Goal Setting', tags: ['goals', 'achievement'], popularity: 89, emoji: '🎯', colorHex: '#173883'),
  ActionItem(id: 'A035', text: 'Be more consistent and disciplined', level1: 'Self', level2: 'Personal Effectiveness', level3: 'Discipline', tags: ['discipline', 'consistency'], popularity: 87, emoji: '⚙️', colorHex: '#4475D7'),
  ActionItem(id: 'A036', text: 'Understand my emotions better', level1: 'Wellbeing', level2: 'Emotional Intelligence', level3: 'Emotional Awareness', tags: ['EQ', 'emotions', 'self'], popularity: 84, emoji: '💙', colorHex: '#4475D7'),
];

// Initial 6 curated actions for first-time students
final List<String> initialSixActionIds = [
  'A001', // Explore higher studies and research
  'A006', // Recognize my strengths
  'A011', // Become more persuasive
  'A015', // Understand investing
  'A018', // Become better at understanding other people
  'A022', // Feel more peaceful in daily life
];

List<ActionItem> getInitialSixActions() {
  return allActions.where((a) => initialSixActionIds.contains(a.id)).toList();
}

List<ActionItem> getExploreMoreActions(List<String> excludeIds) {
  final available = allActions.where((a) => !excludeIds.contains(a.id)).toList();
  available.sort((a, b) => b.popularity.compareTo(a.popularity));
  return available.take(6).toList();
}
