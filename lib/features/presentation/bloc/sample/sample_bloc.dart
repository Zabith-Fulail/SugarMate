import 'package:bloc/bloc.dart';

import '../../../data/models/common/base_response.dart';
import '../../../data/models/requests/sample.dart';
import '../../../domain/usecases/sample/sample.dart';
import '../base_bloc.dart';

part 'sample_event.dart';

part 'sample_state.dart';

class SampleBloc extends BaseBloc<SampleEvent, BaseState<SampleState>> {
  final SampleUseCase? sampleUseCase;

  SampleBloc({this.sampleUseCase}) : super(SampleInitial()) {
    on<GetSampleEvent>(_onGetSampleEvent);
  }

  ///Update Profile Image
  Future<void> _onGetSampleEvent(
    GetSampleEvent event,
    Emitter<BaseState<SampleState>> emit,
  ) async {
    try {
      final response = await sampleUseCase!(SampleRequest(message: 'Message'));
      emit(
        response.fold(
          (l) {
            if (l is BaseResponse) {
              return SampleFailedState(errorMsg: l.message);
            } else {
              return SampleFailedState(errorMsg: l.toString());
            }
          },
          (r) {
            if (r.success!) {
              return SampleSuccessState(message: r.message);
            } else {
              return SampleFailedState(errorMsg: r.message);
            }
          },
        ),
      );
    } catch (e) {
      emit(APIFailureState(error: e.toString()));
    }
  }
}
