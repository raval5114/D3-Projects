import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_time/UI/Views/Homepage/Pages/Notes/bloc/notes_page_bloc.dart';
import 'package:life_time/UI/Views/Homepage/Pages/Notes/widgets/addNote.dart';
import 'package:life_time/UI/Views/Homepage/Pages/Notes/widgets/src/notes.dart';
import 'package:shimmer/shimmer.dart';

class NotesDisplaySection extends StatefulWidget {
  const NotesDisplaySection({super.key});

  @override
  State<NotesDisplaySection> createState() => _NotesDisplaySectionState();
}

class _NotesDisplaySectionState extends State<NotesDisplaySection> {
  final OverlayPortalController _overlayController = OverlayPortalController();

  @override
  void initState() {
    super.initState();
    debugPrint('initStateCalling');
    fetchingData();
  }

  void fetchingData() {
    context.read<NotesPageBloc>().add(NotePageDisplayNoteEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesPageBloc, NotesPageState>(
      listenWhen: (previous, current) => current is NotesPageActionState,
      buildWhen: (previous, current) => current is! NotesPageActionState,
      listener: (context, state) {
        if (state is NotesPagesCheckBoxUpdatedState) {
          fetchingData();
        }
      },
      builder: (context, state) {
        if (state is NotesPagesLoadingState) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[400]!,
            highlightColor: Colors.grey[300]!,
            child: ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              itemBuilder:
                  (context, index) => ListTile(
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

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height - 190,
                  child:
                      notes.isEmpty
                          ? const Center(child: Text("No notes available"))
                          : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 80),
                            shrinkWrap: true,
                            itemCount: notes.length,
                            itemBuilder: (context, index) {
                              final note = notes[index];
                              return Dismissible(
                                key: Key(
                                  note['id'].toString(),
                                ), // Unique key for each item
                                direction: DismissDirection.startToEnd,
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 20),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                onDismissed: (direction) {
                                  context.read<NotesPageBloc>().add(
                                    NotePageDeleteNoteEvent(
                                      id: note['id'],
                                    ), // Trigger delete event
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Note deleted")),
                                  );
                                },
                                child: NoteTile(
                                  noteId: note['id'],
                                  isChecked: note['isChecked'] == 1,
                                  title: note['title'] ?? 'Untitled Note',
                                  discription:
                                      note['description'] ??
                                      'No description available',
                                  deadLine:
                                      DateTime.tryParse(note['deadline']) ??
                                      DateTime.now(),
                                  ontap: () {
                                    context.read<NotesPageBloc>().add(
                                      NotePageOnCheckOrOnCheckEvent(
                                        id: note['id'],
                                        isChecked:
                                            note['isChecked'] == 0
                                                ? true
                                                : false,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    onPressed:
                        () => setState(() => _overlayController.toggle()),
                    child:
                        _overlayController.isShowing
                            ? const Icon(Icons.close, color: Colors.white)
                            : const Icon(Icons.add, color: Colors.white),
                  ),
                ),
                OverlayPortal(
                  controller: _overlayController,
                  overlayChildBuilder:
                      (context) => BlocProvider.value(
                        value: context.read<NotesPageBloc>(),
                        child: AddNodeSection(
                          onClose: () {
                            _overlayController.toggle();
                            setState(() {});
                          },
                        ),
                      ),
                ),
              ],
            ),
          );
        } else if (state is NotesPageErrorState) {
          return Center(child: Text("Error: ${state.error}"));
        }
        return const SizedBox(child: Text("sfr"));
      },
    );
  }
}
