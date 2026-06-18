import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../app_state.dart';
import '../../backend/api_requests/api_manager.dart';
import 'home_page_model.dart';

export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  @override
  void initState() {
    super.initState();
    _model = HomePageModel()..initState(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTodos());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadTodos() async {
    final token = context.read<FFAppState>().authToken;
    setState(() => _model.isLoading = true);
    final response = await ListTodosCall.call(token: token);
    if (!mounted) return;
    setState(() {
      _model.isLoading = false;
      if (response.succeeded) {
        _model.todos = ListTodosCall.todos(response);
        _model.errorMessage = null;
      } else {
        _model.errorMessage = response.errorMessage ?? 'Failed to load todos';
      }
    });
  }

  Future<void> _toggleTodo(int id) async {
    final token = context.read<FFAppState>().authToken;
    await ToggleTodoCall.call(token: token, id: id);
    _loadTodos();
  }

  Future<void> _deleteTodo(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Todo'),
        content: const Text('Are you sure you want to delete this todo?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete',
                  style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm != true) return;
    final token = context.read<FFAppState>().authToken;
    await DeleteTodoCall.call(token: token, id: id);
    _loadTodos();
  }

  void _logout() {
    context.read<FFAppState>().update(() {
      context.read<FFAppState>().clearAuth();
    });
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final appState = context.watch<FFAppState>();
    final todos = _model.filteredTodos;

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Todos', style: theme.headlineSmall),
            Text(appState.currentUserEmail,
                style: theme.labelSmall.copyWith(color: theme.secondaryText)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: theme.primaryText),
            onPressed: _loadTodos,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: Icon(Icons.logout, color: theme.primaryText),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter tabs
          Container(
            color: theme.secondaryBackground,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status filter
                Row(
                  children: [
                    _filterChip('All', 'all', theme),
                    const SizedBox(width: 8),
                    _filterChip('Active', 'active', theme),
                    const SizedBox(width: 8),
                    _filterChip('Done', 'completed', theme),
                  ],
                ),
                const SizedBox(height: 8),
                // Priority filter
                Row(
                  children: [
                    Text('Priority: ',
                        style: theme.labelSmall
                            .copyWith(color: theme.secondaryText)),
                    _priorityChip(null, 'All', theme),
                    const SizedBox(width: 6),
                    _priorityChip('high', 'High', theme),
                    const SizedBox(width: 6),
                    _priorityChip('medium', 'Med', theme),
                    const SizedBox(width: 6),
                    _priorityChip('low', 'Low', theme),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _model.isLoading
                ? Center(
                    child: CircularProgressIndicator(color: theme.primary))
                : _model.errorMessage != null
                    ? _buildError(theme)
                    : todos.isEmpty
                        ? _buildEmpty(theme)
                        : RefreshIndicator(
                            onRefresh: _loadTodos,
                            child: ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: todos.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, i) =>
                                  _buildTodoCard(todos[i], theme),
                            ),
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/create-todo');
          _loadTodos();
        },
        backgroundColor: theme.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('New Todo',
            style: theme.labelMedium.copyWith(color: Colors.white)),
      ),
    );
  }

  Widget _filterChip(String label, String value, FlutterFlowTheme theme) {
    final selected = _model.filterStatus == value;
    return GestureDetector(
      onTap: () => setState(() => _model.filterStatus = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? theme.primary : theme.alternate,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: theme.labelSmall.copyWith(
              color: selected ? Colors.white : theme.secondaryText,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _priorityChip(
      String? value, String label, FlutterFlowTheme theme) {
    final selected = _model.filterPriority == value;
    return GestureDetector(
      onTap: () => setState(() => _model.filterPriority = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? theme.secondary : theme.alternate,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: theme.labelSmall.copyWith(
              color: selected ? Colors.white : theme.secondaryText,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildTodoCard(dynamic todo, FlutterFlowTheme theme) {
    final id = (todo['id'] as num).toInt();
    final title = todo['title'] as String? ?? '';
    final description = todo['description'] as String? ?? '';
    final completed = todo['completed'] as bool? ?? false;
    final priority = todo['priority'] as String? ?? 'medium';

    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: GestureDetector(
          onTap: () => _toggleTodo(id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: completed ? theme.success : Colors.transparent,
              border: Border.all(
                  color: completed ? theme.success : theme.alternate,
                  width: 2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: completed
                ? const Icon(Icons.check, color: Colors.white, size: 14)
                : null,
          ),
        ),
        title: Text(
          title,
          style: theme.bodyLarge.copyWith(
            decoration: completed ? TextDecoration.lineThrough : null,
            color: completed ? theme.secondaryText : theme.primaryText,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (description.isNotEmpty)
              Text(description,
                  style: theme.bodySmall.copyWith(color: theme.secondaryText),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            _priorityBadge(priority, theme),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined,
                  color: theme.secondaryText, size: 20),
              onPressed: () async {
                await context.push('/create-todo', extra: todo);
                _loadTodos();
              },
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: theme.error, size: 20),
              onPressed: () => _deleteTodo(id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priorityBadge(String priority, FlutterFlowTheme theme) {
    Color color;
    switch (priority) {
      case 'high':
        color = theme.error;
        break;
      case 'low':
        color = theme.success;
        break;
      default:
        color = theme.warning;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        priority.toUpperCase(),
        style: theme.labelSmall
            .copyWith(color: color, fontWeight: FontWeight.w700, fontSize: 10),
      ),
    );
  }

  Widget _buildError(FlutterFlowTheme theme) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: theme.error, size: 48),
              const SizedBox(height: 12),
              Text(_model.errorMessage!,
                  style: theme.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: _loadTodos,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primary),
                  child: const Text('Retry',
                      style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
      );

  Widget _buildEmpty(FlutterFlowTheme theme) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline,
                  color: theme.alternate, size: 72),
              const SizedBox(height: 16),
              Text('No todos yet',
                  style: theme.headlineSmall
                      .copyWith(color: theme.secondaryText)),
              const SizedBox(height: 8),
              Text('Tap + to create your first todo',
                  style: theme.bodyMedium
                      .copyWith(color: theme.secondaryText)),
            ],
          ),
        ),
      );
}
