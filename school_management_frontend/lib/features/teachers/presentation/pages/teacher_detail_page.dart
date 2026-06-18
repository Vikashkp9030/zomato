import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../bloc/teacher_bloc.dart';
import '../bloc/teacher_event.dart';
import '../bloc/teacher_state.dart';

final getIt = GetIt.instance;

class TeacherDetailPage extends StatefulWidget {
  final String teacherId;

  const TeacherDetailPage({
    Key? key,
    required this.teacherId,
  }) : super(key: key);

  @override
  State<TeacherDetailPage> createState() => _TeacherDetailPageState();
}

class _TeacherDetailPageState extends State<TeacherDetailPage> {
  late TeacherBloc _teacherBloc;

  @override
  void initState() {
    super.initState();
    _teacherBloc = getIt<TeacherBloc>();
    _teacherBloc.add(GetTeacherByIdEvent(id: int.parse(widget.teacherId)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeacherBloc>(
      create: (context) => _teacherBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Teacher Details'),
          elevation: 0,
          backgroundColor: Colors.blue.shade600,
        ),
        body: BlocBuilder<TeacherBloc, TeacherState>(
          builder: (context, state) {
            if (state is TeacherLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TeacherError) {
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
                        _teacherBloc.add(
                          GetTeacherByIdEvent(id: int.parse(widget.teacherId)),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            if (state is TeacherLoaded) {
              final teacher = state.teacher;
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
                            backgroundColor: Colors.green,
                            child: Text(
                              teacher.firstName[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            teacher.fullName,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              teacher.specialization.toUpperCase(),
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildSection('Personal Information', [
                      _buildDetailItem('Email', teacher.email),
                      _buildDetailItem('Phone', teacher.phone),
                      _buildDetailItem('Specialization', teacher.specialization),
                    ]),
                    const SizedBox(height: 24),
                    _buildSection('Professional Information', [
                      _buildDetailItem('Experience', '${teacher.experienceYears} years'),
                      _buildDetailItem('Salary', '₹${teacher.salary.toStringAsFixed(2)}'),
                    ]),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit'),
                            onPressed: () {
                              context.push('/teachers/${widget.teacherId}/edit');
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

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Teacher'),
        content: const Text('Are you sure you want to delete this teacher?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _teacherBloc.add(
                DeleteTeacherEvent(id: int.parse(widget.teacherId)),
              );
              Navigator.pop(context);
              context.go('/teachers');
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}