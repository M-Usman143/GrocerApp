import 'package:flutter/material.dart';
import 'faq_data.dart';

class FAQScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // About Us Section
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "About Us",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // FAQ List
            ListView.builder(
              shrinkWrap: true, // Makes the list take only as much space as it needs
              physics: NeverScrollableScrollPhysics(), // Disable scrolling in ListView inside SingleChildScrollView
              itemCount: faqList.length,
              itemBuilder: (context, index) {
                final faq = faqList[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 1),
                  child: ExpansionTile(
                    title: Text(
                      faq.question,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children: [
                      SizedBox(
                        height: 150,
                        child: SingleChildScrollView(
                          child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            faq.answer,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),

            // Delivery Section (same structure)
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Delivery",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: deliveryList.length,
          itemBuilder: (context, index) {
            final faq = deliveryList[index];
            return Container(
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 1),
                child: ExpansionTile(
                  title: Text(
                    faq.question,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    SizedBox(
                      height: 150,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            faq.answer,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

            // Delivery Section (same structure)
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Delivery",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: deliveryList.length,
              itemBuilder: (context, index) {
                final faq = deliveryList[index];
                return Container(
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 1),
                    child: ExpansionTile(
                      title: Text(
                        faq.question,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: [
                        SizedBox(
                          height: 150,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                faq.answer,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),


            // Delivery Section (same structure)
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Delivery",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: deliveryList.length,
              itemBuilder: (context, index) {
                final faq = deliveryList[index];
                return Container(
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 1),
                    child: ExpansionTile(
                      title: Text(
                        faq.question,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: [
                        SizedBox(
                          height: 150,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                faq.answer,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),


            // Delivery Section (same structure)
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Delivery",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: deliveryList.length,
              itemBuilder: (context, index) {
                final faq = deliveryList[index];
                return Container(
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 1),
                    child: ExpansionTile(
                      title: Text(
                        faq.question,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: [
                        SizedBox(
                          height: 150,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                faq.answer,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),



            // Delivery Section (same structure)
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Delivery",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: deliveryList.length,
              itemBuilder: (context, index) {
                final faq = deliveryList[index];
                return Container(
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 1),
                    child: ExpansionTile(
                      title: Text(
                        faq.question,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: [
                        SizedBox(
                          height: 150,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                faq.answer,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),




            // Delivery Section (same structure)
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Delivery",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: deliveryList.length,
              itemBuilder: (context, index) {
                final faq = deliveryList[index];
                return Container(
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 1),
                    child: ExpansionTile(
                      title: Text(
                        faq.question,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: [
                        SizedBox(
                          height: 150,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                faq.answer,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),




            // Delivery Section (same structure)
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Delivery",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: deliveryList.length,
              itemBuilder: (context, index) {
                final faq = deliveryList[index];
                return Container(
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 1),
                    child: ExpansionTile(
                      title: Text(
                        faq.question,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: [
                        SizedBox(
                          height: 150,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                faq.answer,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),




            // Delivery Section (same structure)
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Delivery",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: deliveryList.length,
              itemBuilder: (context, index) {
                final faq = deliveryList[index];
                return Container(
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 1),
                    child: ExpansionTile(
                      title: Text(
                        faq.question,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: [
                        SizedBox(
                          height: 150,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                faq.answer,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),




            // Delivery Section (same structure)
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Delivery",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: deliveryList.length,
              itemBuilder: (context, index) {
                final faq = deliveryList[index];
                return Container(
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 1),
                    child: ExpansionTile(
                      title: Text(
                        faq.question,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: [
                        SizedBox(
                          height: 150,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                faq.answer,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),




            // Delivery Section (same structure)
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Delivery",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: deliveryList.length,
              itemBuilder: (context, index) {
                final faq = deliveryList[index];
                return Container(
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 1),
                    child: ExpansionTile(
                      title: Text(
                        faq.question,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: [
                        SizedBox(
                          height: 150,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                faq.answer,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),



            // Delivery Section (same structure)
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Delivery",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: deliveryList.length,
              itemBuilder: (context, index) {
                final faq = deliveryList[index];
                return Container(
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 1),
                    child: ExpansionTile(
                      title: Text(
                        faq.question,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: [
                        SizedBox(
                          height: 150,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                faq.answer,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),


            // Delivery Section (same structure)
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Delivery",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: deliveryList.length,
              itemBuilder: (context, index) {
                final faq = deliveryList[index];
                return Container(
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 1),
                    child: ExpansionTile(
                      title: Text(
                        faq.question,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: [
                        SizedBox(
                          height: 150,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                faq.answer,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),






          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.orange),
        onPressed: () {
          Navigator.pop(context); // Navigates back
        },
      ),
      title: Text(
        "FAQs",
        style: TextStyle(color: Colors.black),
      ),
      elevation: 1.0,
    );
  }
}
