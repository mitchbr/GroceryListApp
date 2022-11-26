import 'package:flutter/material.dart';

import 'package:groceries/custom_theme.dart';
import 'package:groceries/processors/profile_processor.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final profileKey = GlobalKey<FormState>();
  final TextEditingController _profileController = TextEditingController();
  bool savedUsername = false;
  late String username;

  final theme = CustomTheme();
  final processor = ProfileProcessor();

  @override
  void initState() {
    username = 'no_username_set';
    processor.getUsername().then((value) {
      if (value != 'no_username_set') {
        savedUsername = true;
        _profileController.text = value;
        setState(() => username = value);
      } else {
        savedUsername = false;
        setState(() => username = 'no_username_set');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: profileField(),
    );
  }

  Widget profileField() {
    if (savedUsername == false) {
      return profileTextField();
    } else {
      return profileTile();
    }
  }

  Widget profileTile() {
    return ListTile(
        title: Text(username),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => setState(() {
            savedUsername = false;
          }),
        ));
  }

  profileTextField() {
    return Form(
        key: profileKey,
        child: ListTile(
          title: TextFormField(
            controller: _profileController,
            cursorColor: theme.accentHighlightColor,
            decoration: theme.textFormDecoration('Username'),
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onSaved: (value) {
              if (value != null) {
                processor.setUsername(value);
                username = value;
              }
            },
            validator: (value) {
              var val = value;
              if (val != null) {
                if (val.isEmpty) {
                  return 'Please enter username';
                } else {
                  return null;
                }
              }
              return null;
            },
          ),
          trailing: IconButton(onPressed: (() => saveUsername()), icon: const Icon(Icons.check)),
        ));
  }

  saveUsername() {
    var currState = profileKey.currentState;
    if (currState != null) {
      if (currState.validate()) {
        currState.save();
        setState(() {
          savedUsername = true;
        });
      }
    }
  }
}
