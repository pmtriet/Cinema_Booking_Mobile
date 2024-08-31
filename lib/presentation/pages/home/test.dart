/*
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final controller=ScrollController();

  List<String>items=[];
  bool hasMore=true;

  int page=1;
  bool isLoading=false;

  @override
  void initState(){
    super.initState();
    fetch();
    controller.addListener(() {
      if(controller.position.maxScrollExtent==controller.offset){
        fetch();
      }
    });
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose(); 
  }
  Future fetch()async{
    if(isLoading) return;
    isLoading=true;

    const limit=10;
    final response=http.get('https://loadmore>limit=$limit&page=$page');
    final List newItems=json.decode(reponse.body);
    setState(() {
      page++;
      isLoading=false;
      if(newItems.length<limit){
        hasMore=false;
      }
      items.addAll(newItems);
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: ListView.builder(
        controller: controller,
        itemCount: items.length+1,
        itemBuilder: (context,index){
          if(index<items.length){
            final item=items[index];
            return ListTile(title: Text(item),);
          }
          else{
            return Center(child:hasMore? CircularProgressIndicator() : Text('No more data'),);
          }
          
        }
      ),
    );
  }
}
*/