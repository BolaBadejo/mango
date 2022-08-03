import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mango/Models/customModel/user.dart';
import 'package:mango/Screens/Auth/authentication.dart';
import 'package:mango/Screens/Home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MangoUser?>(context);
    if (user != null){
      return const HomePage();
    }
    return const Authenticate();
  }
  }
