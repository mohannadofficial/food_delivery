class RegisterFood {
  String name;
  String phone;
  String email;
  String password;

  RegisterFood(this.name, this.phone, this.password, this.email);

  Map<String, dynamic> toJson(){
    return {
      'f_name':name,
      'phone':phone,
      'email':email,
      'password':password
    };
  }





}