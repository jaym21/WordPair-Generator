import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState(); //this will overwrite the create state
}

//this where we will build
class RandomWordsState extends State<RandomWords>{
  final _savedWordPairs = Set<WordPair>(); //set is to store the favourite worpairs selected  
  final _randomWordPairs = <WordPair>[]; //final means this variable is a constant i.e it cannot be reassigned directly
 
  Widget _buildList(){
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, item){        //builder makes the listview dynamic
        if(item.isOdd) return Divider();  //makes a division between each wordpair

        final index = item ~/2; //this calulates the no.of wordpairs in the widget minus the dividers

        if(index >= _randomWordPairs.length){  //it will genrate 10 new wordpairs as we scroll down
          _randomWordPairs.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_randomWordPairs[index]);
      },
    );
}

Widget _buildRow(WordPair pair){ //pair is the current index that is passed from _buildList Widget
  final alreadySaved = _savedWordPairs.contains(pair); //checking if the saved Wordpair already contains the current selected wordpair
  
  return ListTile(
    title: Text(pair.asPascalCase, style: TextStyle(fontSize: 18.0)),
    trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border, 
    color: alreadySaved ? Colors.red : null),
    onTap: (){
      setState(() {
        if(alreadySaved){
          _savedWordPairs.remove(pair);
        }else{
          _savedWordPairs.add(pair);
        }
      });
    },
  );
}

void _pushedSaved (){
  //navigator is used add another route to our app as our Home page is the bottom most route
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (BuildContext context){ //inside builder we write what we what to show in the new route
        final Iterable<ListTile> tiles = 
        _savedWordPairs.map((WordPair pair){
          return ListTile(
            title: Text(pair.asPascalCase, style: TextStyle (fontSize: 16.0))
          );
        });

        final List<Widget> divided = ListTile.divideTiles(
          context: context,
          tiles: tiles
        ).toList();  //to make list of the tiles

        //again making our App Bar for new page and displaying the Listview of favourite wordpairs 
        return Scaffold(
          appBar: AppBar(
            title: Text('Saved WordPairs'),
          ),
          body: ListView(children: divided),
        );
      }
    )
  );
}

   Widget build (BuildContext context){
     return Scaffold(
       appBar: AppBar(
        title: Text('Wordpair Generator'),
        actions: <Widget>[                          //making a icon button in app bar to show our favourites in new window
          IconButton(icon: Icon(Icons.list),        //when button is pressed _pushedSave function is called
          onPressed: _pushedSaved)
        ],
        ),
        body: _buildList(),
     );
   }
}