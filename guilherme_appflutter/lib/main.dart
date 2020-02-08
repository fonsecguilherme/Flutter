// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //StatelessWidget faz do widget um app
  @override
  //widget provê um build que descreve como mostrar o widget
  //The body for this example consists of a Center widget containing a Text child widget.
  //The Center widget aligns its widget subtree to the center of the screen.
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "First app, name generator",
      theme: ThemeData(
        primaryColor: Colors.blueGrey[900],
      ),
      home: RandomWords(),
      /*   title: 'Welcome to Flutter',
      home: Scaffold(
        //fornece um app bar, titulo e um body
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          //child: Text('Hello World'),
          child:
              RandomWords(), //Pascalcase indica que cada palavra da sring começa com letra maiúscula
        ),
      ), */
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  @override
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final Set<WordPair> _saved = Set<WordPair>();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("First App, name generator"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        // ** itemBuilder chamado uma vez por palavra sugerida e coloca cada sugestão num ListTitle
        if (i.isOdd) {
          return Divider();
        }

        final index = i ~/
            2; //divide por 2 e retorna o inteiro //** um pixel entre cada linha no ListView
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(
              10)); //* se atingiu fim da lista, gera mais 10 palavras para lista de sugestões
        }
        return _buildRow(_suggestions[
            index]); //** _buildRow é chamado uma vez por par de palavras, mostra cada novo par na ListTitle
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved =
        _saved.contains(pair); //** garante que a palavra ainda não foi marcada
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.redAccent : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map((WordPair pair) {
            return ListTile(
              title: Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
            );
          });
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text("Suggestions Saved"),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}

//The RandomWords widget does little else beside creating its State class
class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}
