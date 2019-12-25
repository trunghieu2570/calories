import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:calories/blocs/auth/auth_bloc.dart';
import 'package:calories/blocs/auth/auth_state.dart';
import 'package:calories/models/models.dart';
import 'package:calories/ui/screens/food/nutrition_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CreateFoodScreen extends StatefulWidget {
  static final String routeName = '/createFood';
  final Food food;

  CreateFoodScreen({Key key, this.food}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateFoodScreenState(food);
}

class _CreateFoodScreenState extends State<CreateFoodScreen> {
  static final String routeName = '/createFood';
  final Food oldFood;
  String _name;
  String _brand;
  File _photo;
  String _photoUrl;
  String _unit;
  String _quantity;
  String _uid;
  bool _share = true;
  final _formKey = GlobalKey<FormState>();
  AuthBloc _authBloc;

  _CreateFoodScreenState(this.oldFood);

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    if (oldFood != null) {
      _photoUrl = oldFood.photoUrl;
      _name = oldFood.name;
      _uid = oldFood.creatorId;
      _brand = oldFood.brand;
      _share = oldFood.share ?? true;
      _quantity = oldFood.servings.quantity;
      _unit = oldFood.servings.unit;
    }
  }

  void _onSave() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final authState = _authBloc.state;
      if (authState is Authenticated) {
        if (oldFood != null) {
          // Edit food
          Food food = oldFood.copyWith(
              name: _name,
              share: _share,
              brand: _brand,
              servings: Serving(_unit, _quantity));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return NutritionInfoScreen(
                food: food,
                photo: _photo,
              );
            }),
          ).then((editedFood) => Navigator.pop(context, editedFood));
        } else {
          // Create food
          _uid = authState.user.uid;
          Food food = Food(_name,
              brand: _brand,
              servings: Serving(_unit, _quantity),
              creatorId: _uid,
              share: _share,
              tags: []);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return NutritionInfoScreen(
                food: food,
                photo: _photo,
              );
            }),
          );
        }
      }
    }
  }

  Future _pickImage() async {
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _photo = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  BoxDecoration _buildBackground() {
    if (_photo != null) {
      return BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: FileImage(_photo),
        ),
      );
    } else if (_photoUrl != null) {
      return BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover, image: CachedNetworkImageProvider(_photoUrl)),
      );
    }
    return null;
  }

  Widget _buildBody() => Scaffold(
        backgroundColor: Colors.grey[200],
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(oldFood != null ? "Edit food" : "Create new food"),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: _onSave,
              child: Text("Next".toUpperCase()),
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    height: 300,
                    child: Scaffold(
                      backgroundColor: Colors.grey,
                      floatingActionButton: FloatingActionButton(
                        onPressed: _pickImage,
                        child: Icon(Icons.camera_alt),
                      ),
                      body: Container(
                        decoration: _buildBackground(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      initialValue: _name,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.all(15),
                        labelText: "Name",
                      ),
                      onSaved: (value) => _name = value,
                      validator: (value) {
                        if (value.isEmpty) return "Not be empty";
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      initialValue: _brand,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.all(15),
                        labelText: "Brand",
                      ),
                      onSaved: (value) => _brand = value,
                      validator: (value) {
                        if (value.isEmpty) return "Not be empty";
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      initialValue: _quantity,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.all(15),
                        labelText: "Quantity",
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _quantity = value,
                      validator: (value) {
                        if (value.isEmpty) return "Not be empty";
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      initialValue: _unit,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.all(15),
                        labelText: "Unit",
                      ),
                      onSaved: (value) => _unit = value,
                      validator: (value) {
                        if (value.isEmpty) return "Not be empty";
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Share to community'),
                    trailing: Switch(
                      onChanged: (v) {
                        setState(() {
                          _share = v;
                        });
                      },
                      value: _share,
                    ),
                  )
                ]),
              )
            ],
          ),
        ),
      );
}
