import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


abstract class HomeEvent {}

class FetchExpensesEvent extends HomeEvent {}

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<dynamic> expenses;
  HomeLoaded(this.expenses);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

// Bloc
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final storage = const FlutterSecureStorage();

  HomeBloc() : super(HomeInitial()) {
    on<FetchExpensesEvent>(_onFetchExpenses);
  }

  Future<void> _onFetchExpenses(
      FetchExpensesEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    try {
      final token = await storage.read(key: 'auth_token');
      if (token == null) throw Exception('No token found');

      final uri = Uri.parse(
          'https://expense-tracker-mean.onrender.com/expense/get-expense');

      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        emit(HomeLoaded(data));
      } else {
        emit(HomeError('Failed with status code ${response.statusCode}'));
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
