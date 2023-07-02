import 'package:as_shop/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/auth_widgets.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final formKey = GlobalKey<FormState>();
  bool showOldPass = true;
  bool showPass = true;
  bool passwordVisible = true;
  bool checkPassword = true;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> changePassword() async {
    User currentUser = FirebaseAuth.instance.currentUser!;
    if (formKey.currentState!.validate()) {
      checkPassword = await AuthRepository.checkOldPassword(
          currentUser.email, _oldPasswordController);

      setState(() {});
      checkPassword == true ? print('valid') : print('not valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color.fromARGB(255, 18, 50, 107),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      body: Container(
        padding:
            const EdgeInsets.only(left: 15, right: 30, top: 15, bottom: 30),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const ClampingScrollPhysics(),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 18, 50, 107),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please enter your old and new password to proceed.',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Color.fromARGB(255, 18, 50, 107),
                  ),
                ),
                const Text(
                  '______',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 18, 50, 107),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Row(
                  children: <Widget>[
                    Text('Old Password',
                        style: TextStyle(fontSize: 15, color: Colors.grey)),
                    Text('*',
                        style: TextStyle(fontSize: 15, color: Colors.red)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ////////////////////////// OLD PASSWORD///////////////////
                TextFormField(
                  controller: _oldPasswordController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  obscureText: passwordVisible,
                  decoration: textFormDecoration.copyWith(
                    labelText: 'Old Password',
                    hintText: 'Enter your old Password',
                    errorText: checkPassword != true ? 'wrong password' : null,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showOldPass = !showOldPass;
                        });
                      },
                      icon: Icon(
                        showOldPass ? Icons.visibility : Icons.visibility_off,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your old password.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),

                /////////////////////////////// NEW PASSWORD//////////////////////////
                const Row(
                  children: <Widget>[
                    Text('New Password',
                        style: TextStyle(fontSize: 15, color: Colors.grey)),
                    Text('*',
                        style: TextStyle(fontSize: 15, color: Colors.red)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),

                TextFormField(
                  controller: _newPasswordController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  obscureText: showPass,
                  decoration: textFormDecoration.copyWith(
                    labelText: 'New Password',
                    hintText: 'Enter your new Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showPass = !showPass;
                        });
                      },
                      icon: Icon(
                        showPass ? Icons.visibility : Icons.visibility_off,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return 'Please enter your new password.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                /////////////////////////// CONFIRM PASSWORD///////////////////////////
                const Row(
                  children: <Widget>[
                    Text('Confirm Password',
                        style: TextStyle(fontSize: 15, color: Colors.grey)),
                    Text('*',
                        style: TextStyle(fontSize: 15, color: Colors.red)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),

                //  Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  obscureText: passwordVisible,
                  decoration: textFormDecoration.copyWith(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm your Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password confirmation.';
                    } else if (value != _newPasswordController.text) {
                      return 'Passwords do not match.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(
                      width: double.infinity, height: 50),
                  child: ElevatedButton(
                    onPressed: () {
                      changePassword();
                      // Navigate to the desired screen
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (BuildContext context) => EndPage(),
                      //   ),
                      // );
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 18, 50, 107),
                      ),
                    ),
                    child: const Text('CONFIRM'),
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
