import 'dart:async';

import 'package:flutter/material.dart';
import 'package:monitor/widgets/screen_widget.dart';

class GameDealModel {
  String? title;
  String? storeID;
  String? salePrice;
  String? normalPrice;
  String? savings;
  String? steamRatingText;
  String? steamRatingPercent;
  String? thumb;

  GameDealModel({
    this.title,
    this.storeID,
    this.salePrice,
    this.normalPrice,
    this.savings,
    this.steamRatingPercent,
    this.steamRatingText,
    this.thumb});
}

class GameDeals extends StatefulWidget {
  final MainAxisAlignment alignment;
  final double fontSize;
  const GameDeals({super.key, required this.alignment, required this.fontSize});

  @override
  State<StatefulWidget> createState() => GameDealsStatus();
}

class GameDealsStatus extends State<GameDeals> {
  late Timer _timer;
  List<GameDealModel> _deals = [];

  void getDeals() async {
    List<GameDealModel> apiDeals = [];
    for (var i = 0; i < 10; i++) {
      apiDeals.add(
        GameDealModel(
          title:"Dying Light Enhanced Edition",
          storeID:"25",
          salePrice:"0.00",
          normalPrice:"29.99",
          savings:"100.000000",
          steamRatingText:"Overwhelmingly Positive",
          steamRatingPercent:"95",
          thumb:"https://cdn.cloudflare.steamstatic.com/steam/subs/88801/capsule_sm_120.jpg?t=1651792054"
        )
      );
    }
    _deals = apiDeals;
  }

  @override
  void initState() {
    getDeals();
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 30), (timer) {
      setState(() {
        getDeals();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  List<Widget> _buildList() {
    List<Widget> list = [];
    for (var deal in _deals) {
      list.add(Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: widget.alignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10,),
          Text(deal.title ?? '', style: TextStyle(fontSize: widget.fontSize, fontWeight: FontWeight.bold),),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text('Price : ${deal.salePrice}', style: TextStyle(fontSize: widget.fontSize),),
              Text(deal.normalPrice ?? '', 
                style: TextStyle(decoration: TextDecoration.lineThrough, fontSize: widget.fontSize / 1.5, color: Color.fromARGB(155, 255, 255, 255)),),
              Text('  ${double.parse(deal.savings??'0').toStringAsFixed(0)}% Off', style: TextStyle(fontSize: widget.fontSize),),
            ],
          ),
          Text('${deal.steamRatingPercent}% - ${deal.steamRatingText}', style: TextStyle(fontSize: widget.fontSize / 1.3),),
          Container(height: 1, width: 200, color: Colors.white,)
        ],
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
      children: [
        ..._buildList()
      ],
        ),
    );
  }
}

class GameDealsSW implements ScreenWidget {
  MainAxisAlignment alignment;
  double fontSize;

  GameDealsSW({this.alignment = MainAxisAlignment.end, this.fontSize = 20});

	@override
	get widget {
		return GameDeals(alignment: alignment, fontSize: fontSize,);
	}

	@override
	get editWidget {
		return Column(
			mainAxisAlignment: MainAxisAlignment.center,
			children: const [
				Icon(Icons.savings),
				Text('GameDeals')
			],
		);
	}
}
