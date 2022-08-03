import 'package:flutter/material.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Models/customModel/chat.dart';
import 'package:mango/Screens/Messaging/widgets/reply_message.dart';

import '../../../Models/customModel/user.dart';

class NewMessageWidget extends StatefulWidget {
  final FocusNode focusNode;
  final MangoUser mangoUser;
  String? idUser;
  Message? replyMessage;
  final VoidCallback onCancelReply;

  NewMessageWidget({
    required this.focusNode,
    this.idUser,
    this.replyMessage,
    required this.onCancelReply,
    Key? key, required this.mangoUser,
  }) : super(key: key);

  @override
  _NewMessageWidgetState createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  final UserService _userService = UserService();
  final _controller = TextEditingController();
  String message = '';

  static const inputTopRadius = Radius.circular(12);
  static const inputBottomRadius = Radius.circular(24);

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    widget.onCancelReply();

    try {
      await _userService.uploadMessage(widget.idUser, message, widget.replyMessage?.text);
      await UserService().registerConversation(widget.idUser, message);
    } catch (e) {
      print("this is $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have been banned for using bad words'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
    setState((){
      message = '';
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isReplying = widget.replyMessage != null;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: [
                if (isReplying) buildReply(),
                TextField(
                  focusNode: widget.focusNode,
                  controller: _controller,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  enableSuggestions: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Type a message',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.only(
                        topLeft: isReplying ? Radius.zero : inputBottomRadius,
                        topRight: isReplying ? Radius.zero : inputBottomRadius,
                        bottomLeft: inputBottomRadius,
                        bottomRight: inputBottomRadius,
                      ),
                    ),
                  ),
                  onChanged: (value) => setState(() {
                    message = value;
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: sendMessage,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReply() => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: const BorderRadius.only(
            topLeft: inputTopRadius,
            topRight: inputTopRadius,
          ),
        ),
        child: ReplyMessageWidget(
          message: widget.replyMessage,
          onCancelReply: widget.onCancelReply,
        ),
      );
}
