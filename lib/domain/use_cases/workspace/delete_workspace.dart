import '../../repositories/workspace_repository.dart';
import '../../services/workspace_availability_service.dart';
import '../../../core/errors/app_exceptions.dart';

class DeleteWorkspace {
  final WorkspaceRepository repository;
  final WorkspaceAvailabilityService availabilityService;

  DeleteWorkspace(this.repository, this.availabilityService);

  void execute(int workspaceId) {
    final workspace = repository.getWorkspaceById(workspaceId);

    if (workspace == null) {
      throw const NotFoundException('Workspace not found.');
    }

    if (availabilityService.hasActiveBookings(workspaceId)) {
      throw const ValidationException(
        'Cannot remove a workspace that has active bookings.',
      );
    }

    repository.deleteWorkspace(workspaceId);
  }
}
