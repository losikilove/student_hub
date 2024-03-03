import 'package:flutter/material.dart';
import '../components/custom_button.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:student_hub/components/initial_body.dart';
import '../utils/color_util.dart';
import '../components/custom_appbar.dart';
class SignUpSetup1 extends StatefulWidget {
  const SignUpSetup1({super.key});

  @override
  State<SignUpSetup1> createState() => _SignUpSetup1State();
}

class _SignUpSetup1State extends State<SignUpSetup1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: CustomAppbar(
        onPressed: (){},
        currentContext: context,
      ),
      body: InitialBody(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin:const  EdgeInsets.only(top: 30.0,bottom: 20.0),
              child: const Text("Join as Company or Student",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
            ),
             Container(
                height: 170,
                child: ListView(
                  children: [
                    ListItem(),
                    ListItem(),
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
                    const Text("Already have an account ?"),
                    GestureDetector(
                      onTap: (){

                      },
                      child:const Text("log in",
                      style: TextStyle(fontSize: 20,
                      decoration:TextDecoration.underline,
                      decorationColor:ColorUtil.darkPrimary,
                      color: ColorUtil.darkPrimary,)
                    )
                  )
                ],
            )
          ],
        )
      ),


    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.only(left:9,right:9,bottom: 12.0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tileColor:Colors.white,
        subtitle: const Text("I am a company,find engineer for project",style: TextStyle(fontSize: 16),),
        leading: const Icon(Icons.account_box_outlined,size: 30,),
        trailing: RoundCheckBox(
          onTap: (selected) {},
          size: 30,
          uncheckedColor: Colors.white,
          checkedColor: Colors.blue,
        ),
      ),
    );
  }
}