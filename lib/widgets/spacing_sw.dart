import 'package:flutter/material.dart';
import 'package:monitor/widgets/screen_widget.dart';

class SpacingSW implements ScreenWidget {
  final int spacing = 1;

  @override
  get widget {
    return Spacer(flex: spacing); 
  }

  @override
  get editWidget {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: const [
        Icon(Icons.linear_scale),
        Text('Spacing')
      ],
    );
  }
}