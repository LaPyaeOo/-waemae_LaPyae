import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'constants/colors.dart';
import 'constants/font_style.dart';
import 'widgets/search_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.client});
  final ValueNotifier<GraphQLClient> client;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  //MultiSelectDialog({required this.items, required this.initialSelectedValues});
  MultiSelectDialog({required this.items,this.initialSelectedValues = const {}});

  final List<MultiSelectDialogItem<V>> items;
  final Set<V> initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = Set<V>();

  void initState() {
    super.initState();
    _selectedValues.addAll(widget.initialSelectedValues);
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  // *********************** Alert_dialog build
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      contentPadding: EdgeInsets.only(left: 14.0,top: 24.0,right: 14.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.only(left: 2),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        Center(
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            width: 200,
            child: SearchButton(
              buttonLabel: 'search',
              onPress: _onSubmitTap,
            ),
          ),
        )
      ],
    );
  }

  // *********************** Check_box
  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return Card(
      margin: EdgeInsets.only(bottom: 15),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: Colors.black,
            )),
        child: CheckboxListTile(
          checkColor: Colors.black,
          activeColor: Colors.black,
          value: checked,
          title: Text(item.label),
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (checked) =>
              _onItemCheckedChange(item.value, checked ?? false),
        ),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final String _query = """query ExampleQuery {
  jobs {
  name
  location
  days
}
}""";
  List rv = [];
  List dayRv = [];
  List<MultiSelectDialogItem<int>>daysFromWeek = [];
  final week = {
    1: 'Sunday',
    2: 'Monday',
    3: 'Tuesday',
    4: 'Wedneday',
    5: 'Thursday',
    6: 'Friday',
    7: 'Saturaday',
  };
  List<String> workingDays = [];
  void fetchDays (){
    for (int dayIndex in week.keys){
        daysFromWeek.add(MultiSelectDialogItem(dayIndex, week[dayIndex].toString()));
    }
  }
  // *********************** ShowMultiSelect when ontap button
  void _showMultiSelect(BuildContext context) async {
    // final items = <MultiSelectDialogItem>[
    //   MultiSelectDialogItem(1, 'Sunday'),
    //   MultiSelectDialogItem(2, 'Monday'),
    //   MultiSelectDialogItem(3, 'Tuesday'),
    //   MultiSelectDialogItem(4, 'Wednesday'),
    //   MultiSelectDialogItem(5, 'Thursday'),
    //   MultiSelectDialogItem(6, 'Friday'),
    //   MultiSelectDialogItem(7, 'Saturaday'),
    // ];
    daysFromWeek = [];
    fetchDays();
    final items = daysFromWeek;


    final selectedValues = await showDialog<Set>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          //initialSelectedValues: [].toSet(),
        );
      },
    );
    print(selectedValues);
    getDaysName(selectedValues);
  }

  // *********************** get days name list from week
  void getDaysName(var days){
    setState(() {
      if(days != null){
        for(int index in days.toList()){
          workingDays.add(week[index].toString());
          print(week[index].toString());
        }
          print(workingDays.toString());
      }
    });
  }


  @override
  void initState() {
    // Operation operation = Operation(document: gql(_query),operationName: 'listenWorkingDays');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BgColor,
        body: SafeArea(
          /***************************************************
              Edit this part out to start on your assignments
           ***************************************************/
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(left: 20.0, top: 10.0),
                  child: Text(
                    "Jobs",
                    style: custTitleTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              SizedBox(
                height: 15.0,
              ),
              Center(
                  child: SearchButton(
                buttonLabel: 'filter search',
                onPress: () {
                  _showMultiSelect(context);
                },
              )),
              Query(
                options: QueryOptions(document: gql(_query)),
                builder: (QueryResult result, {fetchMore, refetch}) {
                  if (result.isLoading) {
                    return Container(
                      child: Center(
                        child: Text('Loading'),
                      ),
                    );
                  }
                  if (result.hasException) {
                    return Text('Something Wrong');
                  }
                  final Map<String, dynamic> receiveData = result.data ?? {};
                  //print('****************${receiveData.toString()}');
                  //print('@@@@@@@@@${receiveData['jobs'].toString()}');

                  rv = receiveData['jobs'];
                  print('API days >>>>>>>>> ${rv.length.toString()}');

                  return Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(8.0),
                      itemCount: rv.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin:
                              EdgeInsets.only(left: 10.0, top: 15.0, right: 10),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(rv[index]['name'].toString(),
                                    style: custTitleTextStyle.copyWith(
                                      color: SecondaryTextColor,
                                      fontSize: 18,
                                    )),
                                Container(
                                    margin:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.1),
                                    ),
                                    child:
                                        Text(rv[index]['location'].toString(),
                                            style: custTextStyle.copyWith(
                                              fontSize: 16,
                                              color: PrimaryTextColor,
                                              fontFamily: 'Source_Code_Pro',
                                            ))),
                                Row(
                                  children: [
                                    Text(
                                      'Working Days:',
                                      style: custTextStyle.copyWith(
                                        fontSize: 14,
                                        color: PrimaryTextColor,
                                      ),
                                    ),
                                    Row(
                                      children: rv[index]['days']
                                          .map<Widget>(
                                            (e) => Text(
                                              ' ${e.toString()}, ',
                                              style: custTextStyle.copyWith(
                                                fontSize: 14,
                                                color: SecondaryTextColor,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              )
            ],
          ),

          /*****************************************************/
        ));
  }
}
