import 'package:covid/view/countries_list.dart';
import 'package:covid/view/services/states_sevices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

import '../models/WorldStatesModel.dart';

class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({Key? key}) : super(key: key);

  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: Duration(seconds: 3), vsync: this)
        ..repeat();
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
              ),
              Expanded(
                child: FutureBuilder(
                    future: statesServices.getStates(),
                    builder:
                        (context, AsyncSnapshot<WorldStatesModel> snapshot) {
                      if (!(snapshot.hasData)) {
                        return Expanded(
                            child: SpinKitFadingCircle(
                          color: Colors.blue,
                          size: 50.0,
                          controller: _controller,
                        ));
                      } else {
                        return Column(
                          children: [
                            PieChart(
                              dataMap: {
                                'Total': double.parse(
                                    snapshot.data!.cases!.toString()),
                                'Recover': double.parse(
                                    snapshot.data!.recovered!.toString()),
                                'deaths': double.parse(
                                    snapshot.data!.deaths!.toString()),
                              },
                              chartValuesOptions: ChartValuesOptions(
                                showChartValuesInPercentage: true,
                              ),
                              chartRadius:
                                  MediaQuery.of(context).size.width / 3.2,
                              legendOptions: LegendOptions(
                                  legendPosition: LegendPosition.left),
                              animationDuration: Duration(milliseconds: 1200),
                              chartType: ChartType.ring,
                              colorList: [
                                Color(0xFF4285F4),
                                Color(0xFF1aa260),
                                Color(0xFFde5246),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.height * .06),
                              child: Card(
                                child: Column(
                                  children: [
                                    ReuseAbleRow(
                                        title: 'case',
                                        value: snapshot.data!.cases.toString()),
                                    ReuseAbleRow(
                                        title: 'Recovered',
                                        value: snapshot.data!.recovered
                                            .toString()),
                                    ReuseAbleRow(
                                        title: 'deaths',
                                        value:
                                            snapshot.data!.deaths!.toString()),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CountriesList()));
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color(0xFF1aa260),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(child: Text('Track countries')),
                              ),
                            ),
                          ],
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReuseAbleRow extends StatelessWidget {
  String title, value;
  ReuseAbleRow({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Divider(),
        ],
      ),
    );
  }
}
