import 'package:formz/formz.dart';
import 'package:gobz_app/data/blocs/BlocState.dart';

abstract class EditionBlocState extends BlocState with FormzMixin {
  final FormzStatus formStatus;

  const EditionBlocState({
    required this.formStatus,
    required Exception? error,
  }) : super(isLoading: null, error: error);

  @override
  bool get isLoading => formStatus.isSubmissionInProgress || super.isLoading;

  bool get isSubmissionFailure => formStatus.isSubmissionFailure;

  bool get isSubmissionSuccess => formStatus.isSubmissionSuccess;

  bool get isSubmissionInProgress => formStatus.isSubmissionInProgress;

  @override
  EditionBlocState copyWith({FormzStatus? formStatus, Exception? error, bool? isLoading = false});

  T formSubmitting<T extends BlocState>() => copyWith(formStatus: FormzStatus.submissionInProgress) as T;

  T formSubmissionFailed<T extends EditionBlocState>(Exception error) {
    return copyWith(formStatus: FormzStatus.submissionFailure, error: error) as T;
  }
}
