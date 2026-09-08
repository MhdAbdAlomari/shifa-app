part of 'my_surgeries_bloc.dart';

sealed class MySurgeriesEvent extends Equatable {
  const MySurgeriesEvent();

  @override
  List<Object?> get props => const [];
}

class MySurgeriesRequested extends MySurgeriesEvent {
  const MySurgeriesRequested();
}

class MySurgeriesRefreshRequested extends MySurgeriesEvent {
  const MySurgeriesRefreshRequested();
}

/// Fires when the surgeon taps the inline "Start Surgery" button on
/// the Next Up card — hits `POST /surgeries/{id}/start` server-side.
class MySurgeryStartRequested extends MySurgeriesEvent {
  const MySurgeryStartRequested(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}
