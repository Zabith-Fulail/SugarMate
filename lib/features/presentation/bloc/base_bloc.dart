import 'package:bloc/bloc.dart';

part 'base_event.dart';

part 'base_state.dart';

abstract class BaseBloc<T extends BaseEvent, K extends BaseState>
    extends Bloc<T, K> {
  BaseBloc(super.initialState);
}