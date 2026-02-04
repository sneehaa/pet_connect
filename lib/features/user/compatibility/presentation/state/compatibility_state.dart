import 'package:pet_connect/features/user/compatibility/domain/entity/compatibility_entity.dart';

enum CompatibilityStatus { initial, loading, loaded, error }

class CompatibilityState {
  final CompatibilityStatus status;
  final CompatibilityEntity? questionnaire;
  final List<CompatibilityResultEntity> compatibilityResults;
  final CompatibilityResultEntity? selectedCompatibility;
  final String? message;
  final bool isLoading;
  final Map<String, dynamic>? pagination;

  const CompatibilityState({
    this.status = CompatibilityStatus.initial,
    this.questionnaire,
    this.compatibilityResults = const [],
    this.selectedCompatibility,
    this.message,
    this.isLoading = false,
    this.pagination,
  });

  bool get hasQuestionnaire => questionnaire != null;
  bool get hasResults => compatibilityResults.isNotEmpty;

  CompatibilityState copyWith({
    CompatibilityStatus? status,
    CompatibilityEntity? questionnaire,
    List<CompatibilityResultEntity>? compatibilityResults,
    CompatibilityResultEntity? selectedCompatibility,
    String? message,
    bool? isLoading,
    Map<String, dynamic>? pagination,
  }) {
    return CompatibilityState(
      status: status ?? this.status,
      questionnaire: questionnaire ?? this.questionnaire,
      compatibilityResults: compatibilityResults ?? this.compatibilityResults,
      selectedCompatibility:
          selectedCompatibility ?? this.selectedCompatibility,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      pagination: pagination ?? this.pagination,
    );
  }
}
