import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warranty_admin/const/style.dart';
import 'package:warranty_admin/items/expired_this_month/expire_this_month_list.dart';
import 'package:warranty_admin/items/item_register_buyer/item_register.dart';
import 'package:warranty_admin/items/item_under_warranty/item_under_warranty.dart';
import 'package:warranty_admin/items/requested_warranty/requested_warranty_list.dart';
import 'package:warranty_admin/items/warranty_on_process/warranty_on_process.dart';
import 'package:warranty_admin/login_screens/second_login.dart';
import 'package:warranty_admin/profile/edit_profile.dart';
import 'package:warranty_admin/profile/profile.dart';

import 'package:warranty_admin/provider/auth_service.dart';
import 'package:warranty_admin/items/active_users/active_users_list.dart';
import 'package:warranty_admin/items/item_expired/item_expired_list.dart';

class OriginalDashBoard extends StatefulWidget {
  final File selectedFile;
  final String adminEmailPhone;

  OriginalDashBoard({Key key, this.selectedFile, this.adminEmailPhone})
      : super(key: key);

  @override
  _OriginalDashBoardState createState() =>
      _OriginalDashBoardState(selectedFile, adminEmailPhone);
}

var refreshGlobalKey = GlobalKey<RefreshIndicatorState>();

class _OriginalDashBoardState extends State<OriginalDashBoard> {
  File selectedFile;
  String adminEmailPhone;
  _OriginalDashBoardState(this.selectedFile, this.adminEmailPhone);

  @override
  void initState() {
    super.initState();
    getAdminDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getAdminDetails() async {
    await StorageUtils.getAdminEmailPhone().then((emailPhone) {
      adminEmailPhone = emailPhone;
      print("value is ==> $emailPhone");
    });

    Provider.of<AuthService>(context, listen: false)
        .getAdminDetails(adminEmailPhone);

    Provider.of<AuthService>(context, listen: false).requestedItemNumber();
  }

  var baseUrl = 'https://warranty.rbfgroupbd.com/getstaffimage/';

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => exit(0),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Dashboard'),
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () {
                      print('You are logged out');
                      setState(() {
                        _logout();
                      });
                    },
                  ),
                ],
              ),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.green,
            ),
            body: (authService.getRes != null &&
                    authService.requestedNumber != null)
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[200],
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          /*  InkWell(
                            child: CircleAvatar(
                              backgroundImage: selectedFile == null
                                  ? NetworkImage(
                                      baseUrl + authService.getRes.staffID)
                                  : FileImage(widget.selectedFile),
                              backgroundColor: Colors.red,
                              radius: 45,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                    adminProfileData: authService.getRes,
                                    selectedFile: widget.selectedFile,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 8),
                          Text('Welcome ${authService.getRes.name}' ?? null),
                          SizedBox(height: 5),
                          InkWell(
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[900],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfile(
                                    updateAdminData: authService.getRes,
                                  ),
                                ),
                              );
                            },
                          ), */
                          Row(
                            children: [
                              GestureDetector(
                                child: Text(
                                  'Welcome ${authService.getRes.name}' ?? null,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                        adminProfileData: authService.getRes,
                                        selectedFile: widget.selectedFile,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: 25),
                          Row(
                            children: [
                              InkWell(
                                child: Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[900],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfile(
                                        updateAdminData: authService.getRes,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10),

                          //Expired Item
                          Row(
                            children: [
                              Text(
                                authService.requestedNumber.expiredItems
                                    .toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              InkWell(
                                child: Text(
                                  ' Items expired',
                                  style: normalStyle,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ItemExpiredList(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          //Expired This Month
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                authService.requestedNumber.expiredThisMonth
                                    .toString(),
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                  decoration: TextDecoration.underline,
                                ),
                              ), //_ExpiredThisMonthState
                              InkWell(
                                child: Text(
                                  ' Items expired this month',
                                  style: normalStyle,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ExpiredThisMonth(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          //Items On Process
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                authService.requestedNumber.onWarrantyProcess
                                    .toString(),
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                  decoration: TextDecoration.underline,
                                ),
                              ), //
                              InkWell(
                                child: Text(
                                  ' Items on warranty process',
                                  style: normalStyle,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OnWarrantyProcessList(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          //Iteams Under Warranty
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                authService.requestedNumber.totalUnderWarranty
                                    .toString(),
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              InkWell(
                                child: Text(
                                  ' Items under warranty',
                                  style: normalStyle,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ItemUnderWarranty(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          //Active Users
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                authService.requestedNumber.activeUsers
                                    .toString(),
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              InkWell(
                                child: Text(
                                  ' Active users',
                                  style: normalStyle,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ActiveUsersList(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 5),

                          // Searchbox and Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    width: 250,
                                    height: 60,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "Search by serial number",
                                        suffix: IconButton(
                                          color: Colors.black,
                                          icon: Icon(Icons.search),
                                          onPressed: () {
                                            print("Searching..");
                                            /* Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SearchBox(),
                                              ),
                                            ); */

                                            //
                                          },
                                        ),
                                      ),
                                      onChanged: (String value) {
                                        print("buy from ===> $value");
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  SizedBox(
                                    width: 250,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.pressed))
                                              return Colors.green[900];
                                            return Colors
                                                .green; // Use the component's default.
                                          },
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ItemRegister(),
                                          ),
                                        );
                                      },
                                      child: Text('Add Outgoing Item'),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),

                          /*  SizedBox(height: 5),
                          Row(
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed))
                                        return Colors.green[900];
                                      return Colors
                                          .green; // Use the component's default.
                                    },
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddEquipment(),
                                    ),
                                  );
                                },
                                child: Text('Add Equipment'),
                              ),
                            ],
                          ),
                          SizedBox(height: 10), */
                          Row(
                            children: [
                              Text('My Dashboard'),
                            ],
                          ),
                          Divider(
                            height: 2,
                            color: Colors.black,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, top: 20),
                            child: Column(
                              children: [
                                /* Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        child: Text(
                                          'Total Items under warranty ',
                                          style: normalStyle,
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ItemUnderWarranty(),
                                            ),
                                          );
                                        },
                                      ),
                                      Text(
                                        authService
                                            .requestedNumber.totalUnderWarranty
                                            .toString(),
                                        style: normalStyle,
                                      ),
                                    ],
                                  ), */
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'To be received by customer',
                                      style: normalStyle,
                                    ),
                                    Text(
                                      authService
                                          .requestedNumber.totalToBeReceived
                                          .toString(),
                                      style: normalStyle,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      child: Text(
                                        'Requested for warranty ',
                                        style: normalStyle,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ViewRequestedList(),
                                          ),
                                        );
                                      },
                                    ),
                                    Text(
                                      authService.requestedNumber.totalRequested
                                          .toString(),
                                      style: normalStyle,
                                    ),
                                    /* Container(
                                       height: 50,
                                      width: 50,
                                      color: Colors.grey, 
                                      child: Badge(
                                        child: Text(
                                          authService
                                              .requestedNumber.totalRequested
                                              .toString(),
                                          style: normalStyle,
                                        ),
                                      ),
                                    ), */
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        );
      },
    );
  }

  _logout() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want logout now ?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                 MaterialPageRoute(
                  builder: (context) => SecondLogin(),
                ),
              );
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    );
  }
}
