import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:warranty_admin/components/toast.dart';
import 'package:warranty_admin/models/data_model/admin_model.dart';
import 'package:warranty_admin/provider/auth_service.dart';
import 'package:warranty_admin/provider/upload_service.dart';

class EditProfile extends StatefulWidget {
  final AdminDataModel updateAdminData;
  EditProfile({Key key, @required this.updateAdminData}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState(updateAdminData);
}

class _EditProfileState extends State<EditProfile> {
  final AdminDataModel updateAdminData;
  _EditProfileState(this.updateAdminData);

  final _adminNameController = TextEditingController();
  final _adminEmailController = TextEditingController();
  final _adminPhoneController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _adminNameController.dispose();
    _adminEmailController.dispose();
    _adminPhoneController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _adminNameController.text = updateAdminData.name;
    _adminEmailController.text = updateAdminData.email;
    _adminPhoneController.text = updateAdminData.phone;
  }

  File _selectedFile;
  // ignore: unused_field
  bool _inProcess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Update Profile'),
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                setState(() {
                  _updateAdminDataNow(context);
                });
              },
            ),
          ],
        ),
        //Text('Update Profile'),
        centerTitle: true,
        backgroundColor: Colors.green,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            }),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 10, right: 10),
        color: Colors.grey[200],
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 5),
              CircleAvatar(
                radius: 80,
                child: _selectedFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(75),
                        child: Image.file(
                          _selectedFile,
                          width: 150,
                          height: 150,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    : CircularProfileAvatar(
                        'https://warranty.rbfgroupbd.com/getstaffDP/${updateAdminData.staffID}',
                        errorWidget: (context, url, error) => Container(
                          child: Icon(Icons.error),
                        ),
                        placeHolder: (context, url) => Container(
                          width: 45,
                          height: 45,
                          child: CircularProgressIndicator(),
                        ),
                        radius: 90,
                        backgroundColor: Colors.transparent,
                        borderWidth: 2,
                        borderColor: Colors.blueAccent,
                        elevation: 1.0,
                        cacheImage: true,
                        showInitialTextAbovePicture: false,
                        onTap: () {
                          _showOptions(context);
                        },
                      ),
              ),
              SizedBox(
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.green[900];
                            return Colors.green; // Use the component's default.
                          },
                        ),
                      ),
                      child: Text("Update Profile Image"),
                      onPressed: () async {
                        setState(
                          () {
                            if (_selectedFile != null) {
                              /* UploadSurvice.asyncFileUpload(
                                updateAdminData.id,
                                _selectedFile,
                              ); */

                              _updateProfilePicture(context);
                            } else if (_selectedFile == null) {
                              Toast.toast(
                                context,
                                msg: "Select a photo first",
                                position: ToastPostion.center,
                                textSize: 16,
                              );
                            } else {
                              Toast.toast(
                                context,
                                msg: "Something went wrong with photo",
                                position: ToastPostion.center,
                                textSize: 16,
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _adminNameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  // prefixIcon: Icon(Icons.),
                ),
                onChanged: (value) {
                  print('name ===> $value');
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: _adminEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  // prefixIcon: Icon(Icons.),
                ),
                onChanged: (value) {
                  print('email ===> $value');
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: _adminPhoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone',
                  // prefixIcon: Icon(Icons.),
                ),
                onChanged: (value) {
                  print('phone ===> $value');
                },
              ),
              SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Colors.green[900];
                          return Colors.green; // Use the component's default.
                        },
                      ),
                    ),
                    child: Text('Update Password'),
                    onPressed: () {
                      print('===> update pass has been pressed');
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  getImage(ImageSource source) async {
    this.setState(() {
      _inProcess = true;
    });
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 700,
        maxHeight: 700,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.blueAccent,
          toolbarTitle: "RE-SIZER",
          statusBarColor: Colors.lightBlue,
          backgroundColor: Colors.white,
        ),
      );

      this.setState(() {
        _selectedFile = cropped;
        _inProcess = false;
      });
    } else {
      this.setState(() {
        _inProcess = false;
      });
    }
  }

  void _showOptions(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10),
              topRight: const Radius.circular(10),
            ),
          ),
          //color: Colors.grey,
          height: 180,
          child: Container(
            child: Column(
              children: [
                ListTile(
                  title: Text('Take Photo'),
                  onTap: () {
                    getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Pick from Gallery'),
                  onTap: () {
                    getImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Cancel'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _updateProfilePicture(context) async {
    await Provider.of<AuthService>(context, listen: false).updateAdminImage(
      updateAdminData.id,
      _selectedFile,
    );
  }

  Future<void> _updateAdminDataNow(context) async {
    var updatedName, updatedEmail, updatedPhone;

    updatedName = _adminNameController.text;
    updatedEmail = _adminEmailController.text;
    updatedPhone = _adminPhoneController.text;

    await Provider.of<AuthService>(context, listen: false).updateAdminData(
      adminName: updatedName,
      adminEmail: updatedEmail,
      adminPhone: updatedPhone,
      adminID: updateAdminData.staffID,
      context: context,
    );
  }
}