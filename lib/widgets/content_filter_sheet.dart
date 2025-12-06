import 'package:flutter/material.dart';
import '../services/content_filter_service.dart';
import '../constants/app_colors.dart';

/// Bottom sheet for content filtering
class ContentFilterBottomSheet extends StatefulWidget {
  final ContentFilter initialFilter;
  final Function(ContentFilter) onApply;

  const ContentFilterBottomSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  @override
  State<ContentFilterBottomSheet> createState() =>
      _ContentFilterBottomSheetState();

  static Future<void> show(
    BuildContext context, {
    required ContentFilter initialFilter,
    required Function(ContentFilter) onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ContentFilterBottomSheet(
        initialFilter: initialFilter,
        onApply: onApply,
      ),
    );
  }
}

class _ContentFilterBottomSheetState extends State<ContentFilterBottomSheet> {
  late ContentFilter _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(),

          // Filters
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildMediaTypeFilter(),
                const SizedBox(height: 24),
                _buildGenreFilter(),
                const SizedBox(height: 24),
                _buildYearFilter(),
                const SizedBox(height: 24),
                _buildRatingFilter(),
                const SizedBox(height: 24),
                _buildSortOptions(),
              ],
            ),
          ),

          // Apply Button
          _buildApplyButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.textSecondary.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Filters',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              if (_filter.hasActiveFilters)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _filter = _filter.clear();
                    });
                  },
                  child: const Text(
                    'Clear All',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMediaTypeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Type',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFilterChip(
                label: 'All',
                isSelected: _filter.mediaType == null,
                onTap: () {
                  setState(() {
                    _filter = _filter.copyWith(mediaType: null);
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFilterChip(
                label: 'Movies',
                isSelected: _filter.mediaType == 'movie',
                onTap: () {
                  setState(() {
                    _filter = _filter.copyWith(mediaType: 'movie');
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFilterChip(
                label: 'TV Shows',
                isSelected: _filter.mediaType == 'tv',
                onTap: () {
                  setState(() {
                    _filter = _filter.copyWith(mediaType: 'tv');
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenreFilter() {
    final genres = GenreIds.getGenreNames(_filter.mediaType ?? 'movie');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Genres',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: genres.map((genre) {
            final genreId = GenreIds.getGenreId(
              genre,
              _filter.mediaType ?? 'movie',
            );
            final isSelected = _filter.genres.contains(genreId.toString());

            return _buildFilterChip(
              label: genre,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  final genres = List<String>.from(_filter.genres);
                  if (isSelected) {
                    genres.remove(genreId.toString());
                  } else {
                    genres.add(genreId.toString());
                  }
                  _filter = _filter.copyWith(genres: genres);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildYearFilter() {
    final currentYear = DateTime.now().year;
    final years = List.generate(30, (i) => currentYear - i);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Release Year',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: years.take(10).map((year) {
            final isSelected = _filter.years.contains(year);

            return _buildFilterChip(
              label: year.toString(),
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  final years = List<int>.from(_filter.years);
                  if (isSelected) {
                    years.remove(year);
                  } else {
                    years.add(year);
                  }
                  _filter = _filter.copyWith(years: years);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRatingFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Minimum Rating',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _filter.minRating?.toStringAsFixed(1) ?? 'Any',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Slider(
          value: _filter.minRating ?? 0,
          min: 0,
          max: 10,
          divisions: 20,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.textSecondary.withValues(alpha: 0.3),
          onChanged: (value) {
            setState(() {
              _filter = _filter.copyWith(minRating: value == 0 ? null : value);
            });
          },
        ),
      ],
    );
  }

  Widget _buildSortOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sort By',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...SortOption.values.map((option) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: _filter.sortBy == option
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _filter.sortBy == option
                    ? AppColors.primary
                    : Colors.transparent,
              ),
            ),
            child: ListTile(
              leading: Icon(
                option.icon,
                color: _filter.sortBy == option
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
              title: Text(
                option.label,
                style: TextStyle(
                  color: _filter.sortBy == option
                      ? AppColors.primary
                      : AppColors.textPrimary,
                  fontWeight: _filter.sortBy == option
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              trailing: _filter.sortBy == option
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                setState(() {
                  _filter = _filter.copyWith(sortBy: option);
                });
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.textSecondary.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.textSecondary.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            widget.onApply(_filter);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Apply Filters${_filter.hasActiveFilters ? ' (${_filter.activeFilterCount})' : ''}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
