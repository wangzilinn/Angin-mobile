import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/animation/fade_animation.dart';
import 'package:word_front_end/models/data_response_model.dart';
import 'package:word_front_end/services/application/user_service.dart';
import 'package:word_front_end/views/navigation/navigation_view.dart';

class LogInView extends StatefulWidget {
  @override
  _LogInViewState createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView> {
  String welcomeText = "Welcome back\nBaby!";

  final passwordController = TextEditingController();

  UserService get userService => GetIt.I<UserService>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(builder: (context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 400,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: -40,
                      height: 400,
                      width: width,
                      child: FadeAnimation(
                        delay: 2,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'lib/assets/images/background.png'),
                                  fit: BoxFit.fill)),
                        ),
                      ),
                    ),
                    Positioned(
                      height: 400,
                      width: width + 20,
                      child: FadeAnimation(
                        delay: 3,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'lib/assets/images/background-2.png'),
                                  fit: BoxFit.fill)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeAnimation(
                      delay: 3.5,
                      child: FlatButton(
                        child: Text(
                          welcomeText,
                          style: TextStyle(
                              color: Color.fromRGBO(49, 39, 79, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        onPressed: () => clickWelcomeText(context),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    FadeAnimation(
                      delay: 3.5,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(196, 135, 198, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10))
                            ]),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[300]))),
                              child: TextField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey)),
                                obscureText: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FadeAnimation(
                      delay: 3.6,
                      child: Center(
                          child: Text(
                        "Reset password",
                        style:
                            TextStyle(color: Color.fromRGBO(196, 135, 198, 1)),
                      )),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    FadeAnimation(
                      delay: 3.7,
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 60),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color.fromRGBO(45, 39, 79, 1),
                        ),
                        child: FlatButton(
                          onPressed: () => clickLoginButton(context),
                          child: Center(
                            child: Text(
                              "Sign in",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  var cnt = 0;

  void clickWelcomeText(context) {
    setState(() {
      var inset = "";
      if (cnt > 13) {
        Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          content: Text("啊啊啊~受不了了~~快停~~"),
          duration: Duration(milliseconds: 200),
        ));
        return;
      }
      for (var i = 0; i < cnt; i++) {
        inset += "大";
      }
      welcomeText = "Welcome back\n$inset宝贝!";
    });
    cnt++;
  }

  void clickLoginButton(context) async {
    print('Signin');
    String password = passwordController.text;
    print(password);
    DataResponseModel response = await userService.signIn(
        "wangzilin", password);
    if (!response.error) {
      print("sign in successfully");
    } else {
      print("sign in failed");
    }
    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => NavigationView()));
  }

}
