import 'package:flutter/material.dart';
import 'package:warranty_admin/provider/auth_service.dart';
import 'package:warranty_admin/models/data_model/item_expired_model.dart';

class ItemExpiredList extends StatefulWidget {
  ItemExpiredList({Key key}) : super(key: key);

  @override
  _ActiveUsersListState createState() => _ActiveUsersListState();
}

class _ActiveUsersListState extends State<ItemExpiredList> {
  List<ExpiredProductModel> _info = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Item Expired'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              }),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 10, right: 10),
          color: Colors.grey[200],
          child: FutureBuilder<Map<String, dynamic>>(
            future: AuthService.itemExpired(),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data['expired_product_list'];

                for (var i = 0; i < data.length; i++) {
                  _info.add(ExpiredProductModel.fromJson(data[i]));
                }
                //
                print(data.length);
                return _activeUserBody(context);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else {
                return Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(),
                    height: 25.0,
                    width: 25.0,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  _activeUserBody(context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _info.length,
        itemBuilder: (context, index) {
          return _tile(
            _info[index].bname,
            _info[index].bemail,
            _info[index].bphone,
            _info[index].productBrand,
            _info[index].productModel,
            _info[index].partsWarrenty,
          );
        });
  }

  Card _tile(
    var bName,
    var bEmail,
    var bPhone,
    var productBrand,
    var productModel,
    var partsWarranty,
  ) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Name : '),
                        Text(
                          bName ?? 'null',
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text('Email : '),
                        Text(bEmail ?? 'null'),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text('Phone : '),
                        Text(bPhone ?? 'null'),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text('Brand : '),
                        Text(productBrand ?? 'null'),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text('Model : '),
                        Text(productModel ?? 'null'),
                      ],
                    ),
                    SizedBox(height: 5),
                    /* ExpansionTile(
                      title: Text("Sub Parts List"),
                      children: [
                        Text(partsWarranty),
                      ],
                    ), */
                  ],
                ),
              ),

              /* trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  print('Trailing preesed');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UsersDeatils(usersDeatils: info),
                    ),
                  );
                },
              ), */
            ),
          ],
        ),
      ),
    );
  }
}
