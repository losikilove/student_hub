

import 'package:flutter/material.dart';

import 'package:student_hub/components/custom_anchor.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/utils/color_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import '../components/custom_button.dart';
import 'package:roundcheckbox/roundcheckbox.dart';


import '../components/custom_appbar.dart';
class SignUpSetup1 extends StatefulWidget {
  const SignUpSetup1({super.key});

  @override
  State<SignUpSetup1> createState() => _SignUpSetup1State();
}

class _SignUpSetup1State extends State<SignUpSetup1> {
  bool checkbox1Value = false;
  bool checkbox2Value = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: ColorUtil.lightPrimary,
       appBar: CustomAppbar(
        onPressed: (){},
        currentContext: context,
      ),
      body: Column(
          children: [
            SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            Center(child: CustomText(text:"Join as Company or Student",isBold: true,)),
      
            SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            Container(
              height: 200,
              child: ListView(
                children: [
                  Container(
      margin:const EdgeInsets.only(left:9,right:9,bottom: 12.0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: Colors.white,
        subtitle: const Text("I am a company,find engineer for project",style: TextStyle(fontSize: 16),),
        leading: const Icon(Icons.account_box_outlined,size: 30,),
        trailing: RoundCheckBox(
          isChecked:checkbox1Value ,
          onTap: (bool? value ) {
             if (value != null) {
             setState(() {
              checkbox1Value = value;
              checkbox2Value = !value;
            });
            }
          },
          size: 30,
          uncheckedColor: Colors.white,
          checkedColor: Colors.blue,
        ),
      ),
    ),
    Container(
      margin:const EdgeInsets.only(left:9,right:9,bottom: 12.0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: Colors.white,
        subtitle: const Text("I am a company,find engineer for project",style: TextStyle(fontSize: 16),),
        leading: const Icon(Icons.account_box_outlined,size: 30,),
        trailing: RoundCheckBox(
          isChecked: checkbox2Value,
          onTap: (bool? value) {
            if (value != null) {
             setState(() {
              checkbox2Value = value;
              checkbox1Value = !value;
            });
            }
          
              
          },
          size: 30,
          uncheckedColor: Colors.white,
          checkedColor: Colors.blue,
        ),
      ),
    )
                ], 
               ),
            ),
           
              
              Container(
                margin:const EdgeInsets.only(bottom: 17.0,left: 10.0,right: 10.0),
                child: CustomButton(text: "Create account",
                onPressed: (){},
                size: CustomButtonSize.large,
              ),
                
            ),
               Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account ? "),
                    CustomAnchor(text: "Log in", onTap: (){})
                ],
            )
          ],
        ),


    );
  }
}

