
import 'dart:math';

class Game{
  static List<Keker?> _area = List.filled(64, null);
  static GameLog _log = GameLog();
  static Keker? _selectedKeker;
  static Keker? _lastSelectedKeker;

  static bool isGreenTurn = true;
  static bool _canReselect = true;

  static void init(){
    _lastSelectedKeker=null;
    _selectedKeker=null;
    isGreenTurn = true;
    _canReselect = true;
    _log = GameLog();
    _log.setWhoTurn(isGreenTurn);

    _area = List.filled(64, null);

    /*_setCeil(1,2, isSecond: true);
    _setCeil(1,6);
    _setCeil(1,4);
    _setCeil(6,5, isSecond: true);
    _setCeil(6,7, isSecond: true);*/

    _setCeil(0,1, isSecond: true);
    _setCeil(0,3, isSecond: true);
    _setCeil(0,5, isSecond: true);
    _setCeil(0,7, isSecond: true);

    _setCeil(1,0, isSecond: true);
    _setCeil(1,2, isSecond: true);
    _setCeil(1,4, isSecond: true);
    _setCeil(1,6, isSecond: true);

    _setCeil(2,1, isSecond: true);
    _setCeil(2,3, isSecond: true);
    _setCeil(2,5, isSecond: true);
    _setCeil(2,7, isSecond: true);


    _setCeil(5,0);
    _setCeil(5,2);
    _setCeil(5,4);
    _setCeil(5,6);

    _setCeil(6,1);
    _setCeil(6,3);
    _setCeil(6,5);
    _setCeil(6,7);

    _setCeil(7,0);
    _setCeil(7,2);
    _setCeil(7,4);
    _setCeil(7,6);

  }

  static void _setCeil(int i, int j, {bool isSecond = false}){
    var t = Keker(i, j, isSecond: isSecond);
    _area[i*8+j]=t;
  } 

  static void move(int x, int y){
    if(_selectedKeker!=null){
      var kill = _selectedKeker!.canKillMove(_area, x, y);
      if(kill.canKill){
        _area[kill.victimX*8+kill.victimY]=null;

        _area[_selectedKeker!.X*8+_selectedKeker!.Y]=null;
        _selectedKeker!.move(x, y);
        _area[x*8+y]=_selectedKeker;
        _selectedKeker=null;
        _makeKing();
        _lastSelectedKeker=_area[x*8+y];
        
        if(_area[x*8+y]!.canKill(_area)){
          _selectedKeker=_area[x*8+y];
          _canReselect=false;
        }else{
          if(_checkWinner(_area[x*8+y]!.isSecond)){
            _log.setWinner(!_area[x*8+y]!.isSecond);
          }
          isGreenTurn=!isGreenTurn;
          _canReselect=true;

          _log.setWhoTurn(isGreenTurn);
        }
        _log.message="";
      }
      else if(_someoneCanKill(_selectedKeker!.isSecond)){
        _log.message="you must kill";
      }
      else if(_selectedKeker!.canMove(_area, x, y)){
        _area[_selectedKeker!.X*8+_selectedKeker!.Y]=null;
        _selectedKeker!.move(x, y);
        _area[x*8+y]=_selectedKeker;
        _selectedKeker=null;
        _makeKing();
        _lastSelectedKeker=_area[x*8+y];
        //_selectedKeker=_area[x*8+y];
        isGreenTurn=!isGreenTurn;
        _canReselect=true;

        _log.setWhoTurn(isGreenTurn);
        _log.message="";
      }
      else {
        if(_someoneCanMove(_selectedKeker!.isSecond)){
          _log.message="move another way";
        }else{
          _log.setWinner(!isGreenTurn);
        } 
      }
      
    }
    
  }

  static bool _checkWinner(bool isGreen){
    bool win = true;
    for (var element in _area) {
      if(element!=null&&element.isSecond!=isGreen){
        win=false;
        break;
      }
    }
    return win;
  }
  static bool _someoneCanMove(bool isGreen){
    bool result = false;
    for (var element in _area) {
      if(element!=null&&element.isSecond==isGreen){
        result = element.analyzeDiagonalsForMove(_area);
        if(result)break;
      }
    }
    return result;
  }
  static bool _someoneCanKill(bool isGreen){
    bool result = false;
    for (var element in _area) {
      if(element!=null&&element.isSecond==isGreen){
        result = element.canKill(_area);
        if(result)break;
      }
    }
    return result;
  }

  static void _makeKing(){
    for(int i = 0;i < 8;i++){
      if(_area[i] is! KingKeker&&_area[i]!=null&&!_area[i]!.isSecond){
        _area[i]=KingKeker(_area[i]!.X,_area[i]!.Y,isSecond: _area[i]!.isSecond);
      }
      var index = 7*8+i;
      if(_area[index] is! KingKeker&&_area[index]!=null&&_area[index]!.isSecond){
        _area[index]=KingKeker(_area[index]!.X,_area[index]!.Y,isSecond: _area[index]!.isSecond);
      }
    }
  }

  static List<Keker> getAll(){
    var t = _area.where((element) => element!=null).toList();
    if(_selectedKeker!=null){
      t.removeWhere((element) => element!.X==_selectedKeker!.X&&element.Y==_selectedKeker!.Y);
    }
    
    return List.unmodifiable(t);
  }

  static Keker? getSelected()=>_selectedKeker;
  static Keker? getLastSelected()=>_lastSelectedKeker;
  static String get logMessage=>_log.logs();
  
  static String select(int x, int y){
    var selected = _area[x*8+y];

    if(selected!.isSecond!=isGreenTurn&&_canReselect){
      _selectedKeker = selected;
      _lastSelectedKeker=selected;
    }
    
    return 'you chose: ${_selectedKeker?.X}-${_selectedKeker?.Y}';
  }
}


class Keker {
  int _col=0;
  int _row=0;
  final bool isSecond;

  Keker(this._col, this._row, {this.isSecond=false});

  int get X =>_col;
  int get Y =>_row;

  bool get isModify => false;

  void move(int x, int y){
    _col=x;
    _row=y;
  }

  bool canMove(List<Keker?> area, int x, int y){
    int dir = isSecond?1:-1;
    bool move = (x-X)==dir&&(y-Y).abs()==1;
    move=move&&area[x*8+y]==null;
    return move;
  }

  KillInfo canKillMove(List<Keker?> area, int x, int y){
    var moveInfo = analyzeMove(area, x, y);
    KillInfo result = KillInfo();
    if(moveInfo.distance<=2&&moveInfo.freeEnd&&moveInfo.enemies.length==1&&moveInfo.ally==0){
      result.canKill=true;
      result.victimX=moveInfo.enemies.first.X;
      result.victimY=moveInfo.enemies.first.Y;
    }
    return result;
  }

  MoveInfo analyzeMove(List<Keker?> area, int x, int y){
    bool freeEnd = true;
    List<Keker> enemies = [];
    int ally = 0;
    int distance = 0;

    if((x-X).abs()!=(y-Y).abs())return MoveInfo(false, enemies, ally, distance);

    int i = X;
    int j = Y;
    while(i!=x&&j!=y){
      distance++;
      i+=1*(x-X).sign;
      j+=1*(y-Y).sign;
      if(area[i*8+j]!=null){
        if(area[i*8+j]!.isSecond!=isSecond){
          enemies.add(area[i*8+j]!);
        }
        if(area[i*8+j]!.isSecond==isSecond){
          ally++;
        }
        freeEnd=!(i==x&&j==y);
      }
    }

    return MoveInfo(freeEnd, enemies, ally, distance);
  }

  bool canKill(List<Keker?> area, {int n=2}){
    return analyzeDiagonalForKill(area, -1, -1, n: n)
      ||analyzeDiagonalForKill(area, -1, 1, n: n)
      ||analyzeDiagonalForKill(area, 1, -1, n: n)
      ||analyzeDiagonalForKill(area, 1, 1, n: n);
  } 
  bool analyzeDiagonalForKill(List<Keker?> area, int dirX, int dirY, {int n=7} ){
    int i = X;
    int j = Y;

    for(int count=0;count<n;count++){
      i+=1*dirX;
      j+=1*dirY;
      if(i<0||i>7||j<0||j>7){
        i-=1*dirX;
        j-=1*dirY;
        break;
      }

      //print('$i - $j');
    }

    n=min((i-X).abs(),n);
    i = X;
    j = Y;
    //print('is $n');
    
    bool enemy=false;
    bool freeEnd=false;
    bool canKill = false;

    int ally = 0;
    
    int step = 0;
    while(n!=step){
      step++;
      i+=1*dirX;
      j+=1*dirY;
      if(enemy){
        freeEnd=area[i*8+j]==null;
        break;
      }
      else if(area[i*8+j]!=null){
        if(area[i*8+j]!.isSecond!=isSecond){
          enemy=true;
        }
        if(area[i*8+j]!.isSecond==isSecond){
          ally++;
        }
      }
    }
    canKill=freeEnd&&enemy&&ally==0;

    //print('canOnDiagonalKill: $canKill');
    return canKill;
  }


  bool analyzeDiagonalsForMove(List<Keker?> area){
    bool kek(int dirX, int dirY){
      bool move = true;
      int i = X;
      int j = Y;
      
      i+=1*dirX;
      j+=1*dirY;
      if(i<0||i>7||j<0||j>7){
        i-=1*dirX;
        j-=1*dirY;
        move=false;
      }else{
        move=canMove(area, i, j);
      }
      return move;
    }
    return kek(-1,-1)||kek(-1,1)||kek(1,-1)||kek(1,1);
  }
    
}

class KingKeker extends Keker{
  KingKeker(int col, int row, {bool isSecond=false}) : super(col, row, isSecond: isSecond);

  
  @override
  bool get isModify => true;

  @override
  KillInfo canKillMove(List<Keker?> area, int x, int y){
    
    var moveInfo = analyzeMove(area, x, y);
    KillInfo result = KillInfo();
    if(moveInfo.freeEnd&&moveInfo.enemies.length==1&&moveInfo.ally==0){
      result.canKill=true;
      result.victimX=moveInfo.enemies.first.X;
      result.victimY=moveInfo.enemies.first.Y;
    }
    return result;
  }

  @override
  bool canKill(List<Keker?> area, {int n=7}){
    return super.canKill(area, n:n);
  }

  @override
  bool canMove(List<Keker?> area, int x, int y){
    bool move = (x-X).abs()==(y-Y).abs();
    if(move){
      var res = analyzeMove(area, x, y);


      move=res.freeEnd&&res.ally==0&&res.enemies.isEmpty;

      //print('${(x-X).sign}, ${(y-Y).sign}');
      //analyzeDiagonalForKill(area, (x-X).sign, (y-Y).sign);
      //print('canKillOnMove: ${canKillMove(area, x, y).canKill}');
      //res.show();
    }

    return move;
  }
}


class MoveInfo{
  bool freeEnd = true;
  List<Keker> enemies = [];
  int ally = 0;
  int distance = 0;

  MoveInfo(this.freeEnd, this.enemies, this.ally, this.distance);

  void show(){
    print('enemy: ${enemies.length}');
    print('ally: $ally');
    print('freeEnd: $freeEnd');
    print('distance: $distance');
  }
}

class KillInfo{
  bool canKill = false;
  int victimX = -1;
  int victimY = -1;
}

class GameLog{
  String winner="";
  String turn = "";
  String message="";

  void setWhoTurn(bool isGreen){
    turn=isGreen?"Green":"Red";
  }

  void setWinner(bool isGreen){
    winner=isGreen?"Green":"Red";
    message="game over";
  }

  String logs(){
    var result = 'winner: $winner\n';
    result += 'turn: $turn\n';
    result += 'message: $message';

    return result;
  }
}