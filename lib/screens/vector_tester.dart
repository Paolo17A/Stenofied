import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stenofied/utils/shorthand_util.dart';
import 'package:stenofied/widgets/custom_padding_widgets.dart';

class VectorTester extends StatelessWidget {
  const VectorTester({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: all20Pix(
            child: Wrap(
                runSpacing: 4,
                spacing: 4,
                children: ShortHandUtil.vectorMap.keys.map((key) {
                  return Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: Column(children: [
                      Container(
                          width: 50,
                          height: 50,
                          child: SvgPicture.asset(ShortHandUtil.vectorMap[key]!,
                              fit: BoxFit.fill)),
                      Text(key)
                    ]),
                  );
                }).toList())),
      ),
    );
  }
}
