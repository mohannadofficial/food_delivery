import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../components/big_text.dart';

import '../../../components/icon_app_pages.dart';
import '../../../utils/colors.dart';
import '../../login/login_food.dart';

class LoginCheckOut extends StatelessWidget {
  const LoginCheckOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Column(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(start: 10.h , top: 5.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconAppPages(
                  icon: Icons.arrow_back_ios_sharp,
                  backGroundColor: AppColors.mainColor,
                  color: Colors.white,
                  function: (){
                    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.dark,
                    ));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment:  MainAxisAlignment.center,
              children: [
                Image(
                  image: const AssetImage(
                    'assets/image/signintocontinue.png',
                  ),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/3,
                ),
                Container(
                    width: MediaQuery.of(context).size.width/1.25,
                    height: MediaQuery.of(context).size.height/10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(20.r),
                      color: AppColors.mainColor,
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginFoodScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BigText(name: 'Sign in here! ', color: Colors.white,),
                          const Icon(Icons.login, color: Colors.white,)

                        ],
                      ),
                    )
                )
              ],
            ),
          ),
        ],
      ),),
    );
  }
}
