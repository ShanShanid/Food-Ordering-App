import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_ordering_app/models/ApiError.dart';
import 'package:food_ordering_app/models/ApiRespose.dart';
import 'package:food_ordering_app/models/DishList.dart';
import 'package:food_ordering_app/models/UserDetails.dart';
import 'package:food_ordering_app/services/user_details_services.dart';
import 'package:food_ordering_app/views/widgets/msgToast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Forms/DishAddForm.dart';
import 'widgets/CatalogItemAdmin.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    final DishList args = ModalRoute.of(context).settings.arguments as DishList;
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.dehaze),
          onPressed: () {
            _ProfileHandler(context);
          },
        ),
        title: new Text("Swiggato - DashBoard"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {})
        ],
      ),
      body: CatalogList(dishList: args),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => DishAddForm()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

void _ProfileHandler(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String _userId = (prefs.getString("user_id") ?? "");
  if (_userId == "") {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      ModalRoute.withName('/home'),
    );
    showToastMsg("invalid Login State!");
  } else {
    ApiResponse _apiResponse = await getUserDetails(_userId);
    if ((_apiResponse.ApiError as ApiError) == null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/profile',
        ModalRoute.withName('/profile'),
        arguments: (_apiResponse.Data as UserDetails),
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        ModalRoute.withName('/home'),
      );
      showToastMsg("invalid Login State!");
    }
  }
}

class CatalogList extends StatelessWidget {
  final DishList dishList;

  CatalogList({Key key, this.dishList});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: dishList.length,
      itemBuilder: (context, index) {
        return CatalogItemAdmin(dish: dishList.getIndex(index));
      },
    );
  }
}
