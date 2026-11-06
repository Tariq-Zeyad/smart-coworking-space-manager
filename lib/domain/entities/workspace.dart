import '../../core/errors/app_exceptions.dart';
import '../enums/workspace_type.dart';

class Workspace {
  final int workspaceId;
  final String name;
  final WorkspaceType type;
  final double hourlyRate;

  bool _isAvailable;

  Workspace({
    required this.workspaceId,
    required String name,
    required this.type,
    required this.hourlyRate,
    bool isAvailable = true,
  }) : name = name.trim(),
       _isAvailable = isAvailable {
    if (workspaceId <= 0) {
      throw const ValidationException('Workspace ID must be positive');
    }

    if (this.name.isEmpty) {
      throw const ValidationException('Workspace name cannot be empty');
    }

    if (!hourlyRate.isFinite || hourlyRate <= 0) {
      throw const ValidationException('Hourly rate must be greater than zero');
    }
  }

  bool get isAvailable => _isAvailable;

  void markAsAvailable() {
    _isAvailable = true;
  }

  void markAsUnavailable() {
    _isAvailable = false;
  }
}
