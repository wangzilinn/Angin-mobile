import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/models/card_detail_model.dart';
import 'package:word_front_end/models/card_title_model.dart';
import 'package:word_front_end/services/card_service.dart';
import 'package:word_front_end/services/config_service.dart';
import 'package:word_front_end/views/card_delete_view.dart';
import 'package:word_front_end/views/card_detail_view.dart';
import 'package:word_front_end/views/card_edit_view.dart';
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
        title: Text("Today's cards"),
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
                    confirmDismiss: (direction) =>
                        _confirmDismiss(direction, index),
                    background: Container(
                        child: Builder(builder: (_) {
                          return Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                              colors: [Colors.blue, Colors.red],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )),
                            padding: EdgeInsets.only(left:16, right: 16),
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
                          );
                        })),
                    child: ListTile(
                      title: Text(cardTitle.key,
                          style: TextStyle(
                              fontSize: 19,
                              color: cardTitle.status == CardStatus.READY
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey)),
                      subtitle: Text(
                        cardTitle.expirationTime,
                        style: TextStyle(fontSize: 13),
                      ),
                      onTap: () {

                        if (cardTitle.status == CardStatus.READY) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => CardDetailView(
                                  cardService.getCardDetail(index))));
                        }else{
                          Fluttertoast.showToast(
                              msg: "Done",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 12.0
                          );
                        }
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

  Future<bool> _confirmDismiss(DismissDirection direction, int index) async {
    bool result;
    switch (direction) {
      case DismissDirection.endToStart:
        print("从右往左滑");
        final deleteOption = await showDialog(
            context: context, builder: (_) => CardDeleteView());
        switch (deleteOption) {
          case DeleteOption.No:
            result = false;
            break;
          case DeleteOption.Permanently:
          case DeleteOption.Temporarily:
          default:
            cardService.deleteOneCard(index, deleteOption);
            result = true;
        }
        break;
      case DismissDirection.startToEnd:
        print("从左往右滑");
        //TODO:进入查看+编辑界面
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => CardEditView(cardService.getCardDetail(index))));
        result = false;
        break;
      default:
        result = false;
    }
    //必须刷新一次,让index更新
    setState(() {});
    return result;
  }
}
