import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'constants/colors.dart';
import 'constants/font_style.dart';
import 'widgets/search_button.dart';

class MyHomePage extends StatelessWidget {
  final String _query = """query ExampleQuery {
  jobs {
  name
  location
  days
}
}""";

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
              Center(child: SearchButton(onPress: (){
                print('onPress');
              },)),
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
                  print('****************${receiveData.toString()}');
                  print('@@@@@@@@@${receiveData['jobs'].toString()}');

                  List rv = receiveData['jobs'];
                  //print('!!!!!!!!!!!!!!!!!!!! ${rv[1]}');
                  // for (var value in rv) {
                  //   print('!!!!!!!!!!!${value['days']}');
                  // }
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
                                          .map<Widget>((e) => Text(
                                                ' ${e.toString()}, ',
                                                style: custTextStyle.copyWith(
                                                  fontSize: 14,
                                                  color: SecondaryTextColor,
                                                ),
                                              ),)
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
