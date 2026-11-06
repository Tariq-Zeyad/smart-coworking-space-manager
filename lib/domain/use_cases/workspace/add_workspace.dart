import '../../entities/workspace.dart';
import '../../../data/repositories/workspace_repository_impl.dart';
import '../../../core/errors/app_exceptions.dart';

class AddWorkspace {
  final WorkspaceRepositoryImpl repository;

  AddWorkspace(this.repository);

  void execute(Workspace workspace) {
    final existingWorkspace = repository.getWorkspaceById(
      workspace.workspaceId,
    );

    if (existingWorkspace != null) {
      throw const ValidationException('Workspace ID already exists.');
    }

    repository.addWorkspace(workspace);
  }
}
