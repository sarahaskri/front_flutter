import 'package:fityes/sprint_2/colo_extension.dart';
import 'package:fityes/sprint_2/round_boutton.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:fityes/sprint_2/food_step_detail.dart';
import 'package:fityes/sprint_2/addMeal.dart';

class FoodInfoDetailsViewLunchREC1 extends StatefulWidget {
  final Map mObj;
  final Map dObj;
  const FoodInfoDetailsViewLunchREC1({super.key, required this.dObj, required this.mObj});

  @override
  State<FoodInfoDetailsViewLunchREC1> createState() => _FoodInfoDetailsViewStateLunchREC1();
}

class _FoodInfoDetailsViewStateLunchREC1 extends State<FoodInfoDetailsViewLunchREC1> {
List nutritionArr = [
  {"image": "assets/images/burn.png", "title": "350kCal"},
  {"image": "assets/images/egg.png", "title": "10g fats"},
  {"image": "assets/images/proteins.png", "title": "35g proteins"},
  {"image": "assets/images/carbo.png", "title": "40g carbo"},
];

List ingredientsArr = [
  {"image": "assets/images/chicken.png", "title": "Grilled Chicken", "value": "150g"},
  {"image": "assets/images/quinoa.png", "title": "Cooked Quinoa", "value": "100g"},
  {"image": "assets/images/spinach.png", "title": "Spinach", "value": "50g"},
  {"image": "assets/images/pepper.png", "title": "Bell Peppers", "value": "50g"},
  {"image": "assets/images/oil.png", "title": "Olive Oil", "value": "1 tbsp"},
  {"image": "assets/images/spices.png", "title": "Spices", "value": "to taste"},
];


List stepArr = [
  {"no": "1", "detail": "Grill the chicken breast with olive oil and spices."},
  {"no": "2", "detail": "Cook quinoa in water until fluffy."},
  {"no": "3", "detail": "Sauté spinach and bell peppers lightly."},
  {"no": "4", "detail": "Mix quinoa, veggies and chicken in a bowl."},
  {"no": "5", "detail": "Season with salt, pepper and olive oil."},
  {"no": "6", "detail": "Serve warm and enjoy your healthy meal."},
];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(gradient: LinearGradient(colors: TColor.primaryG)),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
             SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: TColor.lightGray,
                      borderRadius: BorderRadius.circular(10)),
                  child: Image.asset(
                    "assets/images/black_btn.png",
                    width: 15,
                    height: 15,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              actions: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: TColor.lightGray,
                        borderRadius: BorderRadius.circular(10)),
                    child: Image.asset(
                      "assets/images/more_btn.png",
                      width: 15,
                      height: 15,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              ],
            ),
         SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leadingWidth: 0,
              leading: Container(),
              expandedHeight: media.width * 0.5,
              flexibleSpace: ClipRect(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Transform.scale(
                      scale: 1.25,
                      child: Container(
                        width: media.width * 0.55,
                        height: media.width * 0.55,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius:
                              BorderRadius.circular(media.width * 0.275),
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 1.25,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          widget.dObj["b_image"].toString(),
                          width: media.width * 0.50,
                          height: media.width * 0.50,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Container(
          decoration: BoxDecoration(
              color: TColor.white,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: Container(
                          width: 50,
                          height: 4,
                          decoration: BoxDecoration(
                              color: TColor.gray.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(3)),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.dObj["name"].toString(),
                                      style: TextStyle(
                                          color: TColor.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700)),
                                  Text("by FitYes Chef",
                                      style: TextStyle(
                                          color: TColor.gray, fontSize: 12)),
                                ],
                              ),
                            ),
                            Image.asset("assets/images/fav.png", width: 15, height: 15),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildSectionTitle("Nutrition"),
                      _buildNutritionList(),
                      _buildSectionTitle("Description"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ReadMoreText(
                      'The Quinoa Chicken Bowl is a balanced and nutritious meal packed with protein, fiber, and essential nutrients. It combines grilled chicken with fluffy quinoa and sautéed vegetables for a delicious and healthy lunch option.',

                          trimLines: 4,
                          colorClickableText: TColor.black,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: ' Read More ...',
                          trimExpandedText: ' Read Less',
                          style: TextStyle(color: TColor.gray, fontSize: 12),
                          moreStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildSectionTitle("Ingredients That You\nWill Need", itemCount: ingredientsArr.length),
                      _buildIngredientList(media),
                      _buildSectionTitle("Step by Step", itemCount: stepArr.length),
                      _buildStepsList(),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: RoundButton(
                          title: "Add to ${widget.mObj["name"]} Meal",
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddMealPage(
                                          mealName: widget.dObj["name"].toString(),
                                          mealType: widget.mObj["name"].toString(),
                                        )));
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {int? itemCount}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
          if (itemCount != null)
            TextButton(
              onPressed: () {},
              child: Text("$itemCount Items",
                  style: TextStyle(color: TColor.gray, fontSize: 12)),
            )
        ],
      ),
    );
  }

  Widget _buildNutritionList() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: nutritionArr.length,
          itemBuilder: (context, index) {
            var nObj = nutritionArr[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    TColor.primaryColor2.withOpacity(0.4),
                    TColor.primaryColor1.withOpacity(0.4)
                  ]),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Image.asset(nObj["image"], width: 15, height: 15),
                  const SizedBox(width: 8),
                  Text(nObj["title"], style: TextStyle(fontSize: 12)),
                ],
              ),
            );
          }),
    );
  }

  Widget _buildIngredientList(Size media) {
    return SizedBox(
      height: (media.width * 0.25) + 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: ingredientsArr.length,
        itemBuilder: (context, index) {
          var ing = ingredientsArr[index];
          return Container(
            width: media.width * 0.23,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: media.width * 0.23,
                  width: media.width * 0.23,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: TColor.lightGray,
                      borderRadius: BorderRadius.circular(10)),
                  child: Image.asset(ing["image"], width: 45, height: 45),
                ),
                const SizedBox(height: 4),
                Text(ing["title"], style: TextStyle(fontSize: 12)),
                Text(ing["value"], style: TextStyle(fontSize: 10, color: TColor.gray)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stepArr.length,
      itemBuilder: (context, index) {
        var step = stepArr[index];
        return FoodStepDetailRow(sObj: step, isLast: index == stepArr.length - 1);
      },
    );
  }
}
