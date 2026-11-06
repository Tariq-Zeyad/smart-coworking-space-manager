import '../../entities/workspace.dart';
import '../../../data/repositories/workspace_repository_impl.dart';

class GetWorkspaceById {
  final WorkspaceRepositoryImpl repository;

  GetWorkspaceById(this.repository);

  Workspace? execute(int workspaceId) {
    return repository.getWorkspaceById(workspaceId);
  }
}
