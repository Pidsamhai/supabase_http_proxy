abstract class BasicState {
  const BasicState();
}

class InitailState extends BasicState {
  const InitailState();
}

class LoadingState extends BasicState {
  const LoadingState();
}

class SuccessState extends BasicState {
  const SuccessState();
}

class FailureState extends BasicState {
  final String msg;
  const FailureState(this.msg);
}
