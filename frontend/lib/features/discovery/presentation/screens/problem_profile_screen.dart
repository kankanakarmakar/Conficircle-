// lib/features/discovery/presentation/screens/problem_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import '../../domain/entities/concern_prompt_entity.dart';
import '../providers/discovery_provider.dart';
import '../widgets/concern_search.dart';
import '../widgets/selected_concern_chips.dart';
import '../widgets/concern_picker.dart';
import '../widgets/priority_selector.dart';
import '../widgets/consent_notice.dart';
import '../widgets/profile_editor.dart';

class ProblemProfileScreen extends ConsumerStatefulWidget {
  const ProblemProfileScreen({super.key});

  @override
  ConsumerState<ProblemProfileScreen> createState() => _ProblemProfileScreenState();
}

class _ProblemProfileScreenState extends ConsumerState<ProblemProfileScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ConcernPromptEntity> _allConcerns = [];
  final Set<String> _selectedIds = {};
  String _searchQuery = '';
  int _priority = 1;
  bool _consentGiven = true;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(discoveryRepositoryProvider);
      final concerns = await repo.getCuratedConcerns();
      final userProfile = await repo.getUserProblemProfile();

      final activeIds = userProfile
          .where((p) => p['status'] == 'active')
          .map((p) => (p['concernPromptId'] ?? '') as String)
          .where((id) => id.isNotEmpty)
          .toSet();

      if (mounted) {
        setState(() {
          _allConcerns = concerns;
          _selectedIds.addAll(activeIds);
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _toggleConcern(ConcernPromptEntity item) {
    setState(() {
      if (_selectedIds.contains(item.id)) {
        _selectedIds.remove(item.id);
      } else {
        if (_selectedIds.length >= 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You can select up to 5 focus challenges.')),
          );
          return;
        }
        _selectedIds.add(item.id);
      }
    });
  }

  Future<void> _saveProfile() async {
    if (_selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one challenge.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final repo = ref.read(discoveryRepositoryProvider);
      await repo.saveProblemProfile(
        concernPromptIds: _selectedIds.toList(),
        priority: _priority,
        consent: _consentGiven,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Problem profile saved! Personalising your feed...')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _allConcerns.where((c) {
      if (_searchQuery.isEmpty) return true;
      return c.promptText.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    final selectedConcerns = _allConcerns.where((c) => _selectedIds.contains(c.id)).toList();

    return Scaffold(
      backgroundColor: AppColors.softGrey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Personalise Feed',
          style: AppTypography.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.blue,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.coral))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What are you currently facing?',
                    style: AppTypography.headingSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Select up to 5 challenges to help us recommend the most relevant Level 4 questions for you.',
                    style: AppTypography.body(fontSize: 13, color: AppColors.darkGrey),
                  ),

                  const SizedBox(height: 16),

                  // Search bar
                  ConcernSearch(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                  ),

                  const SizedBox(height: 16),

                  // Selected chips
                  SelectedConcernChips(
                    selectedConcerns: selectedConcerns,
                    onRemove: (c) => setState(() => _selectedIds.remove(c.id)),
                  ),

                  if (selectedConcerns.isNotEmpty) const SizedBox(height: 20),

                  // Plain-language concern list
                  Text(
                    'Available Challenges',
                    style: AppTypography.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 10),

                  ConcernPicker(
                    concerns: filtered,
                    selectedIds: _selectedIds,
                    onToggle: _toggleConcern,
                  ),

                  const SizedBox(height: 24),

                  // Priority Selector
                  PrioritySelector(
                    selectedPriority: _priority,
                    onPriorityChanged: (val) => setState(() => _priority = val),
                  ),

                  const SizedBox(height: 20),

                  // Consent Notice
                  ConsentNotice(
                    hasConsented: _consentGiven,
                    onConsentChanged: (val) => setState(() => _consentGiven = val),
                  ),

                  const SizedBox(height: 32),

                  // Save Profile Button
                  ElevatedButton(
                    onPressed: _isSaving ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.coral,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : Text(
                            'Save Focus Challenges',
                            style: AppTypography.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}

