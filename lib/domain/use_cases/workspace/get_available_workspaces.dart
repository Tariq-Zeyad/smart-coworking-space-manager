import '../../entities/workspace.dart';
import '../../../data/repositories/workspace_repository_impl.dart';

class GetAvailableWorkspaces {
  final WorkspaceRepositoryImpl repository;

  GetAvailableWorkspaces(this.repository);

  List<Workspace> execute() {
    return repository.getAvailableWorkspaces();
  }
}
