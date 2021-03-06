import 'dart:io';

import 'package:calories/blocs/recipe/recipe_bloc.dart';
import 'package:calories/blocs/recipe/recipe_event.dart';
import 'package:calories/models/models.dart';
import 'package:calories/ui/screens/recipe/recipe_search_screen.dart';
import 'package:calories/ui/widgets/loading_stack_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditRecipeDirectionsScreen extends StatefulWidget {
  final Recipe recipe;
  final File photo;

  EditRecipeDirectionsScreen({Key key, @required this.recipe, this.photo})
      : assert(recipe != null),
        super(key: key);

  @override
  _EditRecipeDirectionsScreenState createState() =>
      _EditRecipeDirectionsScreenState(recipe, photo);
}

class _EditRecipeDirectionsScreenState
    extends State<EditRecipeDirectionsScreen> {
  final Recipe recipe;
  final File photo;
  List<String> _directions;
  List<TextEditingController> _controllers;
  RecipeBloc _recipeBloc;
  bool _isLoading = false;

  _EditRecipeDirectionsScreenState(this.recipe, this.photo);

  @override
  void initState() {
    super.initState();
    _recipeBloc = BlocProvider.of<RecipeBloc>(context);
    _directions = List<String>();
    _controllers = List<TextEditingController>();
    _controllers.add(TextEditingController());
    if (recipe.directions != null) {
      _controllers.clear();
      for (var dr in recipe.directions) {
        final textController = new TextEditingController();
        textController.text = dr;
        _controllers.add(textController);
      }
    }
  }

  void _setLoadingState(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  Future<String> _uploadImage(File image) async {
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child(image.hashCode.toString())
        .child("image.jpg");
    StorageUploadTask uploadTask = ref.putFile(image);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  void _onSave() async {
    _setLoadingState(true);
    for (final TextEditingController controller in _controllers) {
      _directions.add(controller.text);
    }
    String photoUrl;
    if (photo != null) photoUrl = await _uploadImage(photo);
    Recipe newRecipe =
        recipe.copyWith(directions: _directions, photoUrl: photoUrl);
    if (newRecipe.id != null) {
      _recipeBloc.add(UpdateRecipe(newRecipe));
      Navigator.pop(
            context, newRecipe);
    } else {
      _recipeBloc.add(AddNewRecipe(newRecipe));
      Navigator.popUntil(context, ModalRoute.withName("/"));
    }
    _setLoadingState(false);
  }

  @override
  Widget build(BuildContext context) {
    return LoadingStack(
      body: _buildBody(),
      state: _isLoading,
    );
  }

  Widget _buildBody() {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Recipe Directions"),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: _onSave,
            child: Text('Save'.toUpperCase()),
          )
        ],
      ),
      body: Form(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, int index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: ListTile(
                          leading: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircleAvatar(
                              backgroundColor: Colors.black12,
                              child: Text(
                                index.toString(),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          title: TextFormField(
                            controller: _controllers[index],
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration.collapsed(
                              hintText: "Enter direction...",
                            ),
                            maxLines: null,
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  _controllers.removeAt(index);
                                });
                              }
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Not be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Divider(height: 1)
                    ],
                  );
                },
                childCount: _controllers.length,
              ),
            ),
            SliverToBoxAdapter(
              child: ListTile(
                onTap: _onAddActionTapped,
                leading: Icon(
                  Icons.add_circle,
                  color: Colors.grey[700],
                  size: 30,
                ),
                title: Text(
                  'Add more direction',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ));
  }

  void _onAddActionTapped() {
    setState(() {
      _controllers.add(TextEditingController(text: ""));
    });
  }
}
