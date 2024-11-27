import 'package:flutter/material.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/utils/const/widgets.dart';
import '../model/property_details_model.dart';

class NearByPlacesWidget extends StatelessWidget {
  final List<NearByPlaces> nearByPlaces;

  const NearByPlacesWidget({super.key, required this.nearByPlaces});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: DefaultTabController(
        length: nearByPlaces.length,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                isScrollable: true,
                labelColor: Constants.primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Constants.primaryColor,
                tabs: _headerTabs(),
                padding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: _tabBarViews(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Tab> _headerTabs() {
    return nearByPlaces
        .map(
          (e) => Tab(text: e.placeType),
        )
        .toList();
  }

  List<Widget> _tabBarViews() {
    return nearByPlaces
        .map(
          (e) => Container(
            padding: const EdgeInsets.only(top: 10),
            child: ListView.separated(
              itemCount: e.placeList?.length ?? 0,
              padding: EdgeInsets.zero,
              separatorBuilder: (context, index) => const SizedBox(
                height: 5,
              ),
              itemBuilder: (context, index) {
                final data = e.placeList?[index];
                if (data == null) {
                  return const SizedBox.shrink();
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: screenWidth * 0.75,
                        child: Text(
                          data.name ?? '',
                          style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 14),
                        )),
                    if (data.distance != null)
                      Text(
                        '${data.distance} km',
                        style: TextStyle(color: CustomTheme.appThemeContrast2, fontSize: 14),
                      ),
                  ],
                );
              },
            ),
          ),
        )
        .toList();
  }
}
