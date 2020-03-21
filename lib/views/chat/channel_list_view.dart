import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/services/application/chat_service.dart';

class ChannelListView extends StatefulWidget {
  @override
  _ChannelListViewState createState() => _ChannelListViewState();
}

class _ChannelListViewState extends State<ChannelListView> {
  ChatService get chatService => GetIt.I<ChatService>();
  bool _isLoading;

  @override
  void initState() async {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    await chatService.refreshChannelList();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Channel list"),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh(),
        child: Builder(
          builder: (_) {
            if (_isLoading) {
              return CircularProgressIndicator();
            }
            return ListView.separated(
                itemBuilder: (_, index) {
                  String channelName = chatService.channelList[index];
                  return Dismissible(
                    key: ValueKey(channelName),
                    direction: DismissDirection.startToEnd,
                    confirmDismiss: (direction) =>
                        _confirmDismiss(direction, index),
                    background: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: [Theme.of(context).primaryColor, Colors.red],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )),
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            child: Icon(
                              Icons.details,
                              color: Colors.white,
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                          Align(
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            alignment: Alignment.centerRight,
                          ),
                        ],
                      ),
                    ),
                    child: ListTile(
                      title: Text(channelName,
                          style: TextStyle(
                            fontSize: 19,
                          )),
                      onTap: () {},
                    ),
                  );
                },
                separatorBuilder: (_, __) {
                  return Divider(
                    height: 1,
                    color: Colors.green,
                  );
                },
                itemCount: chatService.channelList.length);
          },
        ),
      ),
    );
  }

  _onRefresh() async {
    await chatService.refreshChannelList();
  }

  _confirmDismiss(direction, int index) {
    print("dismiss");
  }
}
