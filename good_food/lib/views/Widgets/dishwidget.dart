import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/recipe_controller/recipe_controller.dart';
import '../../models/recipe_model.dart';
import '../../utils/route_pages/page_name.dart';
import '../screens/recipe_view.dart';
import 'package:get/get.dart';

class RecipieTile extends StatefulWidget {
  final RecipeModel recipeModel;

  RecipieTile({
     required this.recipeModel
  });

  @override
  _RecipieTileState createState() => _RecipieTileState();
}

class _RecipieTileState extends State<RecipieTile> {
  RecipeController controller=Get.put(RecipeController());

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    // bool inwishlist=true;
    // if(controller.isRecipeInWishlist(widget.recipeModel.label))
    //   {
    //     inwishlist=false;
    //   }else{
    //   inwishlist=true;
    // }
    return Stack(

      children:[

        GestureDetector(
          onTap: () {
            if (kIsWeb) {
              _launchURL(widget.recipeModel.source);
            } else {
              Get.toNamed(
                MyPagesName.recipefullview,
                arguments: widget.recipeModel.url,
              );

            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 2, horizontal: 8), // Reduced vertical margin
            child: Stack(
                children: [
                  Stack(
                    children: <Widget>[

                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget.recipeModel.image,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                                size: 50,
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.7)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.recipeModel.label,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontFamily: 'Overpass',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2), // Reduced SizedBox height
                              Text(
                                widget.recipeModel.source,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontFamily: 'OverpassRegular',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ]
            ),
          ),
        ),
        Obx((){
          bool inWishlist = controller.isRecipeInWishlist(widget.recipeModel.label);

          return   Padding(
            padding: EdgeInsets.only(right: 10,top: 5),
            child: GestureDetector(
              onTap: () {
                print("inWishlist"+inWishlist.toString());
                if(!inWishlist)
                {
                  controller.addToWishlist(widget.recipeModel);

                }else{
                  controller.removeFromWishlist(widget.recipeModel);

                }
                setState(() {

                });
              },
              child:Align(
                alignment: AlignmentDirectional.topEnd,
                child: inWishlist
                    ? Icon(
                  size: 30,
                  color: Colors.red,
                  Icons.favorite,
                )
                    : Icon(
                  size: 30,
                  color: Colors.grey,
                  Icons.favorite_border_outlined,
                )
              ),
            ),
          );
    }

        ),

      ]
    );
  }
}
