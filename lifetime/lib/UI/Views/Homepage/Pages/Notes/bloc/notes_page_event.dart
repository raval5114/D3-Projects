part of 'notes_page_bloc.dart';

@immutable
sealed class NotesPageEvent {}

final class NotePageAddNoteEvent extends NotesPageEvent {
  String title;
  String description;
  String deadLine;
  NotePageAddNoteEvent({
    required this.title,
    required this.description,
    required this.deadLine,
  });
}

final class NotePageDeleteNoteEvent extends NotesPageEvent {
  final int id;
  NotePageDeleteNoteEvent({required this.id});
}

final class NotePageOnCheckOrOnCheckEvent extends NotesPageEvent {
  final int id;
  final bool isChecked;
  NotePageOnCheckOrOnCheckEvent({required this.id, required this.isChecked});
}

final class NotePageDisplayNoteEvent extends NotesPageEvent {}

final class HomePageNotesDisplayEvent extends NotesPageEvent {}
