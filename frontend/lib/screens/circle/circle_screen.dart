// lib/screens/circle/circle_screen.dart
import 'package:flutter/material.dart';
import '../../data/mock_groups.dart';
import '../../models/group.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'create_group_screen.dart';
import 'widgets/student_profile_card.dart';

class CircleScreen extends StatefulWidget {
  const CircleScreen({super.key});

  @override
  State<CircleScreen> createState() => _CircleScreenState();
}

class _CircleScreenState extends State<CircleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Discover', 'My Circles', 'Students'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGrey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Circle', style: AppTypography.headingSmall),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.blue),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateGroupScreen()),
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelStyle: AppTypography.montserrat(fontSize: 13, fontWeight: FontWeight.w700),
          unselectedLabelStyle: AppTypography.montserrat(fontSize: 13, fontWeight: FontWeight.w500),
          labelColor: AppColors.coral,
          unselectedLabelColor: AppColors.darkGrey,
          indicatorColor: AppColors.coral,
          indicatorWeight: 3,
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _DiscoverTab(),
          _MyCirclesTab(),
          _StudentsTab(),
        ],
      ),
    );
  }

}


class _DiscoverTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: publicGroups.length,
      itemBuilder: (_, i) => _GroupCard(group: publicGroups[i]),
    );
  }
}

class _MyCirclesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('👥', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text('No circles yet', style: AppTypography.headingSmall),
          const SizedBox(height: 8),
          Text('Join a public group or create a private one.',
              style: AppTypography.bodyMedium, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Browse Groups'),
          ),
        ],
      ),
    );
  }
}

class _StudentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: sampleStudents.length,
      itemBuilder: (_, i) => StudentProfileCard(student: sampleStudents[i]),
    );
  }
}

class _GroupCard extends StatefulWidget {
  final Group group;
  const _GroupCard({required this.group});

  @override
  State<_GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<_GroupCard> {
  bool _joined = false;

  @override
  Widget build(BuildContext context) {
    final g = widget.group;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(child: Text(g.emoji, style: const TextStyle(fontSize: 24))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(g.name, style: AppTypography.labelLarge),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: g.type == GroupType.public
                                ? AppColors.blue.withOpacity(0.1)
                                : AppColors.coral.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            g.type == GroupType.public ? '🌐 Public' : '🔒 Private',
                            style: AppTypography.montserrat(
                              fontSize: 9, fontWeight: FontWeight.w700,
                              color: g.type == GroupType.public ? AppColors.blue : AppColors.coral,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text('${g.memberCount.toString()} members',
                        style: AppTypography.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(g.description, style: AppTypography.bodyMedium, maxLines: 2),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            children: g.tags.map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.softGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('#$t',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.blue)),
            )).toList(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: _joined
                ? OutlinedButton(
                    onPressed: () => setState(() => _joined = false),
                    child: const Text('Joined ✓'),
                  )
                : ElevatedButton(
                    onPressed: () => setState(() => _joined = true),
                    child: const Text('Join Circle'),
                  ),
          ),
        ],
      ),
    );
  }
}

class _CreateGroupSheet extends StatefulWidget {
  const _CreateGroupSheet();

  @override
  State<_CreateGroupSheet> createState() => _CreateGroupSheetState();
}

class _CreateGroupSheetState extends State<_CreateGroupSheet> {
  final _nameCtrl = TextEditingController();
  bool _isPublic = true;
  String _selectedCategory = 'Career';
  final List<String> _categories = ['Career', 'Self', 'Finance', 'Communication', 'Wellbeing', 'Leadership'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Create a Circle', style: AppTypography.headingSmall),
          const SizedBox(height: 20),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(hintText: 'Circle name...'),
          ),
          const SizedBox(height: 14),
          // Public/Private toggle
          Row(
            children: [
              _TypeButton(label: '🌐 Public', active: _isPublic, onTap: () => setState(() => _isPublic = true)),
              const SizedBox(width: 10),
              _TypeButton(label: '🔒 Private', active: !_isPublic, onTap: () => setState(() => _isPublic = false)),
            ],
          ),
          const SizedBox(height: 14),
          // Category dropdown
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(),
            items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) => setState(() => _selectedCategory = v!),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Create Circle'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _TypeButton({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.blue : AppColors.softGrey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: active ? AppColors.blue : AppColors.lightGrey),
        ),
        child: Text(label,
            style: AppTypography.montserrat(
              fontSize: 13, fontWeight: FontWeight.w600,
              color: active ? AppColors.white : AppColors.darkGrey,
            )),
      ),
    );
  }
}
