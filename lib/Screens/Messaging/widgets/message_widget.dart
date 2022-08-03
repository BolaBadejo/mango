import 'package:flutter/material.dart';
import 'package:mango/Models/customModel/chat.dart';
import 'package:mango/Screens/Messaging/widgets/reply_message.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageWidget({
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);
    final width = MediaQuery.of(context).size.width;
    print("this is message ${message.text}");
    print("this is reply message ${message.replyMessage}");
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[

        if (!isMe)
          const CircleAvatar(
            backgroundImage: NetworkImage("https://randomuser.me/api/portraits/women/12.jpg"),
            maxRadius: 16,
          ),
          Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          constraints: BoxConstraints(maxWidth: width * 3 / 4),
          decoration: BoxDecoration(
            color: isMe ? Colors.blueGrey[50] : Colors.green[50],
            borderRadius: isMe
                ? borderRadius.subtract(BorderRadius.only(bottomRight: radius))
                : borderRadius.subtract(BorderRadius.only(bottomLeft: radius)),
          ),
          child: buildMessage(),
        )
      ],
    );
  }

  Widget buildMessage() {
    final messageWidget = Text(message.text);

    if (message.replyMessage == '') {
      return messageWidget;
    } else {
      return Column(
        crossAxisAlignment: isMe && message.replyMessage == ''
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          buildReplyMessage(),
          messageWidget,
        ],
      );
    }
  }

  Widget buildReplyMessage() {
    final replyMessage = message.replyMessage;
    final isReplying = replyMessage != '';

    if (!isReplying) {
      return Container();
    } else {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: RepliedMessageWidget(message: message, onCancelReply: () {  },),
      );
    }
  }
}