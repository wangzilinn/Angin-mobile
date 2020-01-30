import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/models/card_detail_model.dart';
import 'package:word_front_end/models/card_title_model.dart';
import 'package:word_front_end/services/card_service.dart';
import 'package:word_front_end/services/config_service.dart';
import 'package:word_front_end/views/card_detail_view.dart';
import 'package:word_front_end/views/settings_view.dart';

class CardListView extends StatefulWidget {
  @override
  _CardListViewState createState() => _CardListViewState();
}

class _CardListViewState extends State<CardListView> {
  CardService get cardService => GetIt.I<CardService>();

  ConfigService get configService => GetIt.I<ConfigService>();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("today cards"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => SettingsView()));
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Builder(
          builder: (_) {
            if (_isLoading) {
              return CircularProgressIndicator();
            }

            if (!cardService.hasDownloadCardList) {
              return Center(
                child: Text("从服务器获取卡片数据失败"),
              );
            }

            return ListView.separated(
                itemBuilder: (_, index) {
                  CardTitleModel cardTitle = cardService.getCardTitle(index);

                  return Dismissible(
                    key: ValueKey(cardTitle.key),
                    direction: DismissDirection.horizontal,
                    confirmDismiss: (direction) async {
                      print(direction);
                      return false;
                    },
                    background: Container(
                        color: Colors.red,
                        child: Builder(
                            builder: (_) {
                              var leftPart = Expanded(
                                child: Container(
                                  color: Colors.red,
                                  padding: EdgeInsets.only(left: 16),
                                  child: Align(
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    alignment: Alignment.centerLeft,
                                  ),
                                ),
                              );

                              var rightPart = Expanded(
                                child: Container(
                                  color: cardTitle.status == CardStatus.READY
                                      ? Colors.red
                                      : Colors.blue,
                                  padding: EdgeInsets.only(right: 16),
                                  child: Align(
                                    child: Icon(
                                      cardTitle.status == CardStatus.READY
                                          ? Icons.delete
                                          : Icons.details,
                                      color: Colors.white,
                                    ),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              );
                              return Row(
                                children: <Widget>[
                                  leftPart,
                                  rightPart,
                                ],
                              );
                            }
                        )),
                    child: ListTile(
                      title: Text(cardTitle.key,
                          style: TextStyle(
                              fontSize: 19,
                              color: Theme
                                  .of(context)
                                  .primaryColor)),
                      subtitle: Text(
                        cardTitle.expirationTime,
                        style: TextStyle(fontSize: 13),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) =>
                                CardDetailView(
                                    cardService.getCardDetail(index))));
                      },
                    ),
                  );
                },
                separatorBuilder: (_, __) {
                  return Divider(
                    height: 1,
                    color: Colors.green,
                  );
                },
                itemCount: cardService.listLength);
          },
        ),
      ),
    );
  }

  void _fetchCards() async {
    setState(() {
      _isLoading = true;
    });

    await cardService.downloadTodayCardList();

    setState(() {
      _isLoading = false;
    });
  }

  //下拉刷新
  Future<void> _onRefresh() async {
    _fetchCards();
    print("refresh");
  }
}
