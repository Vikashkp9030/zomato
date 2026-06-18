import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../bloc/exam_bloc.dart';
import '../bloc/exam_event.dart';
import '../bloc/exam_state.dart';

final getIt = GetIt.instance;

class ExamDetailPage extends StatefulWidget {
  final String examId;

  const ExamDetailPage({
    Key? key,
    required this.examId,
  }) : super(key: key);

  @override
  State<ExamDetailPage> createState() => _ExamDetailPageState();
}

class _ExamDetailPageState extends State<ExamDetailPage> {
  late ExamBloc _examBloc;

  @override
  void initState() {
    super.initState();
    _examBloc = getIt<ExamBloc>();
    _examBloc.add(GetExamByIdEvent(int.parse(widget.examId)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExamBloc>(
      create: (context) => _examBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Exam Details'),
          elevation: 0,
          backgroundColor: Colors.blue.shade600,
        ),
        body: BlocBuilder<ExamBloc, ExamState>(
          builder: (context, state) {
            if (state is ExamLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ExamError) {
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
                        _examBloc.add(GetExamByIdEvent(int.parse(widget.examId)));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            if (state is ExamLoaded) {
              final exam = state.exam;
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
                            backgroundColor: Colors.orange,
                            child: const Icon(
                              Icons.assignment,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            exam.examName,
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              exam.examType.toUpperCase(),
                              style: TextStyle(
                                color: Colors.orange.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildSection('Exam Schedule', [
                      _buildDetailItem('Date', exam.examDate.toString().split(' ')[0]),
                      _buildDetailItem('Time', exam.examTime),
                    ]),
                    const SizedBox(height: 24),
                    _buildSection('Marking Details', [
                      _buildDetailItem('Total Marks', '${exam.totalMarks}'),
                      _buildDetailItem('Passing Marks', '${exam.passingMarks}'),
                      _buildDetailItem(
                        'Passing Percentage',
                        '${((exam.passingMarks / exam.totalMarks) * 100).toStringAsFixed(2)}%',
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildSection('Course Information', [
                      _buildDetailItem('Subject ID', '${exam.subjectId}'),
                      _buildDetailItem('Class ID', '${exam.classId}'),
                    ]),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit'),
                            onPressed: () {
                              context.push('/exams/${widget.examId}/edit');
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
        title: const Text('Delete Exam'),
        content: const Text('Are you sure you want to delete this exam?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _examBloc.add(DeleteExamEvent(int.parse(widget.examId)));
              Navigator.pop(context);
              context.go('/exams');
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}