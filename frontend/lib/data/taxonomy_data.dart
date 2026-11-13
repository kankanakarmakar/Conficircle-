import 'package:flutter/material.dart';

/// Level 1: Outer capability group (Student-facing: "Browse Areas")
class TaxonomyArea {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
  final List<TaxonomyCategory> categories;

  const TaxonomyArea({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.categories,
  });

  int get totalNodes => categories.fold(0, (sum, cat) => sum + cat.nodes.length);
}

/// Level 2: 16 Core Categories (Student-facing: Category)
class TaxonomyCategory {
  final String id;
  final String title;
  final String description;
  final int chunk; // Internal metadata Chunk (OD-05), not directly highlighted
  final List<TaxonomyNode> nodes;

  const TaxonomyCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.chunk,
    required this.nodes,
  });
}

/// Level 3: 69 Problem/Aspiration Nodes (Student-facing: Focus Topics / Needs)
class TaxonomyNode {
  final String id;
  final String title;
  final String summary;
  final double progress; // 0.0 to 1.0
  final NodeStatus status;
  final List<String> sampleQuestions;

  const TaxonomyNode({
    required this.id,
    required this.title,
    required this.summary,
    this.progress = 0.0,
    this.status = NodeStatus.notStarted,
    this.sampleQuestions = const [],
  });
}

enum NodeStatus {
  notStarted,
  inProgress,
  completed,
}

/// Authoritative taxonomy dataset matching the ConfiCircle Blueprint
class TaxonomyData {
  static const List<TaxonomyArea> areas = [
    // 1. MY FUTURE
    TaxonomyArea(
      id: 'my_future',
      title: 'MY FUTURE',
      description: 'Career clarity, academics, financial growth & entrepreneurship',
      icon: Icons.rocket_launch_outlined,
      accentColor: Color(0xFF173883),
      categories: [
        TaxonomyCategory(
          id: 'career_clarity',
          title: 'Career Clarity',
          description: 'Define your trajectory, job opportunities, higher studies and research',
          chunk: 1,
          nodes: [
            TaxonomyNode(
              id: 'future_career',
              title: 'Career',
              summary: 'Explore roles, industries, and long-term career roadmaps.',
              progress: 0.65,
              status: NodeStatus.inProgress,
              sampleQuestions: ['What careers align with my natural strengths?'],
            ),
            TaxonomyNode(
              id: 'future_job',
              title: 'Job',
              summary: 'Practical tactics for job search, applications, and placement preparation.',
              progress: 0.0,
              status: NodeStatus.notStarted,
              sampleQuestions: ['How do I crack off-campus interviews?'],
            ),
            TaxonomyNode(
              id: 'future_higher_studies',
              title: 'Higher Studies',
              summary: 'Master programs, admissions tests, exams, and scholarship strategies.',
              progress: 1.0,
              status: NodeStatus.completed,
              sampleQuestions: ['Should I pursue an MBA or MS right after graduation?'],
            ),
            TaxonomyNode(
              id: 'future_research',
              title: 'Research',
              summary: 'Academic writing, lab fellowships, journals, and thesis guidance.',
              progress: 0.0,
              status: NodeStatus.notStarted,
              sampleQuestions: ['How to publish research papers as an undergraduate?'],
            ),
          ],
        ),
        TaxonomyCategory(
          id: 'academic_success',
          title: 'Academic Success',
          description: 'Exam performance, effective study habits, and academic consistency',
          chunk: 3,
          nodes: [
            TaxonomyNode(
              id: 'future_academic_performance',
              title: 'Academic Performance',
              summary: 'Maintain high GPA and excel during semester examinations.',
              progress: 0.40,
              status: NodeStatus.inProgress,
            ),
            TaxonomyNode(
              id: 'future_study_effectiveness',
              title: 'Study Effectiveness',
              summary: 'Active recall, spaced repetition, and deep concept retention.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'future_home_study',
              title: 'Home Study',
              summary: 'Environment setup, distraction removal, and self-study systems.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'future_learning_preparation',
              title: 'Learning & Preparation',
              summary: 'Syllabus breakdown, fast revisions, and mock test routines.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'future_academic_consistency',
              title: 'Academic Consistency',
              summary: 'Build steady study habits without end-of-term cramming panic.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
          ],
        ),
        TaxonomyCategory(
          id: 'money_financial_growth',
          title: 'Money & Financial Growth',
          description: 'Financial independence, wealth awareness, and smart budgeting',
          chunk: 1,
          nodes: [
            TaxonomyNode(
              id: 'future_financial_independence',
              title: 'Financial Independence',
              summary: 'Pathways to earning early, freelance skills, and student income.',
              progress: 0.20,
              status: NodeStatus.inProgress,
            ),
            TaxonomyNode(
              id: 'future_financial_awareness',
              title: 'Financial Awareness',
              summary: 'Demystifying banking, credit, compound interest, and taxes.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'future_wealth_creation',
              title: 'Wealth Creation',
              summary: 'Long-term investment philosophies, compounding, and assets.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'future_money_management',
              title: 'Money Management & Investing',
              summary: 'Student budgeting, index funds, SIPs, and disciplined spending.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
          ],
        ),
        TaxonomyCategory(
          id: 'entrepreneurship',
          title: 'Entrepreneurship',
          description: 'Identify opportunities, take calculated risks, and launch ventures',
          chunk: 4,
          nodes: [
            TaxonomyNode(
              id: 'future_entrepreneurship_core',
              title: 'Entrepreneurship',
              summary: 'Foundational mindsets of builders, problem-finders, and creators.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'future_opportunity_recognition',
              title: 'Opportunity Recognition',
              summary: 'Spot market pain-points, unmet needs, and emerging technologies.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'future_risk_orientation',
              title: 'Risk Orientation',
              summary: 'Managing downside risk, emotional resilience in ambiguity.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'future_startup_creation',
              title: 'Startup Creation',
              summary: 'MVP validation, finding co-founders, pitching, and initial traction.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
          ],
        ),
      ],
    ),

    // 2. MY SKILLS
    TaxonomyArea(
      id: 'my_skills',
      title: 'MY SKILLS',
      description: 'Communication, personal effectiveness, discipline & creative thinking',
      icon: Icons.psychology_outlined,
      accentColor: Color(0xFF4475D7),
      categories: [
        TaxonomyCategory(
          id: 'communication_expression',
          title: 'Communication & Expression',
          description: 'Articulate ideas clearly in speaking, writing, presentations and dialogue',
          chunk: 2,
          nodes: [
            TaxonomyNode(
              id: 'skills_comm_styles',
              title: 'Communication Skills & Styles',
              summary: 'Adapting tone, framing messages, and active interpersonal dialogue.',
              progress: 0.80,
              status: NodeStatus.inProgress,
            ),
            TaxonomyNode(
              id: 'skills_writing',
              title: 'Writing Skill',
              summary: 'Crisp professional emails, reports, documentation, and storytelling.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'skills_listening',
              title: 'Listening Skill',
              summary: 'Active empathetic listening and asking powerful questions.',
              progress: 1.0,
              status: NodeStatus.completed,
            ),
            TaxonomyNode(
              id: 'skills_presentation',
              title: 'Presentation Skill',
              summary: 'Slide architecture, stage presence, pacing, and captivating an audience.',
              progress: 0.30,
              status: NodeStatus.inProgress,
            ),
            TaxonomyNode(
              id: 'skills_assertiveness',
              title: 'Assertiveness',
              summary: 'Saying no respectfully, setting healthy boundaries, advocating for yourself.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
          ],
        ),
        TaxonomyCategory(
          id: 'personal_effectiveness',
          title: 'Personal Effectiveness',
          description: 'Master time, sharpen focus, make sound decisions and build habits',
          chunk: 2,
          nodes: [
            TaxonomyNode(
              id: 'skills_time_management',
              title: 'Time Management',
              summary: 'Priority matrices, calendar blocking, and realistic weekly planning.',
              progress: 0.50,
              status: NodeStatus.inProgress,
            ),
            TaxonomyNode(
              id: 'skills_improving_focus',
              title: 'Improving Focus',
              summary: 'Pomodoro cycles, deep work blocks, and digital distraction defense.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'skills_decision_making',
              title: 'Decision Making',
              summary: 'Mental models, first-principles thinking, and overcoming choice paralysis.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'skills_consistency_discipline',
              title: 'Consistency & Discipline',
              summary: 'Staying the course when motivation fades; identity-based habit loops.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'skills_habits_action',
              title: 'Habits & Action',
              summary: 'Friction reduction, atomic habit design, and 2-minute starter rules.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
          ],
        ),
        TaxonomyCategory(
          id: 'creativity_innovation',
          title: 'Creativity & Innovation',
          description: 'Problem-solving, lateral thinking, imagination and original thought',
          chunk: 3,
          nodes: [
            TaxonomyNode(
              id: 'skills_creativity_core',
              title: 'Creativity',
              summary: 'Cross-pollinating diverse domains and unblocking artistic spark.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'skills_problem_solving',
              title: 'Problem Solving',
              summary: 'Root-cause analysis, 5-whys framework, and structured troubleshooting.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'skills_imagination',
              title: 'Imagination',
              summary: 'Visionary thinking, future scenario forecasting, and mental play.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'skills_thinking_styles',
              title: 'Thinking Styles',
              summary: 'Divergent vs convergent thought; systems thinking vs analytical reasoning.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'skills_innovation',
              title: 'Innovation',
              summary: 'Translating raw creative insights into practical, scalable solutions.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
          ],
        ),
      ],
    ),

    // 3. BUILD STRONGER ME
    TaxonomyArea(
      id: 'build_stronger_me',
      title: 'BUILD STRONGER ME',
      description: 'Confidence, self-worth, emotional resilience & self-transformation',
      icon: Icons.self_improvement_outlined,
      accentColor: Color(0xFFF2432C),
      categories: [
        TaxonomyCategory(
          id: 'confidence_self_worth',
          title: 'Confidence & Self-Worth',
          description: 'Cultivate unshakeable self-belief, conquer fear and respect yourself',
          chunk: 1,
          nodes: [
            TaxonomyNode(
              id: 'me_improving_confidence',
              title: 'Improving Confidence',
              summary: 'Overcoming imposter syndrome and building real evidence of competence.',
              progress: 0.70,
              status: NodeStatus.inProgress,
            ),
            TaxonomyNode(
              id: 'me_improving_self_respect',
              title: 'Improving Self-Respect',
              summary: 'Honoring commitments to yourself and standing by your convictions.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'me_improving_self_esteem',
              title: 'Improving Self-Esteem',
              summary: 'Silencing the harsh inner critic; unconditional intrinsic self-acceptance.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'me_overcoming_fear',
              title: 'Overcoming Fear',
              summary: 'Deconstructing fear of failure, fear of judgment, and social anxiety.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
          ],
        ),
        TaxonomyCategory(
          id: 'emotional_wellbeing',
          title: 'Emotional Wellbeing',
          description: 'Emotional maturity, resilience through setbacks and inner peace',
          chunk: 1,
          nodes: [
            TaxonomyNode(
              id: 'me_emotional_resilience',
              title: 'Emotional Resilience',
              summary: 'Bouncing back stronger from rejection, academic setbacks, and disappointment.',
              progress: 0.25,
              status: NodeStatus.inProgress,
            ),
            TaxonomyNode(
              id: 'me_emotional_maturity',
              title: 'Emotional Maturity',
              summary: 'Processing strong feelings calmly; responding thoughtfully rather than reacting.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'me_emotional_wellbeing_core',
              title: 'Emotional Wellbeing',
              summary: 'Daily mental hygiene, positive psychology practices, and emotional balance.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'me_inner_peace',
              title: 'Inner Peace / Peace in Life',
              summary: 'Cultivating mindfulness, contentment, and gratitude in a bustling college life.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
          ],
        ),
        TaxonomyCategory(
          id: 'inner_balance',
          title: 'Inner Balance',
          description: 'Manage expectations, dissolve stress and understand your true strengths',
          chunk: 3,
          nodes: [
            TaxonomyNode(
              id: 'me_managing_expectations',
              title: 'Managing Expectations',
              summary: 'Navigating family pressure, peer comparisons, and self-imposed standards.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'me_managing_stress',
              title: 'Managing Stress',
              summary: 'Somatic grounding techniques, breathwork, sleep optimization, and recovery.',
              progress: 0.50,
              status: NodeStatus.inProgress,
            ),
            TaxonomyNode(
              id: 'me_self_awareness',
              title: 'Self-Awareness of Strengths & Weaknesses',
              summary: 'Objective audit of capabilities, shadow traits, and authentic growth edges.',
              progress: 1.0,
              status: NodeStatus.completed,
            ),
          ],
        ),
        TaxonomyCategory(
          id: 'growth_transformation',
          title: 'Growth & Transformation',
          description: 'Accelerate your evolution and translate potential into tangible results',
          chunk: 4,
          nodes: [
            TaxonomyNode(
              id: 'me_growth_faster',
              title: 'Growth - How Can I Grow Faster?',
              summary: 'High-leverage compounding activities, mentorship access, and rapid feedback.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'me_transform_potential',
              title: 'Transformation - Potential into Results',
              summary: 'Bridge the gap between intention and execution; milestone accountability.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
          ],
        ),
      ],
    ),

    // 4. MY PEOPLE & IMPACT
    TaxonomyArea(
      id: 'my_people_impact',
      title: 'MY PEOPLE & IMPACT',
      description: 'Meaningful relationships, ethical leadership, purpose & community impact',
      icon: Icons.people_outline_rounded,
      accentColor: Color(0xFF173883),
      categories: [
        TaxonomyCategory(
          id: 'relationships_social_skills',
          title: 'Relationships & Social Skills',
          description: 'Cultivate deep friendships, handle peer dynamics and resolve conflicts',
          chunk: 2,
          nodes: [
            TaxonomyNode(
              id: 'people_friendships',
              title: 'Meaningful Friendships',
              summary: 'Forming genuine peer bonds and choosing circles that uplift your growth.',
              progress: 0.35,
              status: NodeStatus.inProgress,
            ),
            TaxonomyNode(
              id: 'people_peer_pressure',
              title: 'Handling Peer Pressure', // Flag OD-04 editorial spelling fix
              summary: 'Standing tall in personal values without becoming socially alienated.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'people_conflict_resolution',
              title: 'Resolving Conflicts',
              summary: 'Principled de-escalation, non-violent communication, and finding common ground.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'people_networking',
              title: 'Networking with Purpose',
              summary: 'Connecting with alumni, professors, and industry mentors authentically.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
          ],
        ),
        TaxonomyCategory(
          id: 'leadership_influence',
          title: 'Leadership & Influence',
          description: 'Inspire teams, communicate vision, and steer collaborative student initiatives',
          chunk: 3,
          nodes: [
            TaxonomyNode(
              id: 'people_inspiring_others',
              title: 'Inspiring Others',
              summary: 'Leading by example, vulnerability in leadership, and rallying peer groups.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'people_teamwork',
              title: 'Teamwork & Collaboration',
              summary: 'Delegation, psychological safety, and collective problem solving in teams.',
              progress: 0.60,
              status: NodeStatus.inProgress,
            ),
            TaxonomyNode(
              id: 'people_initiative',
              title: 'Taking Initiative',
              summary: 'Stepping up when uncertainty arises; creating clubs, chapters, and events.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
          ],
        ),
        TaxonomyCategory(
          id: 'purpose_values',
          title: 'Purpose & Values',
          description: 'Clarify core principles, personal mission, and long-term ethical compass',
          chunk: 1,
          nodes: [
            TaxonomyNode(
              id: 'people_finding_purpose',
              title: 'Finding Personal Purpose',
              summary: 'Aligning your skills and passions with genuine needs in the world.',
              progress: 0.15,
              status: NodeStatus.inProgress,
            ),
            TaxonomyNode(
              id: 'people_living_values',
              title: 'Living Your Values',
              summary: 'Integrity under pressure; maintaining moral consistency through college.', // Flag OD-03 editorial spelling fix
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'people_longterm_vision',
              title: 'Long-Term Vision',
              summary: 'Decade-scale thinking and resisting short-term instant gratification.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
          ],
        ),
        TaxonomyCategory(
          id: 'community_contribution',
          title: 'Community & Contribution',
          description: 'Give back through mentorship, volunteering, and positive campus impact',
          chunk: 4,
          nodes: [
            TaxonomyNode(
              id: 'people_mentorship',
              title: 'Peer Mentorship',
              summary: 'Guiding junior students and learning deeply through teaching.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
            TaxonomyNode(
              id: 'people_giving_back',
              title: 'Community Impact & Volunteering',
              summary: 'Organizing impactful social causes and making difference on ground.',
              progress: 0.0,
              status: NodeStatus.notStarted,
            ),
          ],
        ),
      ],
    ),
  ];
}
