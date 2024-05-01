import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weddingcheck/app/database/auth/login.dart';
import 'package:weddingcheck/app/json/model/users.dart';
import 'package:weddingcheck/views/homepage.dart';
import 'package:weddingcheck/views/auth/registerscreen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // digunakan untuk menampilkan dan menyembunyikan password
  bool isHidden = true;
  bool isLogin = false; // Digunakan untuk login

  // textediting controller untuk control text ketika di input
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // buat global key untuk form
  final formKey = GlobalKey<FormState>();

  final db = DatabaseHelper();

  // Function ini digunakan untuk button login
  login() async {
    var response = await db.login(
      Users(
        usrName: usernameController.text,
        usrPassword: passwordController.text,
      ),
    );
    if (response == true) {
      // Jika login berhasil maka akan diarahkan ke halaman homepage
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      // Jika salah, akan memunculkan message "Username atau Password salah"
      setState(() {
        isLogin = true;
      });
    }
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
                        "LOGIN",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Username tidak boleh kosong";
                          }
                          return null;
                        },
                        controller: usernameController,
                        autocorrect: isHidden,
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
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password tidak boleh kosong";
                          }
                          return null;
                        },
                        controller: passwordController,
                        autocorrect: true,
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
                                  isHidden = !isHidden;
                                },
                              );
                            },
                            icon: Icon(
                              isHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          prefixIcon: Icon(Icons.vpn_key),
                          filled: true, // Set to true to enable filling color
                          fillColor: Colors.white.withOpacity(0.8),
                        ),
                        textInputAction: TextInputAction.done,
                        obscureText: isHidden,
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
                                login();
                                Get.snackbar(
                                  "Login",
                                  "Login anda berhasil",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.white,
                                  colorText: Colors.black,
                                );
                              }
                              ;
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: Text(
                              "Login",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Register(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              side: BorderSide(
                                color: Colors.green, // Warna outline
                              ),
                              backgroundColor:
                                  Colors.white, // Warna latar belakang
                            ),
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.green, // Warna teks
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      // Digunakan untuk mentriger user dan password ketika salah masukkan users
                      isLogin
                          ? const Text(
                              "Username atau Password salah",
                              style: TextStyle(color: Colors.red),
                            )
                          : const SizedBox(),
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
