// Flutter code sample for ExpansionPanelList

// Here is a simple example of how to implement ExpansionPanelList.

import 'package:flutter/material.dart';

// stores ExpansionPanel state information
class CovidItem {
  CovidItem({
    @required this.expandedValue,
    @required this.headerValue,
    this.isExpanded = false,
  });

  Widget expandedValue;
  String headerValue;
  bool isExpanded;
}

class CovidPage extends StatefulWidget {
  CovidPage(@required this.data);
  final List<CovidItem> data;

  @override
  _CovidPageState createState() => _CovidPageState();
}

class _CovidPageState extends State<CovidPage> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Container(
          child: _buildPanel(),
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          widget.data[index].isExpanded = !isExpanded;
        });
      },
      children: widget.data.map<ExpansionPanel>((CovidItem item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: item.expandedValue,
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
