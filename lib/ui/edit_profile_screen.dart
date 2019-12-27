import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:calories/blocs/auth/bloc.dart';
import 'package:calories/models/models.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'widgets/dropdown_formfield.dart';
import 'widgets/loading_stack_widget.dart';

class EditProfileScreen extends StatefulWidget {
  static final String routeName = '/editProfile';

  @override
  State<StatefulWidget> createState() {
    return _EditProfileScreenState();
  }
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static final String routeName = '/createMeal';
  final _formKey = GlobalKey<FormState>();
  String _name;
  File _photo;
  String _photoUrl;
  int _height;
  int _weight;
  String _uid;
  AuthBloc _authBloc;
  DateTime _birthday;
  int _gender;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    final authState = _authBloc.state;
    if (authState is Authenticated) {
      final user = authState.user;
      _uid = user.uid;
      _name = user.fullName;
      _photoUrl = user.photoUrl;
      _height = user.height ?? 0;
      _weight = user.weight ?? 0;
      _birthday = user.birthday;
      _gender = user.gender ?? 0;
    }
  }

  void _setLoadingState(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  void _onSave() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _setLoadingState(true);
      final authState = _authBloc.state;
      if (authState is Authenticated) {
        final oldUser = authState.user;
        String photoUrl;
        if (_photo != null) photoUrl = await _uploadImage(_photo);
        User newUser = oldUser.copyWith(
            fullName: _name,
            birthday: _birthday,
            gender: _gender,
            weight: _weight,
            photoUrl: photoUrl,
            height: _height);
        _authBloc.add(UpdateUserInfo(newUser));
        Navigator.pop(context, newUser);
      }
      _setLoadingState(false);
    }
  }

  Future _pickImage() async {
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _photo = img;
    });
  }

  ///Upload image
  Future<String> _uploadImage(File image) async {
    StorageReference ref =
        FirebaseStorage.instance.ref().child('ava_$_uid.jpg');
    StorageUploadTask uploadTask = ref.putFile(image);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingStack(
      body: _buildBody(),
      state: _isLoading,
    );
  }

  Widget _buildBody() => Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Edit your profile'),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () => _onSave(),
              child: Text('Save'.toUpperCase()),
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      height: 300,
                      child: Scaffold(
                        backgroundColor: Colors.grey,
                        floatingActionButton: FloatingActionButton(
                          onPressed: _pickImage,
                          child: Icon(Icons.camera_alt),
                        ),
                        body: Container(
                          decoration: _photo != null
                              ? BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(_photo),
                                  ),
                                )
                              : (_photoUrl != null
                                  ? BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: CachedNetworkImageProvider(
                                              _photoUrl)),
                                    )
                                  : null),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        initialValue: _name,
                        decoration: InputDecoration(
                          icon: Icon(Icons.person),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.all(15),
                          labelText: "Your name",
                        ),
                        onSaved: (value) => _name = value,
                        validator: (value) {
                          if (value.isEmpty) return "Not be empty";
                          return null;
                        },
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: DateTimeField(
                              readOnly: true,
                              resetIcon: null,
                              format: DateFormat('dd/MM/yyyy'),
                              initialValue: _birthday,
                              decoration: InputDecoration(
                                icon: Icon(Icons.date_range),
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding: EdgeInsets.all(15),
                                labelText: "Birthday",
                              ),
                              onSaved: (date) {
                                _birthday = date;
                              },
                              onShowPicker: (_, currentDate) async {
                                return await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentDate ?? DateTime.now(),
                                    lastDate: DateTime.now());
                              },
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: DropDownFormField(
                                required: true,
                                titleText: 'Gender',
                                hintText: 'Please choose one',
                                textField: 'display',
                                valueField: 'value',
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value;
                                  });
                                },
                                dataSource: [
                                  {
                                    "display": "Male",
                                    "value": 0,
                                  },
                                  {
                                    "display": "Female",
                                    "value": 1,
                                  },
                                ],
                                value: _gender,
                                onSaved: (value) {
                                  setState(() {
                                    _gender = value;
                                  });
                                },
                              )),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                            child: Icon(Icons.directions_run,
                                color: Colors.grey[600]),
                            margin: EdgeInsets.all(8)),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              initialValue: _height.toString(),
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding: EdgeInsets.all(15),
                                labelText: "Height",
                              ),
                              onSaved: (value) => _height = int.parse(value),
                              validator: (value) {
                                if (value.isEmpty) return "Not be empty";
                                return null;
                              },
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              initialValue: _weight.toString(),
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding: EdgeInsets.all(15),
                                labelText: "Weight",
                              ),
                              onSaved: (value) => _weight = int.parse(value),
                              validator: (value) {
                                if (value.isEmpty) return "Not be empty";
                                return null;
                              },
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
