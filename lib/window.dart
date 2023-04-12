import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:monitor/widgets/game_deals_sw.dart';
import 'package:reorderable_grid/reorderable_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monitor/widgets/empty_sw.dart';
import 'package:monitor/widgets/screen_widget.dart';
import 'package:monitor/widgets/spacing_sw.dart';
import 'package:monitor/widgets/time_sw.dart';
import 'package:window_manager/window_manager.dart';

class Window extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WindowState();
}

class WindowState extends State<Window> {
  final crossAxisCount = 5;
  final mainAxisCount = 3;
  List<ScreenWidget> items = [];
  bool _editMode = false;

  bool fullscreen = false;

  @override
  void initState() {
    _clearList();
    _retrieveList();
    super.initState();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      final item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
    });
  }

  void _fullScreenToggle() async {
    await WindowManager.instance.setFullScreen(!fullscreen);
    fullscreen = !fullscreen;
  }

  void _clearList() {
    items = List<ScreenWidget>.generate(crossAxisCount * mainAxisCount, (index) => EmptySW());
  }
  
  Future<void> _saveList() async {
    items = List<ScreenWidget>.generate(crossAxisCount * mainAxisCount, (index) => EmptySW());
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('screen', json.encode(items));
  }

  Future<void> _retrieveList() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final String? res = sp.getString('screen');
    if(res != null && res.isNotEmpty){
      items = json.decode(res);
    }
  }

  void _toggleModes() {
    setState(() {
      _editMode = !_editMode;
    });
  }

  void _showPopupMenu(int item) async {
    String? dropdownValue;
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter localState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String?>(
                    value: dropdownValue,
                    hint: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Select'),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'time', child: Text('Time'),),
                      DropdownMenuItem(value: 'spacing', child: Text('Spacing'),),
                      DropdownMenuItem(value: 'deals', child: Text('Game Deals'),),
                    ], 
                    onChanged: (String? val) {
                      localState(() {
                        dropdownValue = val;
                      });
                      setState(() {
                        switch (val) {
                          case 'spacing':
                            items[item] = SpacingSW();
                            break;
                          case 'time':
                            items[item] = TimeSW();
                            break;
                          case 'deals':
                            items[item] = GameDealsSW();
                            break;
                          default:
                            print(val);
                        }
                      });
                    })
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        icon: Icons.settings,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.fullscreen),
            label: 'FullScreen Toggle',
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            onTap: _fullScreenToggle
          ),
          SpeedDialChild(
            child: const Icon(Icons.cancel),
            label: 'Clear',
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            onTap: _clearList
          ),
          SpeedDialChild(
            child: const Icon(Icons.save),
            label: 'Save',
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            onTap: _saveList
          ),
          SpeedDialChild(
            child: const Icon(Icons.edit),
            label: 'Toggle Modes',
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            onTap: _toggleModes
          ),
        ],
      ),
      body: _editMode ? _buildEdit() : _buidView()
    );
  }

  Widget _buildEdit() {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width/crossAxisCount;
    final height = mediaQuery.size.height/mainAxisCount;
    return ReorderableGridView.count(
        childAspectRatio: width/height,
        crossAxisCount: crossAxisCount, 
        onReorder: _onReorder, 
        children: items.asMap().entries.map((item){
          return GestureDetector(
            onTap: () => _showPopupMenu(item.key),
            key: ValueKey(item.key),
            child: Card(
              child: Center(
                child: item.value.editWidget,
              ),
            ),
          );
        }).toList(),
      );
  }

  Widget _buidView() {
    final mediaQuery = MediaQuery.of(context);

    return SizedBox(
      height: mediaQuery.size.height,
      width: mediaQuery.size.width,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        ...viewColumns()
      ],),
    );
  }

  List<Widget> viewColumns() {
    List<Column> itemColumns = [];
    List<List<Widget>> itemIndexes = [];
    for (var i = 0; i < crossAxisCount; i++) {
      itemIndexes.add([]);
    }
    for (var i = 0; i < (items.length/crossAxisCount); i++) {
      for (var j = 0; j < crossAxisCount; j++) {
        itemIndexes[j].add(items[(crossAxisCount*i)+j].widget);
      }
    }
    for (var i = 0; i < crossAxisCount; i++) {
      itemColumns.add(Column(
        children: [
          ...itemIndexes[i]
        ],
      ));
    }
    return itemColumns;
  }

}