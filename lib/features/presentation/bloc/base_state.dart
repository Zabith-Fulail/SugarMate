part of 'base_bloc.dart';

abstract class BaseState<K> {}

class BaseInitial extends BaseState {}

class APILoadingState<K> extends BaseState<K> {}

class APIFailureState<K> extends BaseState<K> {
  String? error;

  APIFailureState({this.error});
}
class TokenInvalidState<K> extends BaseState<K> {
  String? error;

  TokenInvalidState({this.error});
}