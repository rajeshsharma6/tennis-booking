import 'package:flutter/material.dart';
import 'package:tennis_booking/main.dart'; // For color constants

class BookingDetailsStep extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onContinue;

  const BookingDetailsStep({
    super.key,
    required this.onBack,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Back Button Logic
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: onBack,
              ),
              const Text(
                "Confirm Booking",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Previous Court Visualization
                Container(
                  height: 200,
                  width: 354,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    border: Border.all(color: secondaryColor, width: 3),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            //LEFT ALLY
                            height: 25,
                            width: 174,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              border: Border.all(
                                color: secondaryColor,
                                width: 3,
                              ),
                            ),
                          ),
                          Container(
                            //RIGHT ALLY
                            height: 25,
                            width: 174,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              border: Border.all(
                                color: secondaryColor,
                                width: 3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            //LEFT No mans Land
                            height: 144,
                            width: 87,
                            decoration: BoxDecoration(
                              color: accentColor,
                              border: Border.all(
                                color: secondaryColor,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: backgroundColor,
                                    shape: const CircleBorder(),
                                  ),
                                  onPressed: () {},
                                  child: const Icon(
                                    Icons.person,
                                    color: accentColor,
                                  ),
                                ),
                                const SizedBox(height: 7),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                //DEUCE SERVICE BOX
                                height: 72,
                                width: 87,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  border: Border.all(
                                    color: secondaryColor,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: accentColor,
                                      shape: const CircleBorder(),
                                    ),
                                    onPressed: () {},
                                    child: const Icon(
                                      Icons.add,
                                      color: backgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 72,
                                width: 87,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  border: Border.all(
                                    color: secondaryColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: 72,
                                width: 87,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  border: Border.all(
                                    color: secondaryColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                              Container(
                                height: 72,
                                width: 87,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  border: Border.all(
                                    color: secondaryColor,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: accentColor,
                                      shape: const CircleBorder(),
                                    ),
                                    onPressed: () {},
                                    child: const Icon(
                                      Icons.add,
                                      color: backgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 144,
                            width: 87,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              border: Border.all(
                                color: secondaryColor,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 7),
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: accentColor,
                                    shape: const CircleBorder(),
                                  ),
                                  onPressed: () {},
                                  child: const Icon(
                                    Icons.add,
                                    color: backgroundColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            height: 25,
                            width: 174,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              border: Border.all(
                                color: secondaryColor,
                                width: 3,
                              ),
                            ),
                          ),
                          Container(
                            height: 25,
                            width: 174,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              border: Border.all(
                                color: secondaryColor,
                                width: 3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                      child: Text(
                        'Invited Friends',
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 18,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Container(
                    height: 50,
                    width: 350,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      border: Border.all(color: secondaryColor, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.account_circle_outlined,
                                color: secondaryColor,
                                size: 30,
                              ),
                              const SizedBox(width: 10),

                              const Text(
                                'John Doe',
                                style: TextStyle(color: textColor),
                              ),
                            ],
                          ),

                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: accentColor,
                              shape: const CircleBorder(),
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(25, 25),
                              maximumSize: const Size(25, 25),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {},
                            child: const Icon(
                              Icons.check,
                              color: backgroundColor,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Continue button
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: SizedBox(
                    width: 250,
                    height: 40,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: onContinue,
                      child: const Text(
                        'Confirm Booking',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
