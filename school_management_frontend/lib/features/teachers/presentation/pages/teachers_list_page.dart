import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../bloc/teacher_bloc.dart';
import '../bloc/teacher_event.dart';
import '../bloc/teacher_state.dart';

final getIt = GetIt.instance;

class TeachersListPage extends StatefulWidget {
  const TeachersListPage({Key? key}) : super(key: key);

  @override
  State<TeachersListPage> createState() => _TeachersListPageState();
}

class _TeachersListPageState extends State<TeachersListPage> {
  late TeacherBloc _teacherBloc;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _teacherBloc = getIt<TeacherBloc>();
    _teacherBloc.add(const GetAllTeachersEvent());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeacherBloc>(
      create: (context) => _teacherBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Teachers'),
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
                  hintText: 'Search teachers...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            _teacherBloc.add(const GetAllTeachersEvent());
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
              child: BlocBuilder<TeacherBloc, TeacherState>(
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
                              _teacherBloc.add(const GetAllTeachersEvent());
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is TeachersLoaded) {
                    return _buildTeachersList(context, state.teachers);
                  }
                  return const Center(child: Text('No data available'));
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push('/teachers/create');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildTeachersList(BuildContext context, List<dynamic> teachers) {
    if (teachers.isEmpty) {
      return const Center(
        child: Text('No teachers found'),
      );
    }

    return ListView.builder(
      itemCount: teachers.length,
      itemBuilder: (context, index) {
        final teacher = teachers[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green,
            child: Text(
              teacher.firstName[0].toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(teacher.fullName),
          subtitle: Text('${teacher.specialization} | ${teacher.email}'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            context.push('/teachers/${teacher.id}');
          },
        );
      },
    );
  }
}