import '../../../domain/entities/workspace.dart';
import '../../../domain/enums/workspace_type.dart';

class WorkspaceLocalDataSource {
  final Map<int, Workspace> _workspaces = {};

  void addWorkspace(Workspace workspace) {
    _workspaces[workspace.workspaceId] = workspace;
  }

  Workspace? getWorkspaceById(int workspaceId) {
    return _workspaces[workspaceId];
  }

  List<Workspace> getAllWorkspaces() {
    return _workspaces.values.toList();
  }

  List<Workspace> getWorkspacesByType(WorkspaceType type) {
    return _workspaces.values
        .where((workspace) => workspace.type == type)
        .toList();
  }

  List<Workspace> getAvailableWorkspaces() {
    return _workspaces.values
        .where((workspace) => workspace.isAvailable)
        .toList();
  }

  void updateWorkspace(Workspace workspace) {
    if (_workspaces.containsKey(workspace.workspaceId)) {
      _workspaces[workspace.workspaceId] = workspace;
    }
  }

  void deleteWorkspace(int workspaceId) {
    _workspaces.remove(workspaceId);
  }
}
