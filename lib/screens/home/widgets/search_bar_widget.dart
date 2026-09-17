// lib/screens/home/widgets/search_bar_widget.dart
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class SearchBarWidget extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;

  const SearchBarWidget({
    super.key,
    this.hintText = 'Search programs, resources...',
    this.onChanged,
    this.onTap,
    this.readOnly = false,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final _ctrl = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.softGrey,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: TextField(
        controller: _ctrl,
        readOnly: widget.readOnly,
        onTap: widget.onTap,
        onChanged: (v) {
          setState(() => _hasText = v.isNotEmpty);
          widget.onChanged?.call(v);
        },
        style: AppTypography.bodyMedium,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkGrey.withOpacity(0.6),
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.blue,
            size: 20,
          ),
          suffixIcon: _hasText
              ? IconButton(
                  icon: const Icon(Icons.close_rounded,
                      size: 18, color: AppColors.darkGrey),
                  onPressed: () {
                    _ctrl.clear();
                    setState(() => _hasText = false);
                    widget.onChanged?.call('');
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

/// A compact search bar used in app bars with a magnifier icon that opens a search overlay
class SearchIconButton extends StatelessWidget {
  const SearchIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search_rounded, color: AppColors.blue),
      onPressed: () => showSearch(
        context: context,
        delegate: _ConfiSearchDelegate(),
      ),
    );
  }
}

class _ConfiSearchDelegate extends SearchDelegate<String> {
  final List<String> _suggestions = [
    'Career Clarity', 'Confidence', 'Communication',
    'Finance basics', 'Wellbeing', 'Leadership',
    'Interview tips', 'Resume builder', 'Study techniques',
  ];

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkGrey.withOpacity(0.6),
        ),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => query = '',
          ),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: AppColors.blue),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text('Search results for "$query"',
              style: AppTypography.headingSmall),
          const SizedBox(height: 8),
          Text('Coming soon — connect to backend',
              style: AppTypography.bodyMedium),
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filtered = query.isEmpty
        ? _suggestions
        : _suggestions
            .where((s) => s.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filtered.length,
      itemBuilder: (_, i) {
        final s = filtered[i];
        return ListTile(
          leading: const Icon(Icons.trending_up_rounded,
              color: AppColors.blue, size: 20),
          title: Text(s, style: AppTypography.bodyLarge),
          trailing: const Icon(Icons.north_west_rounded,
              size: 16, color: AppColors.darkGrey),
          onTap: () {
            query = s;
            showResults(context);
          },
        );
      },
    );
  }
}
