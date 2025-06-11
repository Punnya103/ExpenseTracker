// lib/screens/auth/signin/blocs/signup_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../repositories/auth_repository.dart';

// EVENTS
abstract class SignupEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignupSubmitted extends SignupEvent {
  final String fullName;
  final String userName;
  final String email;
  final String password;

  SignupSubmitted({
    required this.fullName,
    required this.userName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [fullName, userName, email, password];
}

// STATES
abstract class SignupState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {}

class SignupFailure extends SignupState {
  final String error;

  SignupFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// BLOC
class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository authRepository;

  SignupBloc({required this.authRepository}) : super(SignupInitial()) {
    on<SignupSubmitted>(_onSignupSubmitted);
  }

  Future<void> _onSignupSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoading());
    try {
      await authRepository.register(
        fullName: event.fullName,
        userName: event.userName,
        email: event.email,
        password: event.password,
      );
      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }
}
