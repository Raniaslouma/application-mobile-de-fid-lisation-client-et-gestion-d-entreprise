import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapplication/started.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'fidapp', home: GetStarted());
  }
}

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  late PageController _pageController;
  int _currentPageIndex = 0;
  bool _isPageOne = true;

  void _togglePage() {
    setState(() {
      _isPageOne = !_isPageOne;
    });
  }

  @override

  //firebaseApp

  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  void _changePage(int pageIndex) {
    setState(() {
      _currentPageIndex = pageIndex;
      _pageController.animateToPage(pageIndex,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              children: [
                page1(() => _changePage(1)),
                page2(() => _changePage(0)),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 2; i++)
                Container(
                  
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == _currentPageIndex ? Colors.blue : Colors.grey,
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}

class page1 extends StatefulWidget {
  final VoidCallback onTap;

  const page1(this.onTap, {super.key});

  @override
  State<page1> createState() => _page1State();
}

class _page1State extends State<page1> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          color: Colors.white,
          margin:const EdgeInsets.only(top:20),
          padding: const EdgeInsets.only(top: 80, left: 30, right: 20),
          /*child: Icon(
      Icons.arrow_forward,
      color: Colors.white,
      size: 48,
    ),
  ),*/
          child: Column(
            children: [
              Image.asset('images/viiiis.jpg', width: 300, height: 300),
              const SizedBox(height: 15),
              const Center (child: Text(" Dashboard, gestion de stock .. ",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(193, 4, 2, 158)))),
              const SizedBox(height: 20),
              const Padding(  padding: EdgeInsets.all(8.0),
                child: Text(
                  "Vous pouvez avoir des rapports de visualisation sur vos données de ventes , gérer votre stock et publier vos nouveaux catalogues de promotion  ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),),
              const SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Started()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(120, 50),
                    backgroundColor: const Color.fromARGB(255, 26, 64, 233)),
                child: const Text("Commencer"),
              ),
              
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 300),
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: widget.onTap,
                  iconSize: 37,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 50),
            ],
          )),
    );
  }
}

class page2 extends StatefulWidget {
  final VoidCallback onTap;

  const page2(this.onTap, {super.key});

  @override
  State<page2> createState() => _page2State();
}

class _page2State extends State<page2> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      color: Colors.white,
       margin:const EdgeInsets.only(top:40),
          padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
      child: Column(children: [
        Image.asset('images/b.jpg',width: 300, height: 300),
        const SizedBox(height: 20),
        const Center ( child :Text(" Cartes de fidélité digitale",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(193, 4, 2, 158)))),
        const SizedBox(height: 20),
        const Padding(  padding: EdgeInsets.all(8.0),
                child: Text(
          " Digitaliser vos cartes des fidélité et avoir une vision complète sur les donnes de votre carte et sur les nouveaux promotions",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w300,
          ),
        )),
        const SizedBox(height: 60.0),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Started()),
            );
          },
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(120, 50),
            backgroundColor: const Color.fromARGB(255, 26, 64, 233),
          ),
          child: const Text("Commencer"),
        ),
        const SizedBox(height: 55),
        /*Text.rich(
            TextSpan(text: 'si vous avez déja un compte?', children: [
                  TextSpan(text: 'Se Connecter', style: TextStyle(color: Color.fromARGB(255, 4, 118, 212),decoration: TextDecoration.underline,),
      recognizer: TapGestureRecognizer()
          ..onTap = () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => login()),
            );
          }
          ),],),
),*/
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 300),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: widget.onTap,
            iconSize: 38,
            color: Colors.grey,
          ),
        ),const SizedBox(height: 50),
      ]),
    ));
  }
}
  /*Widget build(BuildContext context) {
    return Scaffold(
    body:Container(
      color:Colors.white  ,
      padding:EdgeInsets.only(top:50,left:10,right:10),
      /*decoration:BoxDecoration(
        color:Colors.blue,
        image:DecorationImage(
          image:AssetImage('images/p.jpg'),
          fit:BoxFit.fill
        )*/
     child:Column( children: [
        Image.asset('images/b.jpg'),
        SizedBox(height: 15),
        Text("Visualisation sur les vente , Gestion de Stock , cartes des fidelite degitale" ,
                             style :TextStyle(fontSize: 25, fontWeight:FontWeight.bold , color:Color.fromARGB(193, 4, 2, 158))),
        Text("hello!if you are a client and need to mobilise your loyal card anf if your an entreprise and you wanna see your dashbords  "),
        SizedBox(height: 50.0),
        ElevatedButton(onPressed: (){
          Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>  signup()),
    );}, child: Text("Commencer")),
        SizedBox(height:30),
        Text.rich(
            TextSpan(text: 'si vous avez déja un compte?', children: [
                  TextSpan(text: 'Se Connecter', style: TextStyle(color: Colors.blue,decoration: TextDecoration.underline,),
      recognizer: TapGestureRecognizer()
          ..onTap = () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => login()),
            );
          }
          ),],),
)
        ] ),
      
    ));
  }*/
