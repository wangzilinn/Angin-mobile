import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:word_front_end/models/displayed_card_model.dart';
import 'package:word_front_end/models/rest_response_model.dart';
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

  RESTResponseModel<List<DisplayedCardModel>> _restResponseModel;
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
      body: Builder(
        builder: (_) {
          if (_isLoading) {
            return CircularProgressIndicator();
          }

          if (_restResponseModel.error) {
            return Center(
              child: Text(_restResponseModel.errorMessage),
            );
          }
          return ListView.separated(
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(_restResponseModel.data[index].key,
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  subtitle: Text(_restResponseModel.data[index].expireDate),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            CardDetailView(_restResponseModel.data[index])));
                  },
                );
              },
              separatorBuilder: (_, __) {
                return Divider(
                  height: 1,
                  color: Colors.green,
                );
              },
              itemCount: _restResponseModel.data.length);
        },
      ),
    );
  }

  void _fetchCards() async {
    setState(() {
      _isLoading = true;
    });

    _restResponseModel = await cardService.getCardList(
        reciteCardNumber: configService.maxReciteCardNumber,
        newCardNumber: configService.maxNewCardNumber);

    setState(() {
      _isLoading = false;
    });
  }
}
