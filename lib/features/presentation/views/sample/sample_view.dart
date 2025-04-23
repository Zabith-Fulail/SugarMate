
import 'package:flutter/material.dart';

import '../../../../core/services/dependency_injection.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_stylings.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/sample/sample_bloc.dart';
import '../base_view.dart';

class SampleView extends BaseView {
  const SampleView({super.key});

  @override
  State<SampleView> createState() => _SampleViewState();
}

class _SampleViewState extends BaseViewState<SampleView> {
  final SampleBloc _bloc = inject<SampleBloc>();

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: Center(
        child: Text(
          "Sample Screen",
          style: AppStyling.medium20Black,
        ),
      ),
    );
  }

  @override
  List<BaseBloc<BaseEvent, BaseState>> getBlocs() {
    return [_bloc];
  }
}
