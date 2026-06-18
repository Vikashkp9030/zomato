import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../bloc/exam_bloc.dart';
import '../bloc/exam_event.dart';
import '../bloc/exam_state.dart';

final getIt = GetIt.instance;

class ExamsListPage extends StatefulWidget {
  const ExamsListPage({Key? key}) : super(key: key);

  @override
  State<ExamsListPage> createState() => _ExamsListPageState();
}

class _ExamsListPageState extends State<ExamsListPage> {
  late ExamBloc _examBloc;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _examBloc = getIt<ExamBloc>();
    _examBloc.add(const GetAllExamsEvent());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExamBloc>(
      create: (context) => _examBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Exams'),
          elevation: 0,
          backgroundColor: Colors.blue.shade600,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search exams...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            _examBloc.add(const GetAllExamsEvent());
                          },
                        )
                      : null,
                ),
                onChanged: (query) {
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<ExamBloc, ExamState>(
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
                              _examBloc.add(const GetAllExamsEvent());
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is ExamsLoaded) {
                    return _buildExamsList(context, state.exams);
                  }
                  return const Center(child: Text('No data available'));
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push('/exams/create');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildExamsList(BuildContext context, List<dynamic> exams) {
    if (exams.isEmpty) {
      return const Center(
        child: Text('No exams found'),
      );
    }

    return ListView.builder(
      itemCount: exams.length,
      itemBuilder: (context, index) {
        final exam = exams[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.orange,
            child: const Icon(Icons.assignment, color: Colors.white),
          ),
          title: Text(exam.examName),
          subtitle: Text(
            '${exam.examType} | ${exam.examDate.toString().split(' ')[0]} | ${exam.examTime}',
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            context.push('/exams/${exam.id}');
          },
        );
      },
    );
  }
}