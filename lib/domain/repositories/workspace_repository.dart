import '../entities/workspace.dart';
import '../enums/workspace_type.dart';

abstract class WorkspaceRepository {
  void addWorkspace(Workspace workspace);

  Workspace? getWorkspaceById(int workspaceId);

  List<Workspace> getAllWorkspaces();

  List<Workspace> getWorkspacesByType(WorkspaceType type);

  List<Workspace> getAvailableWorkspaces();

  void updateWorkspace(Workspace workspace);

  void deleteWorkspace(int workspaceId);
}
