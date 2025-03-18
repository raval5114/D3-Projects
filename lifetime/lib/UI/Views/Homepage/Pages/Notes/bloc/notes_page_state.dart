part of 'notes_page_bloc.dart';

@immutable
sealed class NotesPageState {}

final class NotesPageInitial extends NotesPageState {}

final class NotesPageActionState extends NotesPageState {}

final class NotePageNOteAddedSuccessState extends NotesPageActionState {}

final class NotesPagesLoadingState extends NotesPageState {}

final class NotesPagesSuccessState extends NotesPageState {
  List<Map<String, dynamic>> notes;
  NotesPagesSuccessState({required this.notes});
}

final class NotesPagesCheckBoxUpdatedState extends NotesPageActionState {}

final class NotesPageNoteDeletedState extends NotesPageActionState {}

final class NotesPageErrorState extends NotesPageState {
  String error;
  NotesPageErrorState({required this.error});
}
