import '../../entities/workspace.dart';
import '../../../data/repositories/workspace_repository_impl.dart';

class GetAllWorkspaces {
  final WorkspaceRepositoryImpl repository;

  GetAllWorkspaces(this.repository);

  List<Workspace> execute() {
    return repository.getAllWorkspaces();
  }
}
