import 'package:cbnits/generated/l10n.dart';
import 'package:cbnits/presentation/country/country_viewmodel.dart';
import 'package:cbnits/presentation/languages/languages_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CountryPage extends StatefulWidget {
  const CountryPage({Key? key}) : super(key: key);

  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final countryViewModel =
        Provider.of<CountryViewModel>(context, listen: false);
    if (countryViewModel.loadingStatus == 0) {
      Future.delayed(
          const Duration(milliseconds: 100),
          () => {
                countryViewModel
                    .getAllCountries((message) => showMessage(message))
              });
    }
    return Consumer<CountryViewModel>(builder: (context, model, child) {
      return Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).country_list),
            actions: [_buildAppActionButtonWidget(context, model)],
          ),
          backgroundColor: Colors.grey.shade300,
          floatingActionButton:
              _buildFloatingActionButtonWidget(context, model),
          body: Stack(
            children: [
              if (model.loadingStatus == 1)
                const Center(child: CircularProgressIndicator()),
              Column(
                children: [
                  if (model.loadingStatus == 2 &&
                      (model.countyList.isNotEmpty || model.isError))
                    _buildSearchEditTextWidget(context, model),
                  Expanded(
                    child: model.isError
                        ? Center(
                            child: Text(S.of(context).country_not_found,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 16)))
                        : ListView.builder(
                            itemCount: model.countyList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return _buildListItemWidget(
                                  context, model, index);
                            }),
                  ),
                ],
              ),
            ],
          ));
    });
  }

  Widget _buildListItemWidget(
      BuildContext context, CountryViewModel model, int index) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${model.countyList[index].name}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Text("${model.countyList[index].currency}",
                    style: const TextStyle(fontSize: 16)),
                Text(" (${model.countyList[index].code})",
                    style: const TextStyle(fontSize: 16)),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                      "${model.countyList[index].emoji} - ${model.countyList[index].phone}"),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Row(
                children: [
                  Text(S.of(context).languages,
                      style: const TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ),
            if (model.countyList[index].languages!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Wrap(
                  children: model.countyList[index].languages!
                      .map((item) => Text(
                          "${model.countyList[index].languages?[0].name} "
                          "(${model.countyList[index].languages?[0].code}), "))
                      .toList(),
                ),
              )
          ],
        ),
      ),
      // trailing: Text(model.countyList[index].languages[0].name),
    );
  }

  Widget _buildSearchEditTextWidget(
      BuildContext context, CountryViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: model.searchController,
        keyboardType: TextInputType.text,
        onChanged: (value) {
          model.inputText = value;
          model.onSearchChangeText(value);
        },
        onSubmitted: (value) {
          model.inputText = value;
        },
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
        ],
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            focusColor: Colors.grey.shade50,
            hintText: S.of(context).search_country_by_code,
            hintStyle: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(width: 1, color: Colors.grey.shade100)),
            suffixIcon: Visibility(
                visible: model.inputText.isNotEmpty,
                child: GestureDetector(
                    onTap: () {
                      model.clearFilter();
                      hideKeyboard();
                    },
                    child: const Icon(Icons.clear, color: Colors.grey)))),
      ),
    );
  }

  Widget _buildAppActionButtonWidget(
      BuildContext context, CountryViewModel model) {
    return Visibility(
      visible: model.filterText.isNotEmpty,
      child: GestureDetector(
        onTap: () {
          model.clearFilter();
          hideKeyboard();
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.clear),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButtonWidget(
      BuildContext context, CountryViewModel model) {
    return Visibility(
      visible: (model.loadingStatus == 2 && model.countyList.isNotEmpty),
      child: FloatingActionButton(
        onPressed: () async {
          hideKeyboard();
          var result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LanguagesPage()));
          if (result != null) {
            model.setLanguageFilter(result);
          } else {
            model.clearFilter();
          }
        },
        child: const Icon(Icons.filter_list),
      ),
    );
  }

  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
