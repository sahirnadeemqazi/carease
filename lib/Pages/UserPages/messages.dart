import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final List<String> _suggestions = [
    'United States',
    'Germany',
    'Canada',
    'United Kingdom',
    'France',
    'Italy',
    'Spain',
    'Australia',
    'India',
    'China',
    'Japan',
    'Brazil',
    'South Africa',
    'Mexico',
    'Argentina',
    'Russia',
    'Indonesia',
    'Turkey',
    'Saudi Arabia',
    'Nigeria',
  ];

  final List<String> _statesOfIndia = [
    'Andhra Pradesh',
    'Assam',
    'Arunachal Pradesh',
    'Bihar',
    'Goa',
    'Gujarat',
    'Jammu and Kashmir',
    'Jharkhand',
    'West Bengal',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Orissa',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Tripura',
    'Uttaranchal',
    'Uttar Pradesh',
    'Haryana',
    'Himachal Pradesh',
    'Chhattisgarh'
  ];
  final _formKey = GlobalKey<FormState>();

  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchField(
              suggestionState: Suggestion.expand,
              suggestionAction: SuggestionAction.next,
              suggestions:
              _suggestions.map((e) => SearchFieldListItem(e)).toList(),
              textInputAction: TextInputAction.next,
              controller: _searchController,
              searchInputDecoration: SearchInputDecoration(
                hintText: 'SearchField Example 1',
              ),
              // selectedValue: SearchFieldListItem(_suggestions[2], SizedBox()),
              maxSuggestionsInViewPort: 3,
              itemHeight: 45,
              onSuggestionTap: (x) {},
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
