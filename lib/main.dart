import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


Future<void> main()
async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );
  runApp(MaterialApp(home: first(),));
}

class first extends StatefulWidget {
  const first({super.key});

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {

  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  String v_id="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(),

      body: Column(children: [
        TextField(
          controller: t1,
        ),

        ElevatedButton(onPressed: () async {


          await FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: '+91${t1.text}',
              verificationCompleted: (PhoneAuthCredential credential) async {

            await auth.signInWithCredential(credential);
            },

              verificationFailed: (FirebaseAuthException e) {

                if (e.code == 'invalid-phone-number') {
                  print('The provided phone number is not valid.');
                }
              },

              codeSent: (String verificationId, int? resendToken) async {
                v_id=verificationId;
                setState(() {

                });
                },

            codeAutoRetrievalTimeout: (String verificationId) {},

          );
        }, child: Text("Enter OTP")),

        TextField(
          controller: t2,
        ),

        ElevatedButton(onPressed: () async {

          String smsCode = '${t2.text}';

          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: v_id, smsCode: smsCode);

          await auth.signInWithCredential(credential).then((value) {
            print(value);
            setState(() {

            });
          });

        }, child: Text("Verify Otp"))
      ],),

    );
  }
}
