import 'package:flutter/material.dart';
import 'package:notice_board/ui/custom_widgets/login_register_button/login_register_button.dart';
import 'package:notice_board/ui/screens/student/add_idea-screen/add_idea_screen_vm.dart';
import 'package:provider/provider.dart';
class AddIdeaScreen extends StatelessWidget {
  const AddIdeaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context)=>AddIdeaScreenVM(),
      builder: (context,viewModel)
      {
        return Center(
          child: LoginRegisterButton(
            buttonText: "Submit",
            onPressed: (){
              Provider.of<AddIdeaScreenVM>(context,listen: false).post();
            },
          ),
        );
      },
    );
  }
}
