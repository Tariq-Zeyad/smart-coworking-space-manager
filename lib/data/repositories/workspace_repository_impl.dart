import '../../domain/entities/workspace.dart';
import '../../domain/repositories/workspace_repository.dart';
import '../../domain/enums/workspace_type.dart';
import '../data_sources/local/workspace_local_data_source.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  final WorkspaceLocalDataSource dataSource;

  WorkspaceRepositoryImpl({required this.dataSource});

  @override
  void addWorkspace(Workspace workspace) {
    dataSource.addWorkspace(workspace);
  }

  @override
  Workspace? getWorkspaceById(int workspaceId) {
    return dataSource.getWorkspaceById(workspaceId);
  }

  @override
  List<Workspace> getAllWorkspaces() {
    return dataSource.getAllWorkspaces();
  }

  @override
  List<Workspace> getWorkspacesByType(WorkspaceType type) {
    return dataSource.getWorkspacesByType(type);
  }

  @override
  List<Workspace> getAvailableWorkspaces() {
    return dataSource.getAvailableWorkspaces();
  }

  @override
  void updateWorkspace(Workspace workspace) {
    dataSource.updateWorkspace(workspace);
  }

  @override
  void deleteWorkspace(int workspaceId) {
    dataSource.deleteWorkspace(workspaceId);
  }
}
