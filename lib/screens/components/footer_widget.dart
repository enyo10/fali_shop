import 'package:fali_shop/theme/colors.dart';
import 'package:flutter/material.dart';



class FooterWidget extends StatelessWidget {
  const FooterWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 25),
          RichText(
            text: const TextSpan(
              style: TextStyle(color: CustomColors.navy, fontSize: 30),
              children: <TextSpan>[
                TextSpan(text: 'Made with ❤️ by '),
                TextSpan(
                    text: 'Roger',
                  //  style: TextStyle(color: AppColors.darkGreen)
                    ),
              ],
            ),
            textScaleFactor: 0.5,
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
