import 'package:flutter/material.dart';
import 'package:flutter_learn_animation/kekers/models/game.dart';

class KekersPage extends StatefulWidget {
  const KekersPage({ Key? key }) : super(key: key);

  @override
  State<KekersPage> createState() => _KekersPageState();
}
class KekerView{
  int x=0;
  int y=0;
  bool isSecond =false;
  bool isModify=false;

  KekerView(this.x, this.y, this.isSecond, this.isModify);

  KekerView.from(Keker? kek){
    if(kek!=null){
      x=kek.X;
      y=kek.Y;
      isSecond=kek.isSecond;
      isModify=kek.isModify;
    }
  }

  KekerView.copy(KekerView? kek){
    if(kek!=null){
      x=kek.x;
      y=kek.y;
      isSecond=kek.isSecond;
      isModify=kek.isModify;
    }
  }
}

class _KekersPageState extends State<KekersPage> {
  final _moveNotifier = ValueNotifier<KekerView?>(null);
  final _kekerNotifier = ValueNotifier<List<Keker>>(Game.getAll());
  final _logNotifier = ValueNotifier<String>(Game.logMessage);
  var key = GlobalKey();

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init(){
    Game.init();
    _kekerNotifier.value=Game.getAll();
    _moveNotifier.value=Game.getSelected()!=null?KekerView.from(Game.getSelected()):null;
    _logNotifier.value=Game.logMessage;
  }
  
  void move(int i, int j){
    if(Game.getSelected()!=null){
      //if(Game.canMove(i, j)){
        Game.move(i, j);
        var t = KekerView.copy(_moveNotifier.value);
        var t2 = Game.getLastSelected();
        t.x=t2!.X;
        t.y=t2.Y;
        _moveNotifier.value=t;
        _logNotifier.value=Game.logMessage;
      //}
    }
  }

  void afterVisualMove(){
    _moveNotifier.value=Game.getSelected()!=null?KekerView.from(Game.getSelected()):null;
    _kekerNotifier.value=Game.getAll();
    _logNotifier.value=Game.logMessage;
  }

  void select(int i, int j){
    var t = Game.select(i, j);
    //print(t);
    key=GlobalKey();
    _kekerNotifier.value=Game.getAll();
    _moveNotifier.value=Game.getSelected()!=null?KekerView.from(Game.getSelected()):null;
    _logNotifier.value=Game.logMessage;
  }

  @override
  void dispose() {
    _moveNotifier.dispose();
    _kekerNotifier.dispose();
    _logNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double shortestSide = MediaQuery.of(context).size.shortestSide;
    double size = shortestSide*0.6;
    double cellSize = size*0.125;
    double kekerSize = size*0.09375;
    return Scaffold(
      appBar: AppBar(
        title: const Text("KEK"),
      ),
      body: Center(
        child: Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.end,
          verticalDirection: VerticalDirection.up,
          //crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: Stack(
                children: [
                  Board(callback: move, cellSize: cellSize,),
                  ValueListenableBuilder(
                    valueListenable: _kekerNotifier,
                    builder: (_, List<Keker> value, __) {
                      return Kekeri(
                        cellSize: cellSize,
                        kekerSize: kekerSize,
                        list: value,
                        callback: select,
                      );
                    }
                  ),
                  ValueListenableBuilder(
                    valueListenable: _moveNotifier,
                    builder: (_, KekerView? value, __) {
                      //print("generete anim");
                      return value!=null?
                      AnimatedPositioned(
                        onEnd: ()=>afterVisualMove(),
                        key: key,
                        duration: const Duration(seconds:1),
                        top: (cellSize-kekerSize)/2+cellSize*value.x,
                        left: (cellSize-kekerSize)/2+cellSize*value.y,
                        child: Container(
                          width: kekerSize,
                          height: kekerSize,
                          decoration: BoxDecoration(
                            color: value.isSecond? Colors.red:Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3)
                          ),
                          child: value.isModify?const Center(child: Text("Д")):null,
                          //child: GestureDetector(onTap: ()=>visualMove(value[0], value[1]),)
                        ),):Container();
                    }
                  ),
                ],
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _logNotifier,
              builder: (_, String value, __) {
                return SizedBox(
                  width: shortestSide*(MediaQuery.of(context).orientation == Orientation.landscape?0.25:0.6),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(value),
                  ),
                );
              }
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>_init(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class Kekeri extends StatelessWidget {
  const Kekeri({
    Key? key, 
    required this.list, 
    this.callback, 
    required this.cellSize, 
    required this.kekerSize 
  }) : super(key: key);
  final List<Keker> list;
  final Function(int,int)? callback;
  final double cellSize;
  final double kekerSize;

  List<Widget> kekers(){
    List<Widget> result = [];

    var t = Game.getAll();
    var padd = (cellSize-kekerSize)/2;
    for(int i=0;i<t.length;i++){
      result.add(
        Positioned(
          top: padd+cellSize*t[i].X,
          left: padd+cellSize*t[i].Y,
          child: GestureDetector(
            onTap: ()=>callback?.call(t[i].X, t[i].Y),
            child: Container(
              width: kekerSize,
              height: kekerSize,
              decoration: BoxDecoration(
                color: t[i].isSecond?Colors.red:Colors.green,
                shape: BoxShape.circle
              ), 
              child: t[i].isModify?const Center(child: Text("Д")):null,
            ),
          ),
        )
      );
    }
    
    return result;
  }

  @override
  Widget build(BuildContext context) {
    //print("generate kekeri");
    return Stack(
      children: 
      [
        ...kekers(),
      ],
    );
  }
}


class Cell extends StatelessWidget {
  const Cell({
    Key? key, this.color=Colors.black,
    required this.size,
    this.call
  }) : super(key: key);
  final double size;
  final Color color;
  final Function? call;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: color,
      child: GestureDetector(
        onTap: ()=>call?.call(),
      ),
    );
  }
}


class Board extends StatelessWidget {
  const Board({ Key? key, required this.callback, required this.cellSize }) : super(key: key);
  final Function(int,int) callback;
  final double cellSize;

  List<Widget> area({Function(int,int)? callback}){
    List<Widget> result = [];
    bool f = false;
    for(int i=0;i<64;i++){
      Color color;
      bool b=i%2==0;
      if(i%8==0){
        f=!f;
      }

      if(f){
        b=!b;
      }
      
      color=b?Colors.brown:Colors.grey;
      result.add(
        Cell(
          size: cellSize,
          color: color, 
          //call: b?()=>callback?.call(i~/8,i%8):null,
          call: ()=>callback?.call(i~/8,i%8),
        )
      );
    }
    return result;
  }
  

  @override
  Widget build(BuildContext context) {
    //print("generate");
    return GridView(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: cellSize,
      ),
      children: area(callback: callback),
    );
  }
}