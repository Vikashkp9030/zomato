import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../bloc/class_bloc.dart';
import '../bloc/class_event.dart';
import '../bloc/class_state.dart';

final getIt = GetIt.instance;

class ClassesListPage extends StatefulWidget {
  const ClassesListPage({Key? key}) : super(key: key);

  @override
  State<ClassesListPage> createState() => _ClassesListPageState();
}

class _ClassesListPageState extends State<ClassesListPage> {
  late ClassBloc _classBloc;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _classBloc = getIt<ClassBloc>();
    _classBloc.add(const GetAllClassesEvent());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ClassBloc>(
      create: (context) => _classBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Classes'),
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
                  hintText: 'Search classes...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            _classBloc.add(const GetAllClassesEvent());
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
              child: BlocBuilder<ClassBloc, ClassState>(
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
                              _classBloc.add(const GetAllClassesEvent());
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is ClassesLoaded) {
                    return _buildClassesList(context, state.classes);
                  }
                  return const Center(child: Text('No data available'));
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push('/classes/create');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildClassesList(BuildContext context, List<dynamic> classes) {
    if (classes.isEmpty) {
      return const Center(
        child: Text('No classes found'),
      );
    }

    return ListView.builder(
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final classItem = classes[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.purple,
            child: Text(
              'G${classItem.gradeLevel}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text('${classItem.className} - ${classItem.section}'),
          subtitle: Text(
            'Students: ${classItem.currentStudents}/${classItem.capacity} | Room: ${classItem.roomNumber}',
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            context.push('/classes/${classItem.id}');
          },
        );
      },
    );
  }
}