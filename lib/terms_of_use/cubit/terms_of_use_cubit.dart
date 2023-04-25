import 'package:flutter_bloc/flutter_bloc.dart';

class TermsOfUseCubit extends Cubit<bool> {
  TermsOfUseCubit() : super(false);

  void acceptTermsOfUse() => emit(true);
}
