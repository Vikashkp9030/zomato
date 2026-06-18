import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/dashboard_stat_card.dart';

final getIt = GetIt.instance;

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late DashboardBloc _dashboardBloc;

  @override
  void initState() {
    super.initState();
    _dashboardBloc = getIt<DashboardBloc>();
    _dashboardBloc.add(const RefreshDashboardEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardBloc>(
      create: (context) => _dashboardBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          elevation: 0,
          backgroundColor: Colors.blue.shade600,
        ),
        body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is DashboardErrorState) {
              return _buildErrorWidget(context, state.message);
            }
            if (state is DashboardLoadedState) {
              return _buildDashboardContent(context, state);
            }
            if (state is DashboardStatsLoadedState) {
              return _buildStatsContent(context, state.stats);
            }
            return const Center(child: Text('No data available'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _dashboardBloc.add(const RefreshDashboardEvent());
          },
          tooltip: 'Refresh',
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $message', textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<DashboardBloc>().add(const RefreshDashboardEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, DashboardLoadedState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsSection(state.stats),
          const SizedBox(height: 24),
          const Text('Quick Access', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildQuickAccessButtons(context),
          const SizedBox(height: 24),
          const Text('Analytics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildExamsSection(state.upcomingExams),
          const SizedBox(height: 24),
          _buildFeesSection(state.pendingFees),
        ],
      ),
    );
  }

  Widget _buildStatsContent(BuildContext context, Map<String, dynamic> stats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsSection(stats),
        ],
      ),
    );
  }

  Widget _buildStatsSection(Map<String, dynamic> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            DashboardStatCard(
              title: 'Total Students',
              value: stats['total_students']?.toString() ?? '0',
              icon: Icons.people,
              color: Colors.blue,
            ),
            DashboardStatCard(
              title: 'Total Teachers',
              value: stats['total_teachers']?.toString() ?? '0',
              icon: Icons.school,
              color: Colors.green,
            ),
            DashboardStatCard(
              title: 'Total Classes',
              value: stats['total_classes']?.toString() ?? '0',
              icon: Icons.class_,
              color: Colors.orange,
            ),
            DashboardStatCard(
              title: 'Upcoming Exams',
              value: stats['upcoming_exams']?.toString() ?? '0',
              icon: Icons.assignment,
              color: Colors.purple,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExamsSection(List<dynamic> upcomingExams) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Upcoming Exams', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...upcomingExams.take(3).map((exam) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.assignment, color: Colors.orange),
              title: Text(exam['exam_name'] ?? 'Unknown'),
              trailing: Text(exam['date'] ?? 'N/A'),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFeesSection(List<dynamic> pendingFees) {
    double totalPending = 0;
    for (var fee in pendingFees) {
      if (fee['amount'] != null) {
        totalPending += (fee['amount'] as num).toDouble();
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pending Fees', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(
          color: Colors.red.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('₹${totalPending.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
                const SizedBox(height: 8),
                Text('${pendingFees.length} students with pending fees', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAccessButtons(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildQuickAccessCard(
          context,
          icon: Icons.people,
          label: 'Students',
          color: Colors.blue,
          onTap: () => context.go('/students'),
        ),
        _buildQuickAccessCard(
          context,
          icon: Icons.school,
          label: 'Teachers',
          color: Colors.green,
          onTap: () => context.go('/teachers'),
        ),
        _buildQuickAccessCard(
          context,
          icon: Icons.assignment,
          label: 'Exams',
          color: Colors.orange,
          onTap: () => context.go('/exams'),
        ),
        _buildQuickAccessCard(
          context,
          icon: Icons.class_,
          label: 'Classes',
          color: Colors.purple,
          onTap: () => context.go('/classes'),
        ),
      ],
    );
  }

  Widget _buildQuickAccessCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
