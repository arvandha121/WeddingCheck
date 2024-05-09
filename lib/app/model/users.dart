class Users {
  final int? usrId;
  final String usrName;
  final String usrPassword;

  Users({this.usrId, required this.usrName, required this.usrPassword});

  Map<String, dynamic> toMap() {
    return {
      'usrId': usrId,
      'usrName': usrName,
      'usrPassword': usrPassword,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      usrId: map['usrId'],
      usrName: map['usrName'],
      usrPassword: map['usrPassword'],
    );
  }
}
