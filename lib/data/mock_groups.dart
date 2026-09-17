// lib/data/mock_groups.dart
import '../models/group.dart';

final List<Group> publicGroups = [
  Group(id: 'G001', name: 'Entrepreneurship Hub', description: 'For students who dream of building something of their own.', type: GroupType.public, category: 'Business', emoji: '🚀', memberCount: 1247, createdBy: 'ConfiCircle', tags: ['startup', 'business', 'entrepreneurship']),
  Group(id: 'G002', name: 'Higher Studies & Research', description: 'Explore masters, PhDs, research opportunities and more.', type: GroupType.public, category: 'Academic', emoji: '🎓', memberCount: 892, createdBy: 'ConfiCircle', tags: ['research', 'masters', 'PhD']),
  Group(id: 'G003', name: 'Career Clarity Circle', description: 'Navigate job search, interviews and career decisions together.', type: GroupType.public, category: 'Career', emoji: '💼', memberCount: 1580, createdBy: 'ConfiCircle', tags: ['career', 'jobs', 'interviews']),
  Group(id: 'G004', name: 'Finance & Investing', description: 'Learn investing basics and personal finance together.', type: GroupType.public, category: 'Finance', emoji: '📈', memberCount: 673, createdBy: 'ConfiCircle', tags: ['finance', 'investing', 'money']),
  Group(id: 'G005', name: 'Confident You', description: 'A safe space to build self-confidence and self-worth.', type: GroupType.public, category: 'Self', emoji: '💪', memberCount: 2100, createdBy: 'ConfiCircle', tags: ['confidence', 'self-worth']),
  Group(id: 'G006', name: 'Wellness Warriors', description: 'Mental health, peace and wellbeing for college students.', type: GroupType.public, category: 'Wellbeing', emoji: '🌿', memberCount: 1450, createdBy: 'ConfiCircle', tags: ['wellness', 'mental health', 'peace']),
];

final List<StudentCard> sampleStudents = [
  StudentCard(id: 'S001', name: 'Priya Sharma', college: 'Delhi University', course: 'Psychology', confiLevel: 5, confiScore: 62, avatarEmoji: '👩‍🎓', interests: ['Confidence', 'Communication'], completedPrograms: ['Confidence Check', '60-Second Check']),
  StudentCard(id: 'S002', name: 'Arjun Mehta', college: 'IIT Bombay', course: 'Engineering', confiLevel: 7, confiScore: 74, avatarEmoji: '👨‍💻', interests: ['Career', 'Leadership'], completedPrograms: ['Career Direction', 'Decision Making']),
  StudentCard(id: 'S003', name: 'Zara Khan', college: 'St. Xavier\'s', course: 'Business', confiLevel: 4, confiScore: 55, avatarEmoji: '👩‍💼', interests: ['Entrepreneurship', 'Finance'], completedPrograms: ['Confidence Check']),
];
