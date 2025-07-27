import 'package:flutter/material.dart';
import 'package:hotelbooking/app/core/widgets/widget_support.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
          child: Image.asset(
            'images/home.jpg',
            width: MediaQuery.of(context).size.width,
            height: 280,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 40.0, left: 20.0),
          width: MediaQuery.of(context).size.width,
          height: 280,
          decoration: const BoxDecoration(
            color: Color.fromARGB(33, 0, 0, 0),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white),
                  const SizedBox(width: 10.0),
                  Text('India, Delhi', style: AppWidget.whitetextstyle(20.0)),
                ],
              ),
              const SizedBox(height: 25),
              Text(
                'Hey, Sourav Tell us where you wants to go!',
                style: AppWidget.whitetextstyle(25.0),
              ),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.only(right: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(100, 255, 255, 255),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    hintText: 'Search Places...',
                    hintStyle: AppWidget.whitetextstyle(20.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
