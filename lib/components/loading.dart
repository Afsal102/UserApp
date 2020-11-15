import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Container(
        // height: MediaQuery.of(context).size.height,
        // height: MediaQuery.of(context).size.height/2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.purple[100].withOpacity(0.3),
        ),

        child: Center(
          child: SpinKitWave(
            color: Colors.purple,
            size: 50.0,
          ),
        ),
      ),
    );
  }
}
