import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final String query = r"""
                    query GetContinent($code : ID!){
                      continent(code:$code){
                        name
                        countries{
                          name
                          code
                        }
                      }
                    }
                  """;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GraphlQL Example"),
      ),
      body: Query(
          options: _queryOptions(),
          builder: (result, {fetchMore, refetch}) {
            print(result.data!['continent']['countries']);
            var countries = result.data!['continent']['countries'];
            if (result.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (result.data == null) {
              return const Center(
                child: Text("Data Not Found"),
              );
            }
            return CountriesList(countries: countries);
          }),
    );
  }

  QueryOptions<Object?> _queryOptions() {
    return QueryOptions(
        document: gql(query), variables: const <String, dynamic>{"code": "AF"});
  }
}

class CountriesList extends StatelessWidget {
  const CountriesList({
    super.key,
    required this.countries,
  });

  final countries;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: countries.length,
        itemBuilder: (context, index) {
          var country = countries[index];
          return ListTile(
            title: Text(
              country["name"],
            ),
            subtitle: Text(country["code"]),
          );
        });
  }
}
