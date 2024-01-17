import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var baseTheme = ThemeData(
      brightness: Brightness.light,
      fontFamily: 'SWFont',
    );

    ThemeData theme = ThemeData.light(
      useMaterial3: true,
    ).copyWith(
      appBarTheme: const AppBarTheme(centerTitle: true),
      // textTheme: GoogleFonts.ibmPlexSerifTextTheme(baseTheme.textTheme)
    );

    /// HelveticaNeue-Light
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      title: 'Smart Bank App',
      home: const MainActivity(),
    );
  }
}

class MainActivity extends StatelessWidget {
  const MainActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'DONE',
                style: TextStyle(
                  color: Color(0xFF216A9A),
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: const Color(0xFFE0CE65),
              height: 2.0,
            ),
          ),
          title: Text(
            'One-Off Payment'.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          // leading: IconButton(
          //   icon: const Icon(Icons.close, color: Colors.black87),
          //   onPressed: () => Navigator.pop(context),
          // ),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          color: const Color.fromARGB(245, 234, 232, 232),
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Container(
                // color: Colors.amber,
                height: MediaQuery.of(context).size.height,
                // width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          child: const Image(
                            image: AssetImage('assets/icons/success.ce12a2ac.png'),
                            fit: BoxFit.fill,
                            width: 80,
                            height: 80,
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            // color: Colors.transparent,
                            color: Colors.transparent,
                            border: Border.all(color: Colors.white, width: 6),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                          clipBehavior: Clip.none,
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'R16 800.00',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    paymentDetail('From', 'EveryDay account', '5100 2058 065'),
                    paymentDetail('To', 'Brando Dreyer', '9384672580'),
                    paymentDetail('Date & Time', '05 Jan 2024, 18:51'),
                    paymentDetail('My reference', 'Brando Dreyer'),
                    paymentDetail('Their reference', 'XABISILE NDONDO'),
                    paymentDetail(
                        'Type',
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Immediate EFT',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2B2B2B),
                                ),
                              ),
                              TextSpan(
                                text: ' \u2122',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF858585),
                                ),
                              ),
                            ],
                          ),
                        ),
                        '(Within 30 minutes)'),
                    Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsets.symmetric(vertical: 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.0),
                          border: Border.all(
                            color: const Color(0xFF2B2B2B),
                            width: 1,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'SAVE TO MY BENEFICIARY LIST',
                            style: TextStyle(color: Color(0xFF2B2B2B), fontWeight: FontWeight.w500),
                          ),
                        )
                        // child: OutlinedButton(
                        //   style: OutlinedButton.styleFrom(
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(3.0),
                        //     ),
                        //     padding: const EdgeInsets.all(0),
                        //     side: const BorderSide(width: 1, color: Colors.black),
                        //   ),
                        //   onPressed: () {
                        //     // TODO: Implement save beneficiary action
                        //   },
                        //   child: const ,
                        // ),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget paymentDetail(String title, dynamic value, [String? explainer]) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.loose,
          child: SizedBox(
            width: double.infinity,
            child: Text(
              title,
              style: const TextStyle(color: Color(0xFF858585), fontSize: 14),
            ),
          ),
        ),
        Flexible(
          fit: FlexFit.loose,
          flex: 1,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                value is! String
                    ? value
                    : Text(
                        value,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2B2B2B),
                        ),
                      ),
                if (explainer != null)
                  Text(
                    explainer,
                    style: const TextStyle(color: Color(0xFF858585), fontSize: 14),
                  )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
