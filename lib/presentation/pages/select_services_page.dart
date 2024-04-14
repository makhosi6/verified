import 'package:flutter/material.dart';
import 'package:verified/globals.dart';
import 'package:verified/presentation/pages/confirm_details_page.dart';
import 'package:verified/presentation/pages/search_options_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/error_warning_indicator.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';

class SelectServicesPage extends StatefulWidget {
  const SelectServicesPage({super.key});

  @override
  State<SelectServicesPage> createState() => _SelectServicesPageState();
}

class _SelectServicesPageState extends State<SelectServicesPage> {
  Map selectedValues = {};

  var options = ['Id Number/Phone', 'Qualifications', 'Criminal', 'Credit check', 'All'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const AppErrorWarningIndicator(),
              SliverAppBar(
                stretch: true,
                onStretchTrigger: () async {},
                surfaceTintColor: Colors.transparent,
                stretchTriggerOffset: 300.0,
                expandedHeight: 90.0,
                flexibleSpace: AppBar(
                  automaticallyImplyLeading: true,
                  title: const Text('Search'),
                ),
                leadingWidth: 80.0,
                leading: VerifiedBackButton(
                  key: const Key('capture-details-page-back-btn'),
                  onTap: () => Navigator.pop(context),
                  isLight: true,
                ),
                actions: [
                  ActionButton(
                    key: const Key('go-to-search-btn'),
                    tooltip: 'Go to Search Page',
                    iconColor: Colors.black,
                    bgColor: Colors.white,
                    onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const SearchOptionsPage(),
                      ),
                    ),
                    icon: Icons.person_2_outlined,
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => UnconstrainedBox(
                    child: Container(
                      width: MediaQuery.of(context).size.width - primaryPadding.horizontal,
                      constraints: appConstraints,
                      padding: EdgeInsets.only(bottom: primaryPadding.bottom * 3, top: primaryPadding.top * 3),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: primaryPadding.bottom),
                            child: Text(
                              'Please type a phone/id number and click send to verify. Ensure accuracy and trust in your data effortlessly. ',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: neutralDarkGrey,
                                fontSize: 14.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                            width: 40,
                          ),

                          ///
                          ...options.map(
                            (name) {
                              String key = name.toLowerCase().trim().replaceAll(' ', '_').replaceAll('/', '_');

                              return Padding(
                                padding: EdgeInsets.only(bottom: primaryPadding.bottom),
                                child: ListViewAsSwitch(
                                  name: name,
                                  value: (selectedValues[key] ?? false),
                                  didChange: (value) {
                                    setState(() {
                                      if (key == 'all') {
                                        for (var i = 0; i < options.length; i++) {
                                          var optName = options[i];
                                          selectedValues.addAll({
                                            optName.toLowerCase().trim().replaceAll(' ', '_').replaceAll('/', '_'):
                                                value
                                          });
                                        }
                                      } else {
                                        selectedValues.addAll({key: value});

                                        if (value == false) {
                                          selectedValues.addAll({'all': value});
                                        }
                                      }
                                    });
                                    print('$selectedValues');
                                  },
                                ),
                              );
                            },
                          ),

                          ///
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: BaseButton(
                              key: UniqueKey(),
                              onTap: () => navigate(context, page: ConfirmDetailsPage()),
                              label: 'Next',
                              color: neutralGrey,
                              hasIcon: false,
                              bgColor: primaryColor,
                              buttonIcon: Icon(
                                Icons.lock_outline,
                                color: primaryColor,
                              ),
                              buttonSize: ButtonSize.large,
                              hasBorderLining: false,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  childCount: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListViewAsSwitch extends StatelessWidget {
  final String name;
  final bool value;
  final Widget? leading;
  final Function(bool) didChange;
  const ListViewAsSwitch({
    super.key,
    required this.name,
    required this.value,
    this.leading,
    required this.didChange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: leading,
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Switch.adaptive(
          value: value,
          onChanged: didChange,
        ),
      ),
    );
  }
}
