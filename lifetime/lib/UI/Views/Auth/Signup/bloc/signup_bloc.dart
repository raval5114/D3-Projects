import 'package:bloc/bloc.dart';
import 'package:lifetime/UI/Views/Auth/Signup/repos/signup.dart';
import 'package:meta/meta.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<SignupEvent>((event, emit) async {
      Signup signuprepo = Signup();
      try {
        emit(SignupLoadingState());
        await signuprepo.signUp(
          event.email,
          event.password,
          event.firstName,
          event.lastName,
          event.username,
          event.dob,
        );
        // await signuprepo.signUp(event.email, event.password);
        emit(SignupSuccessState());
      } catch (e) {
        emit(SignupErrorState(e.toString()));
      }
    });
  }
}
