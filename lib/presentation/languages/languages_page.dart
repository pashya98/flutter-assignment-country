import 'package:cbnits/generated/l10n.dart';
import 'package:cbnits/presentation/languages/languages_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguagesPage extends StatefulWidget {
  const LanguagesPage({Key? key}) : super(key: key);

  @override
  _LanguagesPageState createState() => _LanguagesPageState();
}

class _LanguagesPageState extends State<LanguagesPage> {
  @override
  void initState() {
    super.initState();
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<LanguagesViewModel>(context, listen: false).loadingStatus ==
        0) {
      Future.delayed(
          const Duration(milliseconds: 100),
          () => {
                Provider.of<LanguagesViewModel>(context, listen: false)
                    .getAllLanguages((message) => showMessage(message))
              });
    }
    return Consumer<LanguagesViewModel>(builder: (context, model, child) {
      return Scaffold(
          appBar: AppBar(title: Text(S.of(context).languages)),
          floatingActionButton:
              _buildFloatingActionButtonWidget(context, model),
          body: Stack(
            children: [
              if (model.loadingStatus == 1)
                const Center(child: CircularProgressIndicator()),
              ListView.separated(
                itemCount: model.languageList.length,
                itemBuilder: (context, index) {
                  return _buildListItemWidget(context, model, index);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(height: 1);
                },
              ),
            ],
          ));
    });
  }

  Widget _buildFloatingActionButtonWidget(
      BuildContext context, LanguagesViewModel model) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pop(
            context,
            model.languageFilter >= 0
                ? model.languageList[model.languageFilter].name
                : null);
      },
      child: const Icon(Icons.done),
    );
  }

  Widget _buildListItemWidget(
      BuildContext context, LanguagesViewModel model, int index) {
    return InkWell(
      onTap: () {
        model.onSelectLanguage(index);
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                        "${model.languageList[index].name} (${model.languageList[index].code})"),
                  ),
                  Text("${model.languageList[index].native}"),
                ],
              ),
            ),
          ),
          Visibility(
              visible: model.languageList[index].isSelected,
              child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.done, color: Colors.blue)))
        ],
      ),
    );
  }
}
