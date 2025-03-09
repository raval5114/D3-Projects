class RegisterUser {
  late String _firstName;
  late String _lastName;
  late String _email;
  late String _password;
  late String _username;
  late DateTime _dob;

  // Getters
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  String get password => _password;
  String get username => _username;
  DateTime get dob => _dob;

  // Setters
  set firstName(String firstName) {
    _firstName = firstName;
  }

  set lastName(String lastName) {
    _lastName = lastName;
  }

  set email(String email) {
    _email = email;
  }

  set password(String password) {
    _password = password;
  }

  set username(String username) {
    _username = username;
  }

  set dob(DateTime dob) {
    _dob = dob;
  }
}

RegisterUser registerUser = RegisterUser();
