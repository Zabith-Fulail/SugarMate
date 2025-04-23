part of 'sample_bloc.dart';

abstract class SampleState extends BaseState<SampleState> {}

class SampleInitial extends SampleState {}

class SampleSuccessState extends SampleState {
  final String? message;

  SampleSuccessState({this.message});
}

class SampleFailedState extends SampleState {
  final String? errorMsg;

  SampleFailedState({this.errorMsg});
}
