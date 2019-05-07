import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(new Game());

class Game extends StatefulWidget {
  MainPage createState() => new MainPage();
}

class MainPage extends State<Game> {
  String title = "QuizGame";
  Color red = new Color(0xFF8B1122);
  Color white = Colors.white;

  static int level = 1;
  static int score = 0;

  static Generator gen = new Generator();
  static Question q = gen.generate(level);

  String state = "";
  String body = q.body;
  String value1 = q.ans[0];
  String value2 = q.ans[1];
  String value3 = q.ans[2];
  String validResult = q.valid.toString();

  void submit1() {
    if (value1 == validResult)
      setState(() => validAns());
    else
      setState(() => state = "False");
  }

  void submit2() {
    if (value2 == validResult)
      setState(() => validAns());
    else
      setState(() => state = "False");
  }

  void submit3() {
    if (value3 == validResult)
      setState(() => validAns());
    else
      setState(() => state = "False");
  }

  void validAns() {
    state = "True";
    score += 5;
    level += 1;
    q = gen.generate(level);
    body = q.body;
    value1 = q.ans[0];
    value2 = q.ans[1];
    value3 = q.ans[2];
    validResult = q.valid.toString();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: red,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Level : $level"),
              Text("Score : $score"),
              Text(body, style: TextStyle(fontWeight: FontWeight.bold)),
              RaisedButton(
                child: Text(value1),
                color: red,
                textColor: white,
                onPressed: submit1,
              ),
              RaisedButton(
                child: Text(value2),
                color: red,
                textColor: white,
                onPressed: submit2,
              ),
              RaisedButton(
                child: Text(value3),
                color: red,
                textColor: white,
                onPressed: submit3,
              ),
              Text("State : " + state),
            ],
          ),
        ),
      ),
    );
  }
}

class Question {
  int level;
  int valid;
  String body;
  List<String> ans;

  Question(int level, int valid, String body, List<String> ans) {
    this.level = level;
    this.valid = valid;
    this.body = body;
    this.ans = ans;
  }
}

class Generator {
  static final r = new Random();

  Question generate(int level) {
    int limit = level * 10;
    int x = r.nextInt(limit) + 1;
    int y = r.nextInt(limit) + 1;
    int o = r.nextInt(3);

    String body = makeBody(x, y, o);
    int validAns = getValidAnswer(x, y, o);
    List<String> ans = new List();
    ans.add(validAns.toString());

    while (ans.length != 3) {
      int num = r.nextInt(limit);
      if (!ans.contains(num)) {
        ans.add(num.toString());
      }
    }
    ans.shuffle();
    return new Question(level, validAns, body, ans);
  }

  String makeBody(int x, int y, int o) {
    switch (o) {
      case 1:
        return "$x - $y";
      case 2:
        return "$x * $y";
      case 3:
        return "$x / $y";
      default:
        return "$x + $y";
    }
  }

  int getValidAnswer(int x, int y, int o) {
    switch (o) {
      case 1:
        return x - y;
      case 2:
        return x * y;
      case 3:
        return (x / y).round();
      default:
        return x + y;
    }
  }
}
