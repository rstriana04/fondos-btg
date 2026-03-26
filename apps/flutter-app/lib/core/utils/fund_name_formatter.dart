abstract final class FundNameFormatter {
  /// Converts a raw fund name to title case with spaces.
  /// Example: "FPV_BTG_PACTUAL_RECAUDADORA" -> "FPV BTG Pactual Recaudadora"
  static String format(String rawName) {
    final parts = rawName.split('_');
    if (parts.isEmpty) return rawName;

    return parts.map((part) {
      if (part.isEmpty) return part;
      // Keep short acronyms uppercase (FPV, BTG, FDO, FIC)
      if (_isAcronym(part)) {
        return part.toUpperCase();
      }
      // Title case for regular words
      return '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}';
    }).join(' ');
  }

  /// Replaces hyphens with spaces and applies title case.
  /// Example: "FDO-ACCIONES" -> "FDO Acciones"
  static String formatWithHyphens(String rawName) {
    final normalized = rawName.replaceAll('-', '_');
    return format(normalized);
  }

  static bool _isAcronym(String word) {
    const acronyms = {'FPV', 'BTG', 'FDO', 'FIC'};
    return acronyms.contains(word.toUpperCase());
  }
}
