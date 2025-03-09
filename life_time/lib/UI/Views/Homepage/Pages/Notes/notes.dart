import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:life_time/UI/Views/Homepage/Pages/Notes/bloc/notes_page_bloc.dart';
import 'package:life_time/UI/Views/Homepage/Pages/Notes/widgets/noteSection.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: NotesSection());
  }
}

class NotesSection extends StatefulWidget {
  const NotesSection({super.key});

  @override
  State<NotesSection> createState() => _NotesSectionState();
}

class _NotesSectionState extends State<NotesSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 4, // Slight elevation for a neumorphic effect
          shadowColor: Colors.black.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          title: Text(
            "Notes",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white, // Ensures contrast
            ),
          ),
          centerTitle: true,
        ),
        BlocProvider(
          create: (context) => NotesPageBloc(),
          child: NotesDisplaySection(),
        ),
      ],
    );
  }
}
