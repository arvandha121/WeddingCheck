import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weddingcheck/app/database/auth/auth.dart';
import 'package:weddingcheck/app/json/model/users.dart';
import 'package:weddingcheck/views/homepage.dart';
import 'package:weddingcheck/views/auth/loginscreen.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // digunakan untuk menampilkan dan menyembunyikan password
  bool isHidden1 = true;
  bool isHidden2 = true;

  // textediting controller untuk control text ketika di input
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // buat global key untuk form
  final formKey = GlobalKey<FormState>();

  final db = DatabaseHelper();

  register() {
    db
        .register(
          Users(
              usrName: usernameController.text,
              usrPassword: passwordController.text),
        )
        .whenComplete(
          () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Login(),
              ),
            ),
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'lib/assets/image/icon.png',
            ), // Background image
            fit: BoxFit.fitWidth, // Menyesuaikan lebar
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Form digunakan untuk controll textfield agar tidak kosong saat di input
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Text(
                        "REGISTER",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 35,
                      ),

                      // Username TextFormField
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Username tidak boleh kosong";
                          }
                          return null;
                        },
                        controller: usernameController,
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Username",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          prefixIcon: Icon(Icons.person),
                          filled: true, // Set to true to enable filling color
                          fillColor: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),

                      // Password TextFormField
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password tidak boleh kosong";
                          }
                          return null;
                        },
                        controller: passwordController,
                        autocorrect: false,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          labelText: "Password",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(
                                () {
                                  isHidden1 = !isHidden1;
                                },
                              );
                            },
                            icon: Icon(
                              isHidden1
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          prefixIcon: Icon(Icons.vpn_key),
                          filled: true, // Set to true to enable filling color
                          fillColor: Colors.white.withOpacity(0.8),
                        ),
                        textInputAction: TextInputAction.next,
                        obscureText: isHidden1,
                      ),
                      SizedBox(
                        height: 18,
                      ),

                      // Confirm Password TextFormField
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Konfirmasi password tidak boleh kosong";
                          } else if (passwordController.text !=
                              confirmPasswordController.text) {
                            return "Password tidak sama";
                          }
                          return null;
                        },
                        controller: confirmPasswordController,
                        autocorrect: false,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          labelText: "Confirm Password",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(
                                () {
                                  isHidden2 = !isHidden2;
                                },
                              );
                            },
                            icon: Icon(
                              isHidden2
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          prefixIcon: Icon(Icons.lock),
                          filled: true, // Set to true to enable filling color
                          fillColor: Colors.white.withOpacity(0.8),
                        ),
                        textInputAction: TextInputAction.done,
                        obscureText: isHidden2,
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                register();
                                Get.snackbar(
                                  "Register",
                                  "Berhasil membuat akun",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.white,
                                  colorText: Colors.black,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: Text(
                              "Register",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                              );
                            },
                            child: Text("Login"),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
