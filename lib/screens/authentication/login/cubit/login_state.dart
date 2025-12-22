abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {}

class LoginNewAccountState extends LoginStates {}

class LoginErrorState extends LoginStates {
  final String errorMsg;
  LoginErrorState(this.errorMsg);
}

class PasswordHideShowState extends LoginStates {}
