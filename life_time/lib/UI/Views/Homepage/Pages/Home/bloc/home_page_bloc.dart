import 'package:bloc/bloc.dart';
import 'package:life_time/Data/Models/User.dart';
import 'package:life_time/Data/Models/customQuote.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(HomePageInitial()) {
    on<HomePageInitialEvent>(_onHomePageInitialEvent);
  }

  Future<void> _onHomePageInitialEvent(
    HomePageInitialEvent event,
    Emitter<HomePageState> emit,
  ) async {
    try {
      emit(HomePageLoadingState());
      await Future.delayed(Duration(seconds: 2));
      // Calculate completed days
      double completedDays =
          DateTime.now().difference(userModel.dob).inDays.toDouble();

      // Handle invalid or null life expectancy values
      int lifeExpectancyYears =
          int.tryParse(userModel.lifeExpectancyYears) ?? 80;
      double convertingToDays = (lifeExpectancyYears * 365).toDouble();
      double remainingDays = convertingToDays - completedDays;

      // Calculate percentages
      double completedPercentage = ((completedDays / convertingToDays) * 100);
      double remainingDaysPercentage = 100 - completedPercentage;

      String? quote = await service.generateLifeQuote(
        completedDays.toInt(),
        remainingDays.toInt(),
      );

      // Save data in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('completedDays', completedDays);
      await prefs.setDouble('remainingDays', remainingDays);
      await prefs.setDouble('completedPercentage', completedPercentage);
      await prefs.setDouble('remainingDaysPercentage', remainingDaysPercentage);
      await prefs.setString('quote', quote);
      // Emit success state with calculated values
      emit(HomePageSuccessState());
    } catch (e) {
      emit(HomePageErrorState(errorMessage: 'Bloc Error:${e.toString()}'));
    }
  }
}
