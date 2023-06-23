import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '/models/message.dart';

class ChatWidgets {
  static Widget messagesCard(bool check, Message message, Function() deleteMessage) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (check) const Spacer(),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 250,
            ),
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: check ? Colors.deepPurpleAccent.shade700 : Colors.purple.shade900,
              ),
              child: Column(
                crossAxisAlignment: check ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          message.text!,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (check)
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: PopupMenuButton(
                            position: PopupMenuPosition.under,
                            color: Colors.white,
                            tooltip: 'Actions',
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: const Text(
                                  'Delete message',
                                ),
                                onTap: () {
                                  deleteMessage();
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 3),
                  ),
                  Text(
                    DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(message.dateSent!)),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!check) const Spacer(),
        ],
      ),
    );
  }
}
