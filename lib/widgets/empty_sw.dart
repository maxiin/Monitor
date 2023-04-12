import 'package:flutter/material.dart';
import 'package:monitor/widgets/screen_widget.dart';

class EmptySW implements ScreenWidget {
  @override
  get widget {
    return const Spacer(flex: 1); 
  }

  @override
  get editWidget {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: const [
        Icon(Icons.add),
        Text('Empty')
      ],
    );
  }
}