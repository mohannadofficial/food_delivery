import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/components/big_text.dart';
import 'package:food_delivery/utils/colors.dart';

class SuccessOrderFood extends StatelessWidget {
  const SuccessOrderFood({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(child: IconButton(onPressed: (){
                Navigator.pop(context);
              },
                icon: const Icon(Icons.arrow_back_ios_sharp),
                color: AppColors.mainColor,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height/1.4,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/image/checked.png'),
                    SizedBox(height: 20.h,),
                    BigText(name: 'Payment successful', size: 26.sp,),
                    SizedBox(height: 20.h,),
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.8,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Center(
                          child: BigText(
                            name: 'Continue',
                            color: Colors.white,
                            size: 26.sp,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
