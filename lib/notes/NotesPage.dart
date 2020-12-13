import 'package:flutter/material.dart';

import 'CardItem.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => new _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  var appColors = [Color.fromRGBO(231, 129, 109, 1.0),Color.fromRGBO(99, 138, 223, 1.0),Color.fromRGBO(111, 194, 173, 1.0)];
  var cardIndex = 0;
  ScrollController scrollController;
  var currentColor = Color.fromRGBO(231, 129, 109, 1.0);


  AnimationController animationController;
  ColorTween colorTween;
  CurvedAnimation curvedAnimation;

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xffA1D2D6),
      appBar: new AppBar(
        title: new Text("ToDo", style: TextStyle(fontSize: 20.0)),
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(147, 172, 243, 1),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: Icon(Icons.search),
          ),
        ],
        //centerTitle: true,
      ),
      body: new Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 40.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //TODO change according to how many tasks done
                    Text("Tasks\n", style:TextStyle(color: Colors.white, fontSize: 28.0,fontWeight: FontWeight.bold,)),
                    Text("Looks like you are almost done!", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                    Text("You have 3 tasks to do today.", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 16.0),
                ),
                Container(
                  height: 350.0,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, position) {
                      return GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Container(
                              width: 250.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Icon(Icons.school, color: appColors[position],),
                                        Icon(Icons.more_vert, color: Colors.grey,),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                          //TODO add tasks to do
                                          child: Text("Tasks", style: TextStyle(color: Colors.grey),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                          //TODO change to course name
                                          child: Text("Work", style: TextStyle(fontSize: 28.0),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          //TODO change to progress indicator
                                          child: LinearProgressIndicator(value: 1,),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                          ),
                        ),
                        onHorizontalDragEnd: (details) {

                          animationController = AnimationController(duration: Duration(milliseconds: 500));
                          curvedAnimation = CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn);
                          animationController.addListener(() {
                            setState(() {
                              currentColor = colorTween.evaluate(curvedAnimation);
                            });
                          });

                          if(details.velocity.pixelsPerSecond.dx > 0) {
                            if(cardIndex>0) {
                              cardIndex--;
                              colorTween = ColorTween(begin:currentColor,end:appColors[cardIndex]);
                            }
                          }else {
                            if(cardIndex<2) {
                              cardIndex++;
                              colorTween = ColorTween(begin: currentColor,
                                  end: appColors[cardIndex]);
                            }
                          }
                          setState(() {
                            scrollController.animateTo((cardIndex)*256.0, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
                          });

                          colorTween.animate(curvedAnimation);

                          animationController.forward( );

                        },
                      );
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
      ),
    );
  }
}