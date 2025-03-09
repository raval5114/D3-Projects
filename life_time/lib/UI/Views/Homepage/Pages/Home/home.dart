import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:life_time/Data/Models/User.dart';
import 'package:life_time/UI/Views/Homepage/Pages/Home/Widgets/cutomQuotes.dart';
import 'package:life_time/UI/Views/Homepage/Pages/Home/Widgets/piechart.dart';
import 'package:life_time/UI/Views/Homepage/Pages/Home/Widgets/progressBar.dart';
import 'package:life_time/UI/Views/Homepage/Pages/Home/Widgets/todaysNote.dart';
import 'package:life_time/UI/Views/Homepage/Pages/Home/bloc/home_page_bloc.dart';
import 'package:life_time/UI/Views/Homepage/Pages/Notes/bloc/notes_page_bloc.dart';
import 'package:shimmer/shimmer.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  HomePageBloc bloc = HomePageBloc();
  @override
  void initState() {
    super.initState();
    bloc.add(HomePageInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePageBloc, HomePageState>(
      bloc: bloc,
      listenWhen: (previous, current) => current is HomepageActionState,
      buildWhen: (previous, current) => current is! HomepageActionState,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is HomePageSuccessState) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  elevation: 4, // Slight elevation for a neumorphic effect
                  shadowColor: Colors.black.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  title: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white, // Soft contrast
                        radius: 20,
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Hello Mr/Ms ${userModel.lastName}",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white, // Ensures readability
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.notifications, color: Colors.white),
                      onPressed: () {
                        // Add notification logic here
                      },
                    ),
                  ],
                ),
                DaysCompletedSection(),
                DaysCompletionProgressBarSection(),
                CustomQuotes(),
                BlocProvider(
                  create: (context) => NotesPageBloc(),
                  child: TodaysNoteSection(),
                ),
              ],
            ),
          );
        } else if (state is HomePageLoadingState) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[400]!,
            highlightColor: Colors.grey[500]!,
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
                Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
                Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
              ],
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
