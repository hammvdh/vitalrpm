class PatientModel {
  String patientId;
  String userId;
  String patientName;
  String mobileNo;
  String email;
  String image;
  String dateOfBirth;
  double height;
  double weight;
  String bloodGroup;
  String careProviderName;
  String careProviderEmail;
  String careProviderMobileNo;

  PatientModel({
    this.patientId = "",
    this.userId = "",
    this.patientName = "",
    this.mobileNo = "",
    this.email = "",
    this.image = "",
    this.dateOfBirth = "",
    this.height = 0,
    this.weight = 0,
    this.bloodGroup = "",
    this.careProviderName = "",
    this.careProviderEmail = "",
    this.careProviderMobileNo = "",
  });
}
