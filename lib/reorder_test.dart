import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'globalFunction.dart';
import 'lessonDetail.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.indigo,
        accentColor: Colors.pinkAccent,
      ),
      home: ExampleScreen(),
    ),
  );
}

class ExampleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: ReorderableFirebaseList(
          collection: FirebaseFirestore.instance.collection('test'),
          indexKey: 'pos',
          itemBuilder: (BuildContext context, int index, DocumentSnapshot doc) {
            return ListTile(
              key: Key(doc.id),
              title: Text("tr"),
            );
          },
        ),
      ),
    );
  }
}

typedef ReorderableWidgetBuilder = Widget Function(
    BuildContext context, int index, DocumentSnapshot doc);

class ReorderableFirebaseList extends StatefulWidget {
  const ReorderableFirebaseList({
    Key? key,
    required this.collection,
    required this.indexKey,
    required this.itemBuilder,
    this.descending = false,
  }) : super(key: key);

  final CollectionReference collection;
  final String indexKey;
  final bool descending;
  final ReorderableWidgetBuilder itemBuilder;

  @override
  _ReorderableFirebaseListState createState() =>
      _ReorderableFirebaseListState();
}

class _ReorderableFirebaseListState extends State<ReorderableFirebaseList> {
  late List<DocumentSnapshot> docs;
  late Future saving;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: saving,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.none ||
            snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder<QuerySnapshot>(
            stream: widget.collection
                .orderBy(widget.indexKey, descending: widget.descending)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                docs = snapshot.data?.docs ?? [];
                return ReorderableListView(
                  onReorder: _onReorder,
                  children: List.generate(docs.length, (int index) {
                    return widget.itemBuilder(context, index, docs[index]);
                  }),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;

    docs.insert(newIndex, docs.removeAt(oldIndex));
    final futures = <Future>[];
    for (int pos = 0; pos < docs.length; pos++) {
      futures.add(docs[pos].reference.update({widget.indexKey: pos}));
    }
    setState(() {
      saving = Future.wait(futures);
    });
  }
}
