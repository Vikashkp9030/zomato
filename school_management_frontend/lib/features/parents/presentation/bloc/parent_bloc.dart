import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/parent_usecases.dart';
import 'parent_event.dart';
import 'parent_state.dart';

class ParentBloc extends Bloc<ParentEvent, ParentState> {
  final ParentUseCases useCases;

  ParentBloc(this.useCases) : super(const ParentInitial()) {
    on<GetAllParentsEvent>(_onGetAllParents);
    on<GetParentByIdEvent>(_onGetParentById);
    on<CreateParentEvent>(_onCreateParent);
    on<UpdateParentEvent>(_onUpdateParent);
    on<DeleteParentEvent>(_onDeleteParent);
    on<GetParentChildrenEvent>(_onGetParentChildren);
    on<LinkParentToStudentEvent>(_onLinkParentToStudent);
    on<UnlinkParentFromStudentEvent>(_onUnlinkParentFromStudent);
    on<SearchParentsEvent>(_onSearchParents);
  }

  Future<void> _onGetAllParents(
    GetAllParentsEvent event,
    Emitter<ParentState> emit,
  ) async {
    emit(const ParentLoading());
    final result = await useCases.getAllParents(
      page: event.page,
      limit: event.limit,
    );
    result.fold(
      (failure) => emit(ParentError(message: failure.message)),
      (parents) => emit(ParentsLoaded(parents: parents)),
    );
  }

  Future<void> _onGetParentById(
    GetParentByIdEvent event,
    Emitter<ParentState> emit,
  ) async {
    emit(const ParentLoading());
    final result = await useCases.getParentById(event.id);
    result.fold(
      (failure) => emit(ParentError(message: failure.message)),
      (parent) => emit(ParentLoaded(parent: parent)),
    );
  }

  Future<void> _onCreateParent(
    CreateParentEvent event,
    Emitter<ParentState> emit,
  ) async {
    emit(const ParentLoading());
    final result = await useCases.createParent(event.data);
    result.fold(
      (failure) => emit(ParentError(message: failure.message)),
      (parent) => emit(ParentCreated(parent: parent)),
    );
  }

  Future<void> _onUpdateParent(
    UpdateParentEvent event,
    Emitter<ParentState> emit,
  ) async {
    emit(const ParentLoading());
    final result = await useCases.updateParent(event.id, event.data);
    result.fold(
      (failure) => emit(ParentError(message: failure.message)),
      (parent) => emit(ParentUpdated(parent: parent)),
    );
  }

  Future<void> _onDeleteParent(
    DeleteParentEvent event,
    Emitter<ParentState> emit,
  ) async {
    emit(const ParentLoading());
    final result = await useCases.deleteParent(event.id);
    result.fold(
      (failure) => emit(ParentError(message: failure.message)),
      (_) => emit(const ParentDeleted()),
    );
  }

  Future<void> _onGetParentChildren(
    GetParentChildrenEvent event,
    Emitter<ParentState> emit,
  ) async {
    emit(const ParentLoading());
    final result = await useCases.getParentChildren(event.parentId);
    result.fold(
      (failure) => emit(ParentError(message: failure.message)),
      (children) => emit(ParentChildrenLoaded(children: children)),
    );
  }

  Future<void> _onLinkParentToStudent(
    LinkParentToStudentEvent event,
    Emitter<ParentState> emit,
  ) async {
    emit(const ParentLoading());
    final result =
        await useCases.linkParentToStudent(event.parentId, event.studentId);
    result.fold(
      (failure) => emit(ParentError(message: failure.message)),
      (_) => emit(const ParentStudentLinked()),
    );
  }

  Future<void> _onUnlinkParentFromStudent(
    UnlinkParentFromStudentEvent event,
    Emitter<ParentState> emit,
  ) async {
    emit(const ParentLoading());
    final result =
        await useCases.unlinkParentFromStudent(event.parentId, event.studentId);
    result.fold(
      (failure) => emit(ParentError(message: failure.message)),
      (_) => emit(const ParentStudentUnlinked()),
    );
  }

  Future<void> _onSearchParents(
    SearchParentsEvent event,
    Emitter<ParentState> emit,
  ) async {
    emit(const ParentLoading());
    final result = await useCases.getAllParents();
    result.fold(
      (failure) => emit(ParentError(message: failure.message)),
      (parents) {
        final filtered = parents
            .where((p) =>
                p.parentName
                    .toLowerCase()
                    .contains(event.query.toLowerCase()) ||
                p.email.toLowerCase().contains(event.query.toLowerCase()) ||
                p.phone.contains(event.query))
            .toList();
        emit(ParentsSearchLoaded(parents: filtered));
      },
    );
  }
}
