import 'package:calories/blocs/recipe/recipe_bloc.dart';
import 'package:calories/blocs/recipe/recipe_event.dart';
import 'package:calories/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditRecipeDirectionsScreen extends StatefulWidget {
  final Recipe recipe;

  EditRecipeDirectionsScreen({Key key, @required this.recipe})
      : assert(recipe != null),
        super(key: key);

  @override
  _EditRecipeDirectionsScreenState createState() =>
      _EditRecipeDirectionsScreenState(recipe);
}

class _EditRecipeDirectionsScreenState
    extends State<EditRecipeDirectionsScreen> {
  final Recipe recipe;
  List<String> _directions;
  List<TextEditingController> _controllers;
  RecipeBloc _recipeBloc;

  _EditRecipeDirectionsScreenState(this.recipe);

  @override
  void initState() {
    super.initState();
    _recipeBloc = BlocProvider.of<RecipeBloc>(context);
    _directions = List<String>();
    _controllers = List<TextEditingController>();
  }

  void _onSave() {
    for (final TextEditingController controller in _controllers) {
      _directions.add(controller.text);
    }
    _recipeBloc.add(AddNewRecipe(recipe.copyWith(directions: _directions)));
    Navigator.popUntil(context, ModalRoute.withName("/"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Recipe directions"),
        actions: <Widget>[
          FlatButton(
            onPressed: _onSave,
            child: Text("NEXT"),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Form(
                autovalidate: true,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (_, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.black12,
                        child: Text(
                          index.toString(),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      title: TextFormField(
                        controller: _controllers[index],
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: "Direction",
                        ),
                        maxLines: null,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              _controllers.removeAt(index);
                            });
                          }
                        },
                      ),
                    );
                  },
                  itemCount: _controllers.length,
                ),
              ),
              ListTile(
                onTap: _onAddActionTapped,
                leading: CircleAvatar(
                  backgroundColor: Colors.black12,
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ),
                title: Text('Add direction'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onAddActionTapped() {
    setState(() {
      _controllers.add(TextEditingController(text: ""));
    });
  }
}
