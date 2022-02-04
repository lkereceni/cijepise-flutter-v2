import 'package:cijepise_flutter_2/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:cijepise_flutter_2/models/models.dart';
import 'package:cijepise_flutter_2/services/networking.dart';
import 'package:cijepise_flutter_2/widgets/widgets.dart';
import 'screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Palette.lightBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                FutureBuilder<List<CovidInfo>>(
                  future: fetchCovidInfo(http.Client()),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Palette.darkBlue,
                          strokeWidth: 3.0,
                        ),
                      );
                    } else {
                      var newCases = snapshot.data!.last.confirmed! -
                          snapshot.data![snapshot.data!.length - 2].confirmed!;
                      var deaths = snapshot.data!.last.deaths! -
                          snapshot.data![snapshot.data!.length - 2].deaths!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'KORONAVIRUS',
                            style: TextStyle(
                              fontSize: 11.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CovidInfoContainer(
                                text: newCases.toString(),
                                label: 'novi slučajevi',
                                iconAsset: 'assets/icons/coronavirus.svg',
                              ),
                              CovidInfoContainer(
                                text: deaths.toString(),
                                label: 'umrli',
                                iconAsset: 'assets/icons/death.svg',
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 24.0),
                Container(
                  width: size.width,
                  height: 280.0,
                  decoration: BoxDecoration(
                    color: Palette.darkBlue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/coronavirus.svg',
                              width: 100.0,
                              height: 100.0,
                              color: Palette.green,
                            ),
                            Column(
                              children: const [
                                Text(
                                  'COVID-19',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                                Text(
                                  'cijepljenje',
                                  style: TextStyle(
                                    color: Palette.green,
                                    fontSize: 26.0,
                                    letterSpacing: 1.8,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        SizedBox(
                          width: 220.0,
                          height: 60.0,
                          child: TextButton(
                            child: const Text(
                              'Naruči se',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(60.0),
                              ),
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AppointmentScreen(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'O COVID-19',
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    SizedBox(
                      width: width,
                      height: 60.0,
                      child: ElevatedButton(
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/info.svg',
                              width: 55.0,
                              height: 55.0,
                            ),
                            const Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Osnovne informacije',
                                  style: TextStyle(
                                    color: Palette.darkGrey,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BasicInfoScreen(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: width,
                      height: 60.0,
                      child: ElevatedButton(
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/microscope.svg',
                              width: 45.0,
                              height: 45.0,
                            ),
                            const Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Testiranje',
                                  style: TextStyle(
                                    color: Palette.darkGrey,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TestingScreen(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: width,
                      height: 60.0,
                      child: ElevatedButton(
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/mask.svg',
                              color: Palette.darkBlue,
                              width: 60.0,
                              height: 60.0,
                            ),
                            const Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Kako se zaštititi?',
                                  style: TextStyle(
                                    color: Palette.darkGrey,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PreventingScreen(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
