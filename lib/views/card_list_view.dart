import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/models/displayed_card_model.dart';
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

  List<DisplayedCardModel> _cardList;
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

            if (_cardList == null) {
              return Center(
                child: Text("从服务器获取数据失败"),
              );
            }
            return ListView.separated(
                itemBuilder: (_, index) {
                  return ListTile(
                    title: Text(_cardList[index].key,
                        style: TextStyle(color: Theme.of(context).primaryColor)),
                    subtitle: Text(_cardList[index].expireDate),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>
                              CardDetailView(_cardList[index])));
                    },
                  );
                },
                separatorBuilder: (_, __) {
                  return Divider(
                    height: 1,
                    color: Colors.green,
                  );
                },
                itemCount: _cardList.length);
          },
        ),
      ),
    );
  }

  void _fetchCards() async {
    setState(() {
      _isLoading = true;
    });

    _cardList = await cardService.getTodayCardList();

    setState(() {
      _isLoading = false;
    });
  }

  //下拉刷新
  Future<void> _onRefresh() async{
    _fetchCards();
    print("refresh");
  }
}




