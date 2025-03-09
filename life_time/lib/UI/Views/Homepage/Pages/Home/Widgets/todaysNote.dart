import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:life_time/UI/Views/Homepage/Pages/Notes/bloc/notes_page_bloc.dart';
import 'package:life_time/UI/Views/Homepage/Pages/Notes/widgets/src/notes.dart';
import 'package:shimmer/shimmer.dart';

class TodaysNoteSection extends StatefulWidget {
  const TodaysNoteSection({super.key});

  @override
  State<TodaysNoteSection> createState() => _TodaysNoteSectionState();
}

class _TodaysNoteSectionState extends State<TodaysNoteSection> {
  @override
  void initState() {
    super.initState();
    context.read<NotesPageBloc>().add(
      HomePageNotesDisplayEvent(),
    ); // Dispatch event
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
            child: Text(
              "Today's Notes",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const Divider(),
          SizedBox(
            height: 250, // Ensure a bounded height
            child: TodaysNotesListView(), // Use BlocConsumer inside
          ),
        ],
      ),
    );
  }
}

class TodaysNotesListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesPageBloc, NotesPageState>(
      listenWhen: (previous, current) => current is NotesPageActionState,
      buildWhen: (previous, current) => current is! NotesPageActionState,
      listener: (context, state) {
        if (state is NotesPagesCheckBoxUpdatedState) {
          context.read<NotesPageBloc>().add(HomePageNotesDisplayEvent());
        }
      },
      builder: (context, state) {
        if (state is NotesPagesLoadingState) {
          return ListView.builder(
            itemCount: 3,
            itemBuilder:
                (context, index) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      color: Colors.white,
                    ),
                    title: Container(
                      width: double.infinity,
                      height: 15,
                      color: Colors.white,
                    ),
                    subtitle: Container(
                      width: double.infinity,
                      height: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
          );
        } else if (state is NotesPagesSuccessState) {
          List<Map<String, dynamic>> notes = state.notes;

          if (notes.isEmpty) {
            return const Center(child: Text("No notes for today"));
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            shrinkWrap: true,
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return NoteTile(
                noteId: note['id'],
                isChecked: note['isChecked'] == 1,
                title: note['title'] ?? 'Untitled Note',
                discription: note['description'] ?? 'No description available',
                deadLine: DateTime.tryParse(note['deadline']) ?? DateTime.now(),
                ontap: () {
                  context.read<NotesPageBloc>().add(
                    NotePageOnCheckOrOnCheckEvent(
                      id: note['id'],
                      isChecked: note['isChecked'] == 0 ? true : false,
                    ),
                  );
                },
              );
            },
          );
        } else if (state is NotesPageErrorState) {
          return Center(child: Text("Error: ${state.error}"));
        }

        return const SizedBox();
      },
    );
  }
}
