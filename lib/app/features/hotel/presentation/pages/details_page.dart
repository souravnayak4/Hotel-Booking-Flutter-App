import 'package:flutter/material.dart';
import 'package:hotelbooking/app/core/widgets/widget_support.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Top Image with Back Button
            Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.5,
                  child: PageView(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                        child: Image.asset(
                          'images/hotel1.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                        child: Image.asset(
                          'images/hotel2.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                        child: Image.asset(
                          'images/hotel3.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),

                // Back Button
                Positioned(
                  top: 50,
                  left: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),

                // Static Dots (Not Dynamic)
                Positioned(
                  bottom: 15,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.circle, size: 10, color: Colors.white),
                      SizedBox(width: 6),
                      Icon(Icons.circle, size: 10, color: Colors.white54),
                      SizedBox(width: 6),
                      Icon(Icons.circle, size: 10, color: Colors.white54),
                    ],
                  ),
                ),
              ],
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  //  Title and Price
                  Text('Sea Beach', style: AppWidget.headelinetextstyle(27)),
                  const SizedBox(height: 5),
                  Text('\$30', style: AppWidget.normaltextstyle(24)),

                  const SizedBox(height: 10),
                  Divider(thickness: 2),

                  const SizedBox(height: 15),
                  Text(
                    'What this place offers',
                    style: AppWidget.headelinetextstyle(22),
                  ),
                  const SizedBox(height: 20),

                  //  Two Column Static Layout
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //  Column 1
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.wifi, color: Color(0xFF0766B3)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Wi-Fi',
                                    style: AppWidget.normaltextstyle(18),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),

                            Row(
                              children: [
                                Icon(Icons.kitchen, color: Color(0xFF0766B3)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Kitchen',
                                    style: AppWidget.normaltextstyle(18),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),

                            Row(
                              children: [
                                Icon(Icons.bathtub, color: Color(0xFF0766B3)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Bathroom',
                                    style: AppWidget.normaltextstyle(18),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),

                            Row(
                              children: [
                                Icon(Icons.pool, color: Color(0xFF0766B3)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Swimming Pool',
                                    style: AppWidget.normaltextstyle(18),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),

                            Row(
                              children: [
                                Icon(Icons.ac_unit, color: Color(0xFF0766B3)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Air Conditioning',
                                    style: AppWidget.normaltextstyle(18),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),

                            Row(
                              children: [
                                Icon(Icons.pets, color: Color(0xFF0766B3)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Pet Friendly',
                                    style: AppWidget.normaltextstyle(18),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),

                            Row(
                              children: [
                                Icon(
                                  Icons.local_laundry_service,
                                  color: Color(0xFF0766B3),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Laundry',
                                    style: AppWidget.normaltextstyle(18),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 20),

                      //  Column 2
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.tv, color: Color(0xFF0766B3)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'HDTV',
                                    style: AppWidget.normaltextstyle(18),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),

                            Row(
                              children: [
                                Icon(Icons.food_bank, color: Color(0xFF0766B3)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Refrigerator',
                                    style: AppWidget.normaltextstyle(18),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),

                            Row(
                              children: [
                                Icon(
                                  Icons.local_parking,
                                  color: Color(0xFF0766B3),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Parking',
                                    style: AppWidget.normaltextstyle(18),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),

                            Row(
                              children: [
                                Icon(Icons.local_bar, color: Color(0xFF0766B3)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Mini Bar',
                                    style: AppWidget.normaltextstyle(18),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),

                            Row(
                              children: [
                                Icon(
                                  Icons.local_cafe,
                                  color: Color(0xFF0766B3),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Coffee Maker',
                                    style: AppWidget.normaltextstyle(18),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),

                            Row(
                              children: [
                                Icon(
                                  Icons.fitness_center,
                                  color: Color(0xFF0766B3),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Gym',
                                    style: AppWidget.normaltextstyle(18),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),

                            Row(
                              children: [
                                Icon(
                                  Icons.room_service,
                                  color: Color(0xFF0766B3),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Room Service',
                                    style: AppWidget.normaltextstyle(18),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Divider(thickness: 2.0),
                  Text(
                    'About this place',
                    style: AppWidget.headelinetextstyle(20),
                  ),
                  Text(
                    'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
                  ),
                  const SizedBox(height: 20),
                  Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      height: 400,
                      width: MediaQuery.of(context).size.width,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            '\$20 for 1 night',
                            style: AppWidget.headelinetextstyle(20.0),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Check-in Date ',
                            style: AppWidget.normaltextstyle(20.0),
                          ),
                          Divider(),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Icon(
                                  Icons.calendar_month,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                '12,Apr 2025 ',
                                style: AppWidget.normaltextstyle(20.0),
                              ),
                            ],
                          ),
                          //chekout
                          SizedBox(height: 10),
                          Text(
                            'Check-out Date ',
                            style: AppWidget.normaltextstyle(20.0),
                          ),
                          Divider(),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Icon(
                                  Icons.calendar_month,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                '12,Apr 2025 ',
                                style: AppWidget.normaltextstyle(20.0),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Number of Guest',
                            style: AppWidget.normaltextstyle(20.0),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFececf8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '1',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadiusDirectional.circular(
                                10,
                              ),
                            ),

                            child: Center(
                              child: Text(
                                'Book Now',
                                style: AppWidget.whitetextstyle(20.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
