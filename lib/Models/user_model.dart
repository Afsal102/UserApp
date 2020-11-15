

class UserModel {
  String id;
  String firstName;
  String lastName;
  String phoneNumber;
  String countryCode;
  String countryName;
  bool registeredWithPhone;
  String registeredDate;
  String registeredTime;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.countryCode,
    this.countryName,
    this.registeredWithPhone,
    this.registeredDate,
    this.registeredTime,
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'countryName': countryName,
      'registeredWithPhone': registeredWithPhone,
      'registeredDate': registeredDate,
      'registeredTime': registeredTime,
    };
  }


  
}
