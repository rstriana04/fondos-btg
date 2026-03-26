import 'package:flutter/material.dart';
import 'package:fondos_btg/core/theme/app_colors.dart';

class TransactionFilters extends StatelessWidget {
  final String searchQuery;
  final String? selectedType;
  final String? selectedCategory;
  final String? selectedNotification;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onNotificationChanged;

  const TransactionFilters({
    super.key,
    required this.searchQuery,
    required this.selectedType,
    required this.selectedCategory,
    required this.selectedNotification,
    required this.onSearchChanged,
    required this.onTypeChanged,
    required this.onCategoryChanged,
    required this.onNotificationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search field
          TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Buscar por nombre de fondo...',
              hintStyle: const TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
              prefixIcon: const Icon(
                Icons.search,
                size: 20,
                color: AppColors.textSecondary,
              ),
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: AppColors.blueAccent, width: 2),
              ),
              isDense: true,
            ),
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 10),

          // Filter chips row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChipGroup(
                  label: 'Tipo',
                  selected: selectedType,
                  options: const {
                    null: 'Todos',
                    'subscription': 'Suscripcion',
                    'cancellation': 'Cancelacion',
                  },
                  onSelected: onTypeChanged,
                ),
                const SizedBox(width: 8),
                _FilterChipGroup(
                  label: 'Categoria',
                  selected: selectedCategory,
                  options: const {
                    null: 'Todos',
                    'FPV': 'FPV',
                    'FIC': 'FIC',
                  },
                  onSelected: onCategoryChanged,
                ),
                const SizedBox(width: 8),
                _FilterChipGroup(
                  label: 'Notificacion',
                  selected: selectedNotification,
                  options: const {
                    null: 'Todos',
                    'email': 'Email',
                    'sms': 'SMS',
                  },
                  onSelected: onNotificationChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChipGroup extends StatelessWidget {
  final String label;
  final String? selected;
  final Map<String?, String> options;
  final ValueChanged<String?> onSelected;

  const _FilterChipGroup({
    required this.label,
    required this.selected,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String?>(
      onSelected: onSelected,
      offset: const Offset(0, 36),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (_) => options.entries
          .map((e) => PopupMenuItem<String?>(
                value: e.key,
                child: Row(
                  children: [
                    if (selected == e.key)
                      const Icon(Icons.check, size: 16, color: AppColors.blueAccent)
                    else
                      const SizedBox(width: 16),
                    const SizedBox(width: 8),
                    Text(e.value,
                        style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected != null
              ? AppColors.blueAccent.withValues(alpha: 0.08)
              : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                selected != null ? AppColors.blueAccent : AppColors.divider,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selected != null ? options[selected]! : label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected != null
                    ? AppColors.blueAccent
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.expand_more,
              size: 16,
              color: selected != null
                  ? AppColors.blueAccent
                  : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
