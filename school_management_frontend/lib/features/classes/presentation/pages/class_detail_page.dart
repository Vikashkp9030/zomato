import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../bloc/class_bloc.dart';
import '../bloc/class_event.dart';
import '../bloc/class_state.dart';

final getIt = GetIt.instance;

class ClassDetailPage extends StatefulWidget {
  final String classId;

  const ClassDetailPage({
    Key? key,
    required this.classId,
  }) : super(key: key);

  @override
  State<ClassDetailPage> createState() => _ClassDetailPageState();
}

class _ClassDetailPageState extends State<ClassDetailPage> {
  late ClassBloc _classBloc;

  @override
  void initState() {
    super.initState();
    _classBloc = getIt<ClassBloc>();
    _classBloc.add(GetClassByIdEvent(id: int.parse(widget.classId)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ClassBloc>(
      create: (context) => _classBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Class Details'),
          elevation: 0,
          backgroundColor: Colors.blue.shade600,
        ),
        body: BlocBuilder<ClassBloc, ClassState>(
          builder: (context, state) {
            if (state is ClassLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ClassError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: ${state.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _classBloc.add(GetClassByIdEvent(id: int.parse(widget.classId)));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            if (state is ClassLoaded) {
              final classData = state.classEntity;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.purple,
                            child: Text(
                              'G${classData.gradeLevel}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            classData.className,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Section ${classData.section}',
                              style: TextStyle(
                                color: Colors.purple.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildSection('Class Information', [
                      _buildDetailItem('Grade Level', 'Grade ${classData.gradeLevel}'),
                      _buildDetailItem('Section', classData.section),
                      _buildDetailItem('Room Number', classData.roomNumber),
                    ]),
                    const SizedBox(height: 24),
                    _buildSection('Capacity & Occupancy', [
                      _buildDetailItem('Total Capacity', '${classData.capacity}'),
                      _buildDetailItem('Current Students', '${classData.currentStudents}'),
                      _buildDetailItem('Vacant Seats', '${classData.capacity - classData.currentStudents}'),
                      _buildDetailItem(
                        'Occupancy Rate',
                        '${((classData.currentStudents / classData.capacity) * 100).toStringAsFixed(1)}%',
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildProgressSection(
                      'Class Occupancy',
                      classData.currentStudents / classData.capacity,
                      '${classData.currentStudents}/${classData.capacity} Students',
                    ),
                    const SizedBox(height: 24),
                    _buildDetailItem('Class Teacher ID', '${classData.classTeacherId}'),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit'),
                            onPressed: () {
                              context.push('/classes/${widget.classId}/edit');
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.delete),
                            label: const Text('Delete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              _showDeleteDialog(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(String title, double progress, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress > 0.8 ? Colors.red : Colors.green,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Class'),
        content: const Text('Are you sure you want to delete this class?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _classBloc.add(DeleteClassEvent(id: int.parse(widget.classId)));
              Navigator.pop(context);
              context.go('/classes');
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
