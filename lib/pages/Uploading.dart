import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Models/model.dart';

class UploadDataPage extends StatefulWidget {
  @override
  _UploadDataPageState createState() => _UploadDataPageState();
}

class _UploadDataPageState extends State<UploadDataPage> {
  bool isUploading = false;

  Future<void> uploadDummyData() async {
    final databaseRef = FirebaseDatabase.instance.ref("categories");
    List<Categories> categoriesList = getdummydata();
    List<Map<String, dynamic>> jsonData =
    categoriesList.map((category) => category.toJson()).toList();

    setState(() {
      isUploading = true;
    });

    try {
      await databaseRef.set({"categories": jsonData}); // Upload the formatted data
      setState(() {
        isUploading = false; // Hide loading indicator
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data uploaded successfully!")),
      );
    } catch (error) {
      setState(() {
        isUploading = false; // Hide loading indicator
      });

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading data: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Dummy Data"),
      ),
      body: Center(
        child: isUploading
            ? CircularProgressIndicator()
            : ElevatedButton(
          onPressed: () async {
            await uploadDummyData();
          },
          child: Text("Upload Data to Firebase"),
        ),
      ),
    );
  }
}


List<Categories> getdummydata() {
  return [
    Categories(
      cat_id: "cat_1",
      name: 'Breakfast Essentails',
      image: 'assets/categoryimages/bread.jpeg',
      subheading: 'All your breakfast needs fromm eggs to cheese',
      products: [
        Products( pro_id:"eggs", name: 'Eggs', image: 'assets/subcategory/eggs.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: 'Rs 552' , pre_price: '2.99' , weight: '20g'
                , discount: '2.99', image: 'assets/subcategory/chicken.jpeg', var_id: 'varient1_pro1_cat1' , isTrending: true),
            Variant(name: 'Brown Bread', curr_price: 'Rs 225' , pre_price: '2.99' , weight: '15g'
                , discount: '2.99', image: 'assets/subcategory/liquids.jpeg', var_id: 'varient2_pro1_cat1'),
            Variant(name: 'Dawn Bread', curr_price: 'Rs 156' , pre_price: '2.99' , weight: '30g'
                , discount: '2.99', image: 'assets/subcategory/candies.jpeg', var_id: 'varient3_pro1_cat1'),
          ],
        ),

        Products( pro_id:"bread", name: 'Bread & Crumbs', image: 'assets/categoryimages/bread.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro2_cat1'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat1' , isTrending: true),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro2_cat1'),
          ],
        ),

        Products(pro_id:"buns",name: 'Buns', image: 'assets/subcategory/buns.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro3_cat1'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro3_cat1'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro3_cat1'),
          ],
        ),

        Products(pro_id:"roti",name: 'Roti, Pita & Tortillas', image: 'assets/subcategory/roti.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro4_cat1'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro4_cat1'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro4_cat1' , isTrending: true),
          ],
        ),

        Products(pro_id:"cereals",name: 'Cereals', image: 'assets/subcategory/cereals.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro5_cat1'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro5_cat1'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro5_cat1'),
          ],
        ),

        Products(pro_id:"oats",name: 'Oats & Porridge', image: 'assets/subcategory/oats.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro6_cat1'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro6_cat1' , isTrending: true),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro6_cat1'),
          ],
        ),

        Products(pro_id:"cakes",name: 'Cakes', image: 'assets/subcategory/cakesss.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro7_cat1'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro7_cat1' , isTrending: true),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro7_cat1'),
          ],
        ),

        Products(pro_id:"rusks",name: 'Rusks', image: 'assets/subcategory/rusks.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro8_cat1'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro8_cat1'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro8_cat1'),
          ],
        ),

        Products(pro_id:"pasteries",name: 'Pasteries', image: 'assets/subcategory/pasteries.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro9_cat1'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro9_cat1'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro9_cat1'),
          ],
        ),

        Products(pro_id:"jams",name: 'Jams & Marmalades', image: 'assets/subcategory/jam.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro10_cat1'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro10_cat1'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro10_cat1'),
          ],
        ),

        Products(pro_id:"honey",name: 'Honey', image: 'assets/subcategory/honey.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro11_cat1'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro11_cat1'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro11_cat1'),
          ],
        ),

        Products(pro_id:"spread",name: 'Spread', image: 'assets/subcategory/spreads.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro12_cat1'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro12_cat1'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro12_cat1'),
          ],
        ),

        Products(pro_id:"syrups",name: 'Syrups', image: 'assets/subcategory/syrps.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro13_cat1'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro13_cat1'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro13_cat1'),
          ],
        ),

        Products(pro_id:"breakfast_mixes",name: 'Breakfast Mixes', image: 'assets/subcategory/pancakes.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro14_cat1'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro14_cat1'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro14_cat1'),
          ],
        ),
      ],
    ),

    Categories(
        name: 'Milk & Dairy',
        cat_id: "cat_2",
        image: 'assets/categoryimages/milk.jpeg',
        subheading: 'All Sort of milk, cream and cheese',
        products: [
          Products(pro_id:"Raw",name: 'Raw & Fresh Milk', image: 'assets/subcategory/milk.jpeg',
            variants: [
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro1_cat1'),
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro1_cat2'),
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro1_cat2'),
            ],
          ),

          Products(pro_id:"UHT",name: 'UHT Milk', image: 'assets/subcategory/uhtmilk.jpeg',
            variants: [
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro2_cat2'),
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat2'),
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro2_cat2'),
            ],
          ),

          Products(pro_id:"Powdered",name: 'Powdered Milk', image: 'assets/subcategory/powderm.jpeg',
            variants: [
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro3_cat2'),
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro3_cat2'),
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro3_cat2'),
            ],
          ),

          Products(pro_id:"Butter",name: 'Butter', image: 'assets/subcategory/butter.jpeg',
            variants: [
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro4_cat2'),
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro4_cat2'),
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro4_cat2'),
            ],
          ),

          Products(pro_id:"Cream",name: 'Cream', image: 'assets/subcategory/crean.jpeg',
            variants: [
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro5_cat2'),
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro5_cat2'),
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro5_cat2'),
            ],
          ),

          Products(pro_id:"Cheese",name: 'Cheese', image: 'assets/subcategory/cheese.jpeg',
            variants: [
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro6_cat2'),
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro6_cat2'),
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro6_cat2'),
            ],
          ),

          Products(pro_id:"Yogurt",name: 'Yogurt & Lassi', image: 'assets/subcategory/lassi.jpeg',
            variants: [
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro7_cat2'),
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro7_cat2'),
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro7_cat2'),
            ],
          ),

          Products(pro_id:"Flavoured",name: 'Flavoured Milk', image: 'assets/subcategory/flavm.jpeg',
            variants: [
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro8_cat2'),
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro8_cat2'),
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro8_cat2'),
            ],
          ),

          Products(pro_id:"other_Milk",name: 'other Milk', image: 'assets/subcategory/othermilk.jpeg',
            variants: [
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro9_cat2'),
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro9_cat2'),
              Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                  , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro9_cat2'),
            ],
          ),

        ]
    ),

    Categories(
      name: 'Fruits & Vegetables',
      cat_id: "cat_3",
      image: 'assets/categoryimages/vegetables.jpeg',
      subheading: 'Fruits, Vegetables, &Exotic Vegetables',
      products: [
        Products( pro_id:"Vegetables", name: 'Vegetables', image: 'assets/subcategory/veges.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro1_cat3'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro1_cat3'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro1_cat3'),
          ],
        ),

        Products( pro_id:"Fruits", name: 'Fruits', image: 'assets/subcategory/fruits.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro2_cat3'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat3'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro2_cat3'),
          ],
        ),

        Products(pro_id:"Herbs",name: 'Exotic Herbs', image: 'assets/subcategory/herbs.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro2_cat3'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat3'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro2_cat3'),
          ],
        ),


      ],
    ),

    Categories(
      name: 'Meat & Seafood',
      cat_id: "cat_4",
      image: 'assets/categoryimages/meat.jpeg',
      subheading: 'Mutton, Beef, Chicken, Fish',
      products: [
        Products( pro_id:"Chicken", name: 'Chicken', image: 'assets/subcategory/chicken.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro1_cat4'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro1_cat4'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro1_cat4'),
          ],
        ),

        Products( pro_id:"Fish", name: 'Fish & Sea Food', image: 'assets/subcategory/fish.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro2_cat4'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat4'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro2_cat4'),
          ],
        ),

        Products(pro_id:"Mutton",name: 'Mutton', image: 'assets/subcategory/mutton.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro3_cat4'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro3_cat4'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro3_cat4'),
          ],
        ),

        Products(pro_id:"Beef",name: 'Beef', image: 'assets/subcategory/beef.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro4_cat4'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro4_cat4'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro4_cat4'),
          ],
        ),

      ],
    ),

    Categories(
      name: 'Oil, Ghee & Masala',
      cat_id: "cat_5",
      image: 'assets/categoryimages/ghee.jpeg',
      subheading: 'Edible, Oils, Masala & Ghee',
      products: [
        Products( pro_id:"Cooking", name: 'Cooking Oil', image: 'assets/subcategory/ghee.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro1_cat5'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro1_cat5'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro1_cat5'),
          ],
        ),

        Products( pro_id:"Canola", name: 'Canola Oil', image: 'assets/subcategory/canola.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro2_cat5'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat5'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro2_cat5'),
          ],
        ),

        Products(pro_id:"Desi",name: 'Desi & Banaspati', image: 'assets/subcategory/banasapti.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro3_cat5'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro3_cat5'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro3_cat5'),
          ],
        ),

        Products(pro_id:"Sunflower",name: 'Sunflower Oil', image: 'assets/subcategory/sunflower.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro4_cat5'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro4_cat5'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro4_cat5'),
          ],
        ),

        Products(pro_id:"Corn",name: 'Corn Oil', image: 'assets/subcategory/cornoil.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro5_cat5'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro5_cat5'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro5_cat5'),
          ],
        ),

        Products(pro_id:"Olive",name: 'Olive & Musturd', image: 'assets/subcategory/olive.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro6_cat5'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro6_cat5'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro6_cat5'),
          ],
        ),

        Products(pro_id:"Spice",name: 'Spice Mixes', image: 'assets/subcategory/mixessp.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro7_cat5'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro7_cat5'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro7_cat5'),
          ],
        ),

        Products(pro_id:"Powdered",name: 'Powdered Spices', image: 'assets/subcategory/spicesss.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro8_cat5'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro8_cat5'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro8_cat5'),
          ],
        ),

        Products(pro_id:"Whole",name: 'Whole Spices', image: 'assets/subcategory/spuce.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro9_cat5'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro9_cat5'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro9_cat5'),
          ],
        ),

        Products(pro_id:"Herbs",name: 'Dried Herbs', image: 'assets/subcategory/dryp.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro10_cat5'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro10_cat5'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro10_cat5'),
          ],
        ),

      ],
    ),

    Categories(
      name: 'Daal, Rice, Atta, Cheeni',
      cat_id: "cat_6",
      image: 'assets/categoryimages/dall.jpeg',
      subheading: 'Daaliein, Chaawal, Salt Brown, White Sugar',
      products: [
        Products( pro_id:"Daalain", name: 'Daalain', image: 'assets/subcategory/daal.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro1_cat6'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro1_cat6'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro1_cat6'),
          ],
        ),

        Products( pro_id:"Rice", name: 'Rice', image: 'assets/subcategory/rice.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro2_cat6'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat6'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro2_cat6'),
          ],
        ),

        Products(pro_id:"Atta",name: 'Atta & Other', image: 'assets/subcategory/atttaa.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro3_cat6'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro3_cat6'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro3_cat6'),
          ],
        ),

        Products(pro_id:"Salt",name: 'Salt', image: 'assets/subcategory/salt.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro4_cat6'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro4_cat6'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro4_cat6'),
          ],
        ),

        Products(pro_id:"White",name: 'White Sugar', image: 'assets/subcategory/wsugar.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro5_cat6'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro5_cat6'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro5_cat6'),
          ],
        ),

        Products(pro_id:"Brown",name: 'Brown Sugar', image: 'assets/subcategory/bsugar.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro6_cat6'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro6_cat6'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro6_cat6'),
          ],
        ),

      ],
    ),

    Categories(
      name: 'Sauces & Pastas',
      cat_id: "cat_7",
      image: 'assets/categoryimages/sauces.jpeg',
      subheading: 'Ketchup , Achaar, Pastas, Dressings',
      products: [
        Products( pro_id:"Ketchup", name: 'Ketchup', image: 'assets/subcategory/ketchup.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro1_cat7'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro1_cat7'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro1_cat7'),
          ],
        ),

        Products( pro_id:"Chilli", name: 'Chilli Sauces', image: 'assets/subcategory/chilisau.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro2_cat7'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat7'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro2_cat7'),
          ],
        ),

        Products(pro_id:"Mayonnais",name: 'Mayonnais', image: 'assets/subcategory/mayo.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro3_cat7'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro3_cat7'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro3_cat7'),
          ],
        ),

        Products(pro_id:"Vinegar",name: 'Vinegar & Lemon', image: 'assets/subcategory/lemonc.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro4_cat7'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro4_cat7'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro4_cat7'),
          ],
        ),

        Products(pro_id:"Achaar",name: 'Achaar & Chutneys', image: 'assets/subcategory/achaar.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro5_cat7'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro5_cat7'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro5_cat7'),
          ],
        ),

        Products(pro_id:"Cooking",name: 'Cooking Pastas', image: 'assets/subcategory/pastas.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro6_cat7'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro6_cat7'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro6_cat7'),
          ],
        ),

        Products(pro_id:"Salsa",name: 'Salsa & Dips', image: 'assets/subcategory/salsa.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro7_cat7'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro7_cat7'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro7_cat7'),
          ],
        ),

        Products(pro_id:"Chaineas",name: 'Chaineas Sauces', image: 'assets/subcategory/chillis.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro8_cat7'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro8_cat7'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro8_cat7'),
          ],
        ),

        Products(pro_id:"Pasta",name: 'Pasta & Pizza', image: 'assets/subcategory/pizzassa.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro8_cat7'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro8_cat7'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro8_cat7'),
          ],
        ),

        Products(pro_id:"Salad",name: 'Salad Dressings', image: 'assets/subcategory/pizzas.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro9_cat7'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro9_cat7'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro9_cat7'),
          ],
        ),

      ],
    ),

    Categories(
      name: 'Bakery & Pantry',
      cat_id: "cat_8",
      image: 'assets/categoryimages/bakery.jpeg',
      subheading: 'Pastas, Canned Food, Custards, Nimko',
      products: [
        Products( pro_id:"Pastas", name: 'Pastas', image: 'assets/subcategory/pastas.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro1_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro1_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro1_cat8'),
          ],
        ),


        Products( pro_id:"Saviyaan", name: 'Saviyaan', image: 'assets/subcategory/saviyaan.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro2_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro2_cat8'),
          ],
        ),

        Products(pro_id:"Baking",name: 'Baking Essentials', image: 'assets/subcategory/essential.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro3_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro3_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro3_cat8'),
          ],
        ),


        Products(pro_id:"Custurd",name: 'Custurd', image: 'assets/subcategory/custurd.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro4_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro4_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro4_cat8'),
          ],
        ),


        Products(pro_id:"Jellys",name: 'Jellys', image: 'assets/subcategory/jellies.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro5_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro5_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro5_cat8'),
          ],
        ),
        Products(pro_id:"Ready",name: 'Ready Made', image: 'assets/subcategory/buns.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro6_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro6_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro6_cat8'),
          ],
        ),
        Products(pro_id:"Cannesd",name: 'Canned Vegetables', image: 'assets/subcategory/veg.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro7_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro7_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro7_cat8'),
          ],
        ),
        Products(pro_id:"Fruitss",name: 'Canned Fruits', image: 'assets/subcategory/fritscann.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro8_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro8_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro8_cat8'),
          ],
        ),
        Products(pro_id:"Bakinsg",name: 'Baking Mixes', image: 'assets/subcategory/atta.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro9_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro9_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro9_cat8'),
          ],
        ),
        Products(pro_id:"Beanss",name: 'Canned Beans', image: 'assets/subcategory/beans.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro10_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro10_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro10_cat8'),
          ],
        ),
        Products(pro_id:"Chocolate",name: 'Chocolate & Cocoa', image: 'assets/subcategory/cocoas.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro11_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro11_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro11_cat8'),
          ],
        ),
        Products(pro_id:"Food",name: 'Food Colors', image: 'assets/subcategory/foodc.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro12_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro12_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro12_cat8'),
          ],
        ),
        Products(pro_id:"Mashrooms",name: 'Olive & Mashrooms', image: 'assets/subcategory/olives.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro13_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro13_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro13_cat8'),
          ],
        ),

        Products(pro_id:"Decoration",name: 'Baking Decoration', image: 'assets/subcategory/pasteries.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro14_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro14_cat8'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro14_cat8'),
          ],
        ),

        Products(pro_id:"Seasoning",name: 'Seasoning Cubes', image: 'assets/subcategory/oats.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: ''),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: ''),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: ''),
          ],
        ),

      ],
    ),

    Categories(
      name: 'Snacks & Manchies',
      cat_id: "cat_9",
      image: 'assets/categoryimages/snacks.jpeg',
      subheading: 'Biscuits, Noodles, Chocolates',
      products: [
        Products( pro_id:"Instant", name: 'Instant Noodles', image: 'assets/subcategory/noodles.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro1_cat9'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro1_cat9'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro1_cat9'),
          ],
        ),

        Products( pro_id:"Biscuits", name: 'Biscuits & Cookies', image: 'assets/subcategory/biscuits.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro2_cat9'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat9'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro2_cat9'),
          ],
        ),

        Products(pro_id:"Chips",name: 'Chips', image: 'assets/subcategory/chips.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro3_cat9'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro3_cat9'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro3_cat9'),
          ],
        ),

        Products(pro_id:"Nimko",name: 'Nimko', image: 'assets/subcategory/nimko.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro4_cat9'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro4_cat9'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro4_cat9'),
          ],
        ),

        Products(pro_id:"Chocolates",name: 'Chocolates', image: 'assets/subcategory/popcorn.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro5_cat9'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro5_cat9'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro5_cat9'),
          ],
        ),

        Products(pro_id:"Popcorn",name: 'Popcorn', image: 'assets/subcategory/candies.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro6_cat9'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro6_cat9'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro6_cat9'),
          ],
        ),

        Products(pro_id:"Candies",name: 'Candies', image: 'assets/subcategory/jelly.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro7_cat9'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro7_cat9'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro7_cat9'),
          ],
        ),

        Products(pro_id:"Jellies",name: 'Jellies', image: 'assets/subcategory/gum.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro8_cat9'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro8_cat9'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro8_cat9'),
          ],
        ),

        Products(pro_id:"Chewing",name: 'Chewing Gum', image: 'assets/subcategory/chocolate.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro9_cat9'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro9_cat9'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro9_cat9'),
          ],
        ),

        Products(pro_id:"Snacks",name: 'Other Snacks', image: 'assets/subcategory/cakes.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro10_cat9'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro10_cat9'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro10_cat9'),
          ],
        ),

      ],
    ),

    Categories(
      name: 'Tea Cold Drinks & Jucies',
      cat_id: "cat_10",
      image: 'assets/categoryimages/tea.jpeg',
      subheading: 'Tea, Cold Drinks, Sharbat, Juices',
      products: [
        Products( pro_id:"Tea", name: 'Tea', image: 'assets/subcategory/tea.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro1_cat10'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro1_cat10'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro1_cat10'),
          ],
        ),

        Products( pro_id:"Sharbat", name: 'Sharbat & Squash', image: 'assets/subcategory/sharbat.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro2_cat10'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat10'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro2_cat10'),
          ],
        ),

        Products(pro_id:"Cold",name: 'Cold Drinks', image: 'assets/subcategory/coldd.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro3_cat10'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro3_cat10'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro3_cat10'),
          ],
        ),

        Products(pro_id:"Juices",name: 'Juices', image: 'assets/subcategory/juices.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro4_cat10'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro4_cat10'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro4_cat10'),
          ],
        ),

        Products(pro_id:"Energy",name: 'Energy Drinks', image: 'assets/subcategory/energy.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro5_cat10'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro5_cat10'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro5_cat10'),
          ],
        ),

        Products(pro_id:"Mineral",name: 'Mineral & Soda Water', image: 'assets/subcategory/water.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro6_cat10'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro6_cat10'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro6_cat10'),
          ],
        ),

        Products(pro_id:"Instant",name: 'Instant Drinks', image: 'assets/subcategory/softd.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro7_cat10'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro7_cat10'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro7_cat10'),
          ],
        ),

        Products(pro_id:"Coffee",name: 'Coffee', image: 'assets/subcategory/coffee.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro8_cat10'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro8_cat10'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro8_cat10'),
          ],
        ),

      ],
    ),

    Categories(
      name: 'Dry Fruit & Nuts',
      cat_id: "cat_11",
      image: 'assets/categoryimages/dryfruits.jpeg',
      subheading: 'Peanuts, Cashew, nuts, almonds',
      products: [
        Products( pro_id:"Nuts", name: 'Nuts', image: 'assets/subcategory/nuts.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro1_cat11'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro1_cat11'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro1_cat11'),
          ],
        ),

        Products( pro_id:"Dry", name: 'Dry Fruits', image: 'assets/subcategory/dryfruits.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro2_cat11'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat11'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro2_cat11'),
          ],
        ),

      ],
    ),

    Categories(
      name: 'Frozen & Chilled',
      cat_id: "cat_12",
      image: 'assets/categoryimages/frozensnacks.jpeg',
      subheading: 'Burger Pattie, Nuggest, Kabab',
      products: [
        Products( pro_id:"Fries", name: 'French Fries Chips', image: 'assets/subcategory/fries.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro1_cat12'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro1_cat12'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro1_cat12'),
          ],
        ),

        Products( pro_id:"Naan", name: 'Parathay & Naan', image: 'assets/subcategory/parathas.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro2_cat12'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat12'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro2_cat12'),
          ],
        ),

        Products(pro_id:"Dumplings",name: 'Dumplings', image: 'assets/subcategory/dumplings.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro3_cat12'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro3_cat12'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro3_cat12'),
          ],
        ),

        Products(pro_id:"Sausages",name: 'Sausages & Toopings', image: 'assets/subcategory/salsa.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro4_cat12'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro4_cat12'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro4_cat12'),
          ],
        ),

        Products(pro_id:"Kofta",name: 'Kabab & Kofta', image: 'assets/subcategory/kabab.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro5_cat12'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro5_cat12'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro5_cat12'),
          ],
        ),

        Products(pro_id:"Patties",name: 'Burger Patties', image: 'assets/subcategory/dryfruits.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro6_cat12'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro6_cat12'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro6_cat12'),
          ],
        ),

        Products(pro_id:"Nuggets",name: 'Nuggets & Snacks', image: 'assets/subcategory/nuggets.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro7_cat12'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro7_cat12'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro7_cat12'),
          ],
        ),

        Products(pro_id:"Rolls",name: 'Samosa & Rolls', image: 'assets/subcategory/samosa.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro8_cat12'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro8_cat12'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro8_cat12'),
          ],
        ),

        Products(pro_id:"Frozen",name: 'Frozen Fruits', image: 'assets/subcategory/fritscann.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro9_cat12'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro9_cat12'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro9_cat12'),
          ],
        ),

      ],
    ),

    Categories(
      name: 'Home Needs',
      cat_id: "cat_13",
      image: 'assets/categoryimages/homeneeds.jpeg',
      subheading: 'Broom , Waste bins, Crockery',
      products: [
        Products( pro_id:"Crockery", name: 'Crockery & Serveware', image: 'assets/subcategory/crockery.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro1_cat13'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro1_cat13'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro1_cat13'),
          ],
        ),

        Products( pro_id:"Cleaning", name: 'Cleaning Tools', image: 'assets/subcategory/cleaning.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro2_cat13'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat13'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro2_cat13'),
          ],
        ),

        Products(pro_id:"Garbage",name: 'Garbage Bags', image: 'assets/subcategory/dustbag.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro3_cat13'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro3_cat13'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro3_cat13'),
          ],
        ),

        Products(pro_id:"Kitchen",name: 'Kitchen Utensils', image: 'assets/subcategory/kitchenacc.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro4_cat13'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro4_cat13'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro4_cat13'),
          ],
        ),

        Products(pro_id:"Bathroom",name: 'Bathroom Essentials', image: 'assets/subcategory/bath.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro5_cat13'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro5_cat13'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro5_cat13'),
          ],
        ),

        Products(pro_id:"Bins",name: 'Dust Bins', image: 'assets/subcategory/dusbin.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro6_cat13'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro6_cat13'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro6_cat13'),
          ],
        ),

        Products(pro_id:"Cooking",name: 'Cooking Utensils', image: 'assets/subcategory/kitchacc.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro7_cat13'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro7_cat13'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro7_cat13'),
          ],
        ),

        Products(pro_id:"Accessories",name: 'Home Accessories', image: 'assets/subcategory/homeacc.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro8_cat13'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro8_cat13'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro8_cat13'),
          ],
        ),

        Products(pro_id:"Freshners",name: 'Air Freshners', image: 'assets/subcategory/airspray.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro9_cat13'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro9_cat13'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro9_cat13'),
          ],
        ),

        Products(pro_id:"Floor",name: 'Prayer & Floor Mats', image: 'assets/subcategory/mat.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro10_cat13'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro10_cat13'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro10_cat13'),
          ],
        ),

        Products(pro_id:"Towels",name: 'Towels', image: 'assets/subcategory/towels.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro11_cat13'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro11_cat13'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro11_cat13'),
          ],
        ),

        Products(pro_id:"Locks",name: 'Locks', image: 'assets/subcategory/locks.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro12_cat13'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro12_cat13'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro12_cat13'),
          ],
        ),

      ],
    ),

    Categories(
      name: 'Cleaning Products & Replicants',
      cat_id: "cat_14",
      image: 'assets/categoryimages/cleaningproducts.jpeg',
      subheading: 'Detergents, Tissues, Repellents, Laundry',
      products: [
        Products( pro_id:"Needs", name: 'Kitchen Needs', image: 'assets/subcategory/kitchenacc.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro1_cat14'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro1_cat14'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro1_cat14'),
          ],
        ),

        Products( pro_id:"Tissue", name: 'Tissue Papers', image: 'assets/subcategory/tissues.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro2_cat14'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat14'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro2_cat14'),
          ],
        ),

        Products(pro_id:"Cleaning",name: 'Cleaning Essentials', image: 'assets/subcategory/bath.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro3_cat14'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro3_cat14'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro3_cat14'),
          ],
        ),

        Products(pro_id:"Insect",name: 'Insect & Pest', image: 'assets/subcategory/mortin.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro4_cat14'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro4_cat14'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro4_cat14'),
          ],
        ),

      ],
    ),

    Categories(
      name: 'Laundry Care',
      cat_id: "cat_15",
      image: 'assets/categoryimages/laundrycare.jpeg',
      subheading: 'Detergents, Starch, Fabric, Bleach',
      products: [
        Products( pro_id:"Detergent", name: 'Detergent & Powders', image: 'assets/subcategory/detergent.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro1_cat15'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro1_cat15'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro1_cat15'),
          ],
        ),

        Products( pro_id:"Fabric", name: 'Fabric Conditioners', image: 'assets/subcategory/fabric.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro2_cat15'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat15'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro2_cat15'),
          ],
        ),

        Products(pro_id:"Starch",name: 'Starch', image: 'assets/subcategory/starch.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro3_cat15'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro3_cat15'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro3_cat15'),
          ],
        ),

        Products(pro_id:"Bleech",name: 'Bleech & Stain', image: 'assets/subcategory/bleech.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro4_cat15'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro4_cat15'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro4_cat15'),
          ],
        ),

        Products(pro_id:"Laundry",name: 'Laundry Essentials', image: 'assets/subcategory/laundry.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro5_cat15'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro5_cat15'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro5_cat15'),
          ],
        ),

        Products(pro_id:"Liquid",name: 'Liquid Cleaners', image: 'assets/subcategory/liquids.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro6_cat15'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro6_cat15'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro6_cat15'),
          ],
        ),

      ],
    ),

    Categories(
      name: 'Personal Care',
      cat_id: "cat_16",
      image: 'assets/categoryimages/personalcare.jpeg',
      subheading: 'Male&Female Care, Shampoo, Soaps',
      products: [
        Products( pro_id:"Makeup", name: 'Makeup', image: 'assets/subcategory/makeup.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro1_cat16'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat16'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro3_cat16'),
          ],
        ),

        Products( pro_id:"Men", name: 'Men Care', image: 'assets/subcategory/menscare.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro4_cat16'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro4_cat16'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro4_cat16'),
          ],
        ),

        Products(pro_id:"Women",name: 'Women Care', image: 'assets/subcategory/always.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro5_cat16'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro5_cat16'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro6_cat16'),
          ],
        ),

        Products(pro_id:"Skin",name: 'Skin Care', image: 'assets/subcategory/skin.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro7_cat16'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro7_cat16'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro7_cat16'),
          ],
        ),

        Products(pro_id:"Hair",name: 'Hair Care', image: 'assets/subcategory/hair.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro8_cat16'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro8_cat16'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro8_cat16'),
          ],
        ),

        Products(pro_id:"Soaps",name: 'Soaps & Handwash', image: 'assets/subcategory/handwash.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro9_cat16'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro9_cat16'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro9_cat16'),
          ],
        ),

        Products(pro_id:"Dental",name: 'Dental Care', image: 'assets/subcategory/dental.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro10_cat16'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro10_cat16'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro10_cat16'),
          ],
        ),

        Products(pro_id:"Shoes",name: 'Shoes & Polish', image: 'assets/subcategory/polish.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro11_cat16'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro11_cat16'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro11_cat16'),
          ],
        ),

        Products(pro_id:"Care",name: 'Personal Care Access', image: 'assets/subcategory/personal.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro12_cat16'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro12_cat16'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro12_cat16'),
          ],
        ),

      ],
    ),

    Categories(
      name: 'Baby Care',
      cat_id: "cat_17",
      image: 'assets/categoryimages/babycare.jpeg',
      subheading: 'Diapers, Lotions, Baby Food',
      products: [
        Products( pro_id:"Diapers", name: 'Diapers & Wipes', image: 'assets/subcategory/pampers.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro1_cat17'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro1_cat17'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro1_cat17'),
          ],
        ),

        Products( pro_id:"Foods &", name: 'Foods & Milk', image: 'assets/subcategory/cerelac.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro2_cat17'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat17'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro2_cat17'),
          ],
        ),

        Products(pro_id:"Bath & Skin",name: 'Bath & Skin Care', image: 'assets/subcategory/skin.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro3_cat17'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro3_cat17'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro3_cat17'),
          ],
        ),

        Products(pro_id:"Feeding",name: 'Feeding Acccessories', image: 'assets/subcategory/feeding.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro4_cat17'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro4_cat17'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro4_cat17'),
          ],
        ),

        Products(pro_id:"Baby",name: 'Baby Care Essentials', image: 'assets/subcategory/babacc.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro5_cat17'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro5_cat17'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro5_cat17'),
          ],
        ),

      ],
    ),

    Categories(
      name: 'Stationary Shop',
      cat_id: "cat_18",
      image: 'assets/categoryimages/stationaryshop.jpeg',
      subheading: 'Pens, Pencils, Erasers, Glue, Toys',
      products: [
        Products( pro_id:"Pencils", name: 'Pencils & Sharpners', image: 'assets/subcategory/pensils.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro1_cat18'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro1_cat18'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro1_cat18'),
          ],
        ),

        Products( pro_id:"Pens", name: 'Pens & Ink', image: 'assets/subcategory/pens.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro2_cat18'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat18'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro3_cat18'),
          ],
        ),

        Products(pro_id:"Erasers",name: 'Erasers & Removers', image: 'assets/subcategory/eraser.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro4_cat18'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro4_cat18'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro4_cat18'),
          ],
        ),

        Products(pro_id:"Measuring",name: 'Measuring Tools', image: 'assets/subcategory/scale.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro5_cat18'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro5_cat18'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro5_cat18'),
          ],
        ),

        Products(pro_id:"Tape",name: 'Tape & Glue', image: 'assets/subcategory/tape.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro6_cat18'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro6_cat18'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro6_cat18'),
          ],
        ),

        Products(pro_id:"Notebooks",name: 'Notebooks & Papers', image: 'assets/subcategory/notebook.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro7_cat18'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro7_cat18'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro7_cat18'),
          ],
        ),
        Products(pro_id:"Learning",name: 'Learning Books', image: 'assets/subcategory/learnbook.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro8_cat18'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro8_cat18'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro8_cat18'),
          ],
        ),

        Products(pro_id:"Games",name: 'Games & Toys', image: 'assets/subcategory/toys.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro9_cat18'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro9_cat18'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro9_cat18'),
          ],
        ),

        Products(pro_id:"Crafts",name: 'Art & Crafts', image: 'assets/subcategory/crafts.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro10_cat18'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro10_cat18'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro10_cat18'),
          ],
        ),

        Products(pro_id:"Office",name: 'Office Supplies', image: 'assets/subcategory/staplers.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro11_cat18'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro11_cat18'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro11_cat18'),
          ],
        ),

        Products(pro_id:"Bags",name: 'Bags & Pouches', image: 'assets/subcategory/pouch.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro12_cat18'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro12_cat18'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro12_cat18'),
          ],
        ),

        Products(pro_id:"Party",name: 'Party & Gifting', image: 'assets/subcategory/gift.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro13_cat18'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro13_cat18'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro13_cat18'),
          ],
        ),

      ],
    ),

    Categories(
      name: 'Electronic Store',
      cat_id: "cat_19",
      image: 'assets/categoryimages/electronicsshop.jpeg',
      subheading: 'Charging Cables, Cells and More',
      products: [
        Products( pro_id:"Chargers", name: 'Chargers & Cables', image: 'assets/subcategory/charger.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro1_cat19'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro1_cat19'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro1_cat19'),
          ],
        ),

        Products( pro_id:"Batteries", name: 'Batteries', image: 'assets/subcategory/cells.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro2_cat19'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat19'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro2_cat19'),
          ],
        ),

        Products(pro_id:"Extension",name: 'Extension Wire', image: 'assets/subcategory/headphone.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro2_cat19'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat19'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro2_cat19'),
          ],
        ),

        Products(pro_id:"Handsfree",name: 'Handsfree & Earbudes', image: 'assets/subcategory/wireex.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro3_cat19'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro3_cat19'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro3_cat19'),
          ],
        ),

        Products(pro_id:"Bulbs",name: 'Bulbs & Lights', image: 'assets/subcategory/bulbs.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro4_cat19'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro4_cat19'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro4_cat19'),
          ],
        ),

      ],
    ),

    Categories(
      name: 'Fashion & Accessories',
      cat_id: "cat_20",
      image: 'assets/categoryimages/fashonaccories.jpeg',
      subheading: 'Inner wear, Hair clips, Shoes',
      products: [
        Products( pro_id:"Innerwear", name: 'Innerwear', image: 'assets/subcategory/innerwear.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro1_cat20'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro1_cat20'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro1_cat20'),
          ],
        ),

        Products( pro_id:"Shoes", name: 'Shoes', image: 'assets/subcategory/shoes.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro2_cat20'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat20'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro2_cat20'),
          ],
        ),

      ],
    ),

    Categories(
      name: 'Health & Wellness',
      cat_id: "cat_21",
      image: 'assets/categoryimages/healthwellness.jpeg',
      subheading: 'Condoms, Dettol, Ispaghol',
      products: [
        Products( pro_id:"Condoms", name: 'Condoms & Lubricants', image: 'assets/subcategory/condoms.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro1_cat21'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro1_cat21'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro1_cat21'),
          ],
        ),

        Products( pro_id:"Food", name: 'Food Supplements', image: 'assets/subcategory/supplements.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro2_cat21'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat21'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro2_cat21'),
          ],
        ),

        Products(pro_id:"Aid",name: 'First Aid', image: 'assets/subcategory/firstaid.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro3_cat21'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro3_cat21'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro3_cat21'),
          ],
        ),

        Products(pro_id:"Herbal",name: 'Herbal & Health', image: 'assets/subcategory/herbalhealth.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro4_cat21'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro4_cat21'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro4_cat21'),
          ],
        ),

        Products(pro_id:"Masks",name: 'Face Masks', image: 'assets/subcategory/masks.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro5_cat21'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro5_cat21'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro5_cat21'),
          ],
        ),

      ],
    ),

    Categories(
      name: 'Tobacco & Nicotine',
      cat_id: "cat_22",
      image: 'assets/categoryimages/tobacconicotine.jpeg',
      subheading: 'Cigrattes, Nicotine, Ciggars',
      products: [
        Products( pro_id:"apple", name: 'Cigrattes', image: 'assets/subcategory/cigratte.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro1_cat22'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro1_cat22'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro1_cat22'),
          ],
        ),

        Products( pro_id:"banana", name: 'Nicotine Pouches', image: 'assets/subcategory/nicotine.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro2_cat22'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat22'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro2_cat22'),
          ],
        ),

      ],
    ),

    Categories(
      name: 'Pet Care',
      cat_id: "cat_23",
      image: 'assets/categoryimages/petcarefood.jpeg',
      subheading: 'Cat Food, Dog Food',
      products: [
        Products( pro_id:"cat_food", name: 'Cat Food', image: 'assets/subcategory/catsfood.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro1_cat23' , isTrending: true),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro1_cat23'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro1_cat23'),
          ],
        ),

        Products( pro_id:"dogs_food", name: 'Dog Food', image: 'assets/subcategory/dogsfood.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro2_cat23'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro2_cat23'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro2_cat23'),
          ],
        ),

        Products(pro_id:"Poop",name: 'Poop Bags', image: 'assets/subcategory/poopbags.jpeg',
          variants: [
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient1_pro3_cat23'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient2_pro3_cat23'),
            Variant(name: 'White Bread', curr_price: '2.99' , pre_price: '2.99' , weight: '2.99'
                , discount: '2.99', image: 'assets/categoryimages/bread.jpeg', var_id: 'varient3_pro3_cat23'),
          ],
        ),

      ],
    ),
  ];
}

