import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../bloc/student_bloc.dart';
import '../bloc/student_event.dart';
import '../bloc/student_state.dart';

final getIt = GetIt.instance;

class StudentsListPage extends StatefulWidget {
  const StudentsListPage({Key? key}) : super(key: key);

  @override
  State<StudentsListPage> createState() => _StudentsListPageState();
}

class _StudentsListPageState extends State<StudentsListPage> {
  late StudentBloc _studentBloc;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _studentBloc = getIt<StudentBloc>();
    _studentBloc.add(const GetAllStudentsEvent());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StudentBloc>(
      create: (context) => _studentBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Students'),
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
                  hintText: 'Search students...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            _studentBloc.add(const GetAllStudentsEvent());
                          },
                        )
                      : null,
                ),
                onChanged: (query) {
                  if (query.isEmpty) {
                    _studentBloc.add(const GetAllStudentsEvent());
                  } else {
                    _studentBloc.add(SearchStudentsEvent(query));
                  }
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<StudentBloc, StudentState>(
                builder: (context, state) {
                  if (state is StudentLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is StudentError) {
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
                              _studentBloc.add(const GetAllStudentsEvent());
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is StudentsLoaded) {
                    return _buildStudentsList(context, state.students);
                  }
                  if (state is StudentsSearchLoaded) {
                    return _buildStudentsList(context, state.students);
                  }
                  return const Center(child: Text('No data available'));
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push('/students/create');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildStudentsList(BuildContext context, List<dynamic> students) {
    if (students.isEmpty) {
      return const Center(
        child: Text('No students found'),
      );
    }

    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(
              student.firstName[0].toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(student.fullName),
          subtitle: Text('Class: ${student.classId} | ${student.email}'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            context.push('/students/${student.id}');
          },
        );
      },
    );
  }
}
