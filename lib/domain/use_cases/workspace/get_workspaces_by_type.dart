import '../../entities/workspace.dart';
import '../../enums/workspace_type.dart';
import '../../../data/repositories/workspace_repository_impl.dart';

class GetWorkspacesByType {
  final WorkspaceRepositoryImpl repository;

  GetWorkspacesByType(this.repository);

  List<Workspace> execute(WorkspaceType type) {
    return repository.getWorkspacesByType(type);
  }
}
