/// appointmentId : 1
/// name : "Dr. Melinda Rose"
/// institute : "Cancer Institue"
/// designation : "M.B.B.S., M.D"
/// address : "Adayar, Chennai - 20"
/// phone1 : "98435 56597"
/// phone2 : null
/// email : "aci@aci.com"

class AppointmentDetails {
  AppointmentDetails({
      int? appointmentId, 
      String? name, 
      String? institute, 
      String? designation, 
      String? address, 
      String? phone1, 
      dynamic phone2, 
      String? email,}){
    _appointmentId = appointmentId;
    _name = name;
    _institute = institute;
    _designation = designation;
    _address = address;
    _phone1 = phone1;
    _phone2 = phone2;
    _email = email;
}

  AppointmentDetails.fromJson(dynamic json) {
    _appointmentId = json['appointmentId'];
    _name = json['name'];
    _institute = json['institute'];
    _designation = json['designation'];
    _address = json['address'];
    _phone1 = json['phone1'];
    _phone2 = json['phone2'];
    _email = json['email'];
  }
  int? _appointmentId;
  String? _name;
  String? _institute;
  String? _designation;
  String? _address;
  String? _phone1;
  dynamic _phone2;
  String? _email;

  int? get appointmentId => _appointmentId;
  String? get name => _name;
  String? get institute => _institute;
  String? get designation => _designation;
  String? get address => _address;
  String? get phone1 => _phone1;
  dynamic get phone2 => _phone2;
  String? get email => _email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['appointmentId'] = _appointmentId;
    map['name'] = _name;
    map['institute'] = _institute;
    map['designation'] = _designation;
    map['address'] = _address;
    map['phone1'] = _phone1;
    map['phone2'] = _phone2;
    map['email'] = _email;
    return map;
  }

}