// lib/data/mock_programs.dart
import '../models/program.dart';

final List<Program> allPrograms = [
  // Assessments
  Program(id: 'P001', name: 'Confidence Check', description: 'Get a quick picture of where you are.', type: ProgramType.assessment, isFree: true, category: 'Confidence', duration: '5 min', emoji: '✅', colorHex: '#173883', popularity: 95),
  Program(id: 'P002', name: 'Career Direction', description: 'Learn about where is to go in your career direction.', type: ProgramType.assessment, isFree: true, category: 'Career', duration: '8 min', emoji: '🧭', colorHex: '#4475D7', popularity: 90),
  Program(id: 'P003', name: 'Decision Making Style', description: 'Descriptions making to decision making.', type: ProgramType.assessment, isFree: true, category: 'Self', duration: '6 min', emoji: '⚖️', colorHex: '#F2432C', popularity: 85),
  Program(id: 'P004', name: 'Basic Confi Assessment', description: 'Your complete Confi baseline — strengths, gaps and growth direction.', type: ProgramType.assessment, isFree: true, category: 'All', duration: '15 min', emoji: '🎯', colorHex: '#173883', popularity: 99),

  // Quick Actions
  Program(id: 'Q001', name: '60-Second Confidence Check', description: 'A rapid self-check to see how confident you feel right now.', type: ProgramType.quickAction, isFree: true, category: 'Confidence', duration: '1 min', emoji: '⚡', colorHex: '#F2432C', popularity: 92),
  Program(id: 'Q002', name: 'Try This Communication Challenge', description: 'One simple challenge to boost your communication today.', type: ProgramType.quickAction, isFree: true, category: 'Communication', duration: '3 min', emoji: '💬', colorHex: '#4475D7', popularity: 88),
  Program(id: 'Q003', name: 'Test Your Decision Style', description: 'Discover how you naturally make decisions.', type: ProgramType.quickAction, isFree: true, category: 'Self', duration: '2 min', emoji: '🎲', colorHex: '#173883', popularity: 84),
  Program(id: 'Q004', name: 'A quick self-discovery question for you', description: 'One powerful question that reveals something about yourself.', type: ProgramType.quickAction, isFree: true, category: 'Self', duration: '2 min', emoji: '🔍', colorHex: '#F2432C', popularity: 91),

  // Self-paced Learning
  Program(id: 'S001', name: 'Masterclasses', description: 'Expert-led video sessions on life skills.', type: ProgramType.selfPaced, isFree: true, category: 'Skills', duration: 'Varies', emoji: '🎬', colorHex: '#173883', popularity: 87),
  Program(id: 'S002', name: 'Recorded Lessons', description: 'Learn at your own pace with structured modules.', type: ProgramType.selfPaced, isFree: true, category: 'Learning', duration: 'Self-paced', emoji: '📹', colorHex: '#4475D7', popularity: 83),
  Program(id: 'S003', name: 'Self-guided Experiences', description: 'Interactive journeys you design yourself.', type: ProgramType.selfPaced, isFree: true, category: 'Personal', duration: 'Flexible', emoji: '🗺️', colorHex: '#F2432C', popularity: 79),

  // Free Webinars
  Program(id: 'W001', name: 'Grow Your Personal Brand', description: 'Live session on building your presence online and offline.', type: ProgramType.webinar, isFree: true, category: 'Career', duration: '30 min', emoji: '🌐', colorHex: '#173883', popularity: 85),
  Program(id: 'W002', name: 'Discovering Your Strengths', description: 'Interactive webinar on strength identification.', type: ProgramType.webinar, isFree: true, category: 'Self', duration: '30 min', emoji: '⚡', colorHex: '#4475D7', popularity: 82),
  Program(id: 'W003', name: 'Disconnecting for Better Reconnection', description: 'Techniques for digital wellness and deeper focus.', type: ProgramType.webinar, isFree: true, category: 'Wellbeing', duration: '45 min', emoji: '🔕', colorHex: '#27AE60', popularity: 78),

  // Programs
  Program(id: 'PR001', name: 'Career Clarity Bootcamp', description: 'A structured 4-week career direction program.', type: ProgramType.program, isFree: false, price: 4999, category: 'Career', duration: '4 weeks', emoji: '🚀', colorHex: '#F2432C', popularity: 90, targetConfiScore: 65),
  Program(id: 'PR002', name: 'Confidence Unlocked', description: 'Build deep, lasting self-confidence from the inside out.', type: ProgramType.program, isFree: false, price: 3499, category: 'Confidence', duration: '3 weeks', emoji: '💪', colorHex: '#173883', popularity: 88, targetConfiScore: 62),
  Program(id: 'PR003', name: 'Emotional Intelligence Masterclass', description: 'Understand and manage yourself and others better.', type: ProgramType.program, isFree: true, category: 'Social', duration: '2 weeks', emoji: '🤍', colorHex: '#4475D7', popularity: 85),

  // 1-1 Sessions
  Program(id: 'O001', name: 'Career Guidance', description: '1-to-1 session with a career mentor.', type: ProgramType.oneToOne, isFree: false, price: 1499, category: 'Career', duration: '45 min', emoji: '🎯', colorHex: '#F2432C', popularity: 82),
  Program(id: 'O002', name: 'Mentoring Session', description: 'Personal growth conversation with an experienced mentor.', type: ProgramType.oneToOne, isFree: false, price: 999, category: 'Self', duration: '30 min', emoji: '🤝', colorHex: '#173883', popularity: 80),
  Program(id: 'O003', name: 'Coaching Call', description: 'Targeted coaching for your specific challenge.', type: ProgramType.oneToOne, isFree: false, price: 1999, category: 'Personal', duration: '60 min', emoji: '📞', colorHex: '#4475D7', popularity: 78),

  // Mentorship
  Program(id: 'M001', name: 'Personal Growth Mentorship', description: 'Description to understand personal growth.', type: ProgramType.mentorship, isFree: false, price: 7999, category: 'Self', duration: '8 weeks', emoji: '🌱', colorHex: '#173883', popularity: 84),
  Program(id: 'M002', name: 'Career Development Mentorship', description: 'Career description and growth developments.', type: ProgramType.mentorship, isFree: false, price: 9999, category: 'Career', duration: '10 weeks', emoji: '📈', colorHex: '#4475D7', popularity: 81),
  Program(id: 'M003', name: 'Leadership Mentorship', description: 'Local description and growth developments.', type: ProgramType.mentorship, isFree: false, price: 12999, category: 'Leadership', duration: '12 weeks', emoji: '👑', colorHex: '#F2432C', popularity: 79),

  // Advanced
  Program(id: 'ADV001', name: 'Advanced Leadership', description: 'Description and leadership to entrepreneurship.', type: ProgramType.advanced, isFree: false, price: 14999, category: 'Leadership', duration: '6 weeks', emoji: '🏆', colorHex: '#173883', popularity: 77),
  Program(id: 'ADV002', name: 'Innovative Entrepreneurship', description: 'Innovative enroute and entrepreneurship.', type: ProgramType.advanced, isFree: false, price: 19999, category: 'Business', duration: '8 weeks', emoji: '🚀', colorHex: '#F2432C', popularity: 75),
  Program(id: 'ADV003', name: 'Emotional Resilience', description: 'Emotional enroute and emotional resilience.', type: ProgramType.advanced, isFree: false, price: 8999, category: 'Wellbeing', duration: '4 weeks', emoji: '💎', colorHex: '#4475D7', popularity: 73),
];

List<Program> getProgramsByType(ProgramType type) {
  return allPrograms.where((p) => p.type == type).toList();
}

List<Program> getFeaturedPrograms(ProgramType type, {int limit = 3}) {
  final programs = getProgramsByType(type);
  programs.sort((a, b) => b.popularity.compareTo(a.popularity));
  return programs.take(limit).toList();
}
