import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:life_time/UI/Views/Homepage/Pages/Notes/repos/notesRepo.dart';
import 'package:meta/meta.dart';

part 'notes_page_event.dart';
part 'notes_page_state.dart';

class NotesPageBloc extends Bloc<NotesPageEvent, NotesPageState> {
  NotesPageBloc() : super(NotesPageInitial()) {
    on<NotePageAddNoteEvent>((event, emit) async {
      try {
        if (event.title.isEmpty || event.description.isEmpty) {
          emit(
            NotesPageErrorState(error: "Title and description cannot be empty"),
          );
          return;
        }

        int result = await db.addNote({
          'title': event.title,
          'description': event.description,
          'deadline': event.deadLine,
          'isChecked': 0, // Default value
        });

        if (result > 0) {
          debugPrint('Note added successfully');
          emit(NotePageNOteAddedSuccessState());

          add(NotePageDisplayNoteEvent());
        } else {
          throw Exception("Failed to add note.");
        }
      } catch (e) {
        debugPrint(' Error adding note: $e');
        emit(NotesPageErrorState(error: e.toString()));
      }
    });
    on<NotePageDisplayNoteEvent>((event, emit) async {
      try {
        emit(NotesPagesLoadingState());

        List<Map<String, dynamic>> data = await db.retrieveNotes();
        if (data.isNotEmpty) {
          emit(NotesPagesSuccessState(notes: data));
        } else {
          emit(NotesPagesSuccessState(notes: []));
        }
      } catch (e) {
        debugPrint('Error fetching notes: $e');
        emit(NotesPageErrorState(error: e.toString()));
      }
    });

    on<NotePageOnCheckOrOnCheckEvent>((event, emit) async {
      try {
        await db.toggleIsChecked(event.id, event.isChecked);
        emit(NotesPagesCheckBoxUpdatedState());
      } catch (e) {
        emit(NotesPageErrorState(error: e.toString()));
      }
    });
    on<NotePageDeleteNoteEvent>((event, emit) async {
      try {
        db.deleteNote(event.id);
        emit(NotesPageNoteDeletedState());
      } catch (e) {
        emit(NotesPageErrorState(error: e.toString()));
      }
    });
    on<HomePageNotesDisplayEvent>((event, emit) async {
      emit(NotesPagesLoadingState());
      List<Map<String, dynamic>> data = await db.retriveNotesOfCurrentDate();
      emit(NotesPagesSuccessState(notes: data));
    });
  }
}
