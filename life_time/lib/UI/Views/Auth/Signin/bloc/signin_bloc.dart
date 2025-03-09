import 'package:bloc/bloc.dart';
import 'package:life_time/UI/Views/Auth/Signin/repos/signin.dart';
import 'package:meta/meta.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  SigninBloc() : super(SigninInitial()) {
    on<SigninEvent>((event, emit) async {
      Signin signinrepo = Signin();
      try {
        emit(SigninLoadingState());
        if (await signinrepo.signIn(event.email, event.password)) {
          emit(SigninSuccessState());
        } else {
          emit(SigninErrorState('Somting went wrong'));
        }
      } catch (e) {
        emit(SigninErrorState(e.toString()));
      }
    });
  }
}
