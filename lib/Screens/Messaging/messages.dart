import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mango/Models/cloud/post_services.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Models/customModel/chat.dart';
import 'package:mango/Models/customModel/user.dart';
import 'package:mango/Models/widgets.dart';
import 'package:mango/Screens/Messaging/widgets/conversation_list.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final UserService _userService = UserService();
  final PostService _postService = PostService();
  List<ChatUsers> chatUsers = [
    ChatUsers(name: "NO NOISE", messageText: "Awesome Setup", imageURL: "asset/dp.jpeg", time: "Now"),
    ChatUsers(name: "Abeni", messageText: "That's Great",imageURL: "asset/dp_f.jpeg", time: "Yesterday"),
    ChatUsers(name: "Simiat", messageText: "Hey where are you?",imageURL: "asset/dp.jpeg", time: "31 Mar"),
    ChatUsers(name: "Philip", messageText: "Busy! Call me in 20 mins",imageURL: "asset/dp_f.jpeg", time: "28 Mar"),
    ChatUsers(name: "Deborah", messageText: "Thank you, It's awesome",imageURL: "asset/dp.jpeg", time: "23 Mar"),
    ChatUsers(name: "Apena", messageText: "will update you in evening",imageURL: "asset/dp_f.jpeg", time: "17 Mar"),
    ChatUsers(name: "RPD Lee", messageText: "Can you please share the file?",imageURL: "asset/dp.jpeg", time: "24 Feb"),
    ChatUsers(name: "Mango", messageText: "Hello welcome to Mango.",imageURL: "asset/images/mango.png", time: "18 Feb"),
  ];
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: const CloseButton(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16,right: 16,top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text("Conversations",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),
                    Container(
                      padding: const EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.pink[50],
                      ),
                      child: Row(
                        children: const <Widget>[
                          Icon(Icons.add,color: Colors.pink,size: 20,),
                          SizedBox(width: 2,),
                          Text("Add New",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),



            SizedBox(
              height: 100,
              child: StreamProvider.value(
                value: _userService
                    .getAllUsers(FirebaseAuth.instance.currentUser!.uid),
                initialData: const <MangoUser>[],
                child: const ChatCircle(),),
            ),






            // Padding(
            //   padding: const EdgeInsets.only(top: 16,left: 16,right: 16),
            //   child: TextField(
            //     decoration: InputDecoration(
            //       hintText: "Search...",
            //       hintStyle: TextStyle(color: Colors.grey.shade600),
            //       prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
            //       filled: true,
            //       fillColor: Colors.grey.shade100,
            //       contentPadding: EdgeInsets.all(8),
            //       enabledBorder: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(20),
            //           borderSide: BorderSide(
            //               color: Colors.grey.shade100
            //           )
            //       ),
            //     ),
            //   ),
            // ),

            // ListView.builder(
            //   itemCount: chatUsers.length,
            //   shrinkWrap: true,
            //   padding: const EdgeInsets.only(top: 16),
            //   physics: const BouncingScrollPhysics(),
            //   itemBuilder: (context, index){
            //     return ConversationList(
            //       name: chatUsers[index].name,
            //       messageText: chatUsers[index].messageText,
            //       imageUrl: chatUsers[index].imageURL,
            //       time: chatUsers[index].time,
            //       isMessageRead: (index == 0 || index == 3)?true:false,
            //     );
            //   },
            // ),
            // FutureProvider.value(
            //     value: _userService.getConversation(),
            //     initialData: const <Message>[],
            //     child: const ConversationList()

            SizedBox(
              height: 900,
              child: FutureProvider.value(
                value: _userService
                    .getConversationInfo(FirebaseAuth.instance.currentUser!.uid),
                initialData: const <Message>[],
                child: const ConversationList(),
              ),
            ),


            // StreamProvider.value(
            //             value: _postService
            //                 .getConvos()),
            //             initialData: const <Message>[],
            //   child: const ConversationList(),

              // ListView.builder(
              //   itemCount: Provider.of<List<Message>>(context).length,
              //   shrinkWrap: true,
              //   padding: const EdgeInsets.only(top: 16),
              //   physics: const BouncingScrollPhysics(),
              //   itemBuilder: (context, index){
              //     var conversation = Provider.of<List<Message>>(context)[index];
              //     return ConversationList(
              //       name: conversation.userId,
              //       messageText: conversation.text,
              //       imageUrl: "asset/images/mango.png",
              //       time: "jan 3",
              //       isMessageRead: (index == 0 || index == 3)?true:false,
              //     );
              //   },
              // ),
            // ),
          ],
        ),
      ),
    );
  }
}
