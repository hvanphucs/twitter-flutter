import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:twitter_flutter/helper/constants.dart';
import 'package:twitter_flutter/helper/utility.dart';
import 'package:twitter_flutter/models/user_model.dart';
import 'package:twitter_flutter/states/auth_state.dart';
import 'package:twitter_flutter/widgets/custom_widget.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _image;

  late final TextEditingController _name;
  late final TextEditingController _bio;
  late final TextEditingController _location;
  late final TextEditingController _dob;
  String? dob;

  @override
  void initState() {
    _name = TextEditingController();
    _bio = TextEditingController();
    _location = TextEditingController();
    _dob = TextEditingController();

    var authState = Provider.of<AuthState>(context, listen: false);

    _name.text = authState.userModel!.displayName!;
    _bio.text = authState.userModel!.bio!;
    _location.text = authState.userModel!.location!;
    _dob.text = Utility.getdob(authState.userModel!.dob!);

    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _bio.dispose();
    _location.dispose();
    _dob.dispose();

    super.dispose();
  }

  Widget _body() {
    var authState = Provider.of<AuthState>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 180,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: customNetworkImage(
                    'https://pbs.twimg.com/profile_banners/457684585/1510495215/1500x500',
                    fit: BoxFit.fill),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: _userImage(authState),
              ),
            ],
          ),
        ),
        _entryField('Name', controller: _name),
        _entryField('Bio', controller: _bio, maxLines: null),
        _entryField('Location', controller: _location),
        InkWell(
          onTap: _showCallender,
          child:
              _entryField('Date of birth', isenable: false, controller: _dob),
        ),
      ],
    );
  }

  Widget _userImage(authState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 5,
        ),
        shape: BoxShape.circle,
        image: DecorationImage(
            image: NetworkImage(dummyProfilePic), fit: BoxFit.cover),
      ),
      child: CircleAvatar(
        radius: 40,
        backgroundImage: _image != null
            ? FileImage(_image!)
            : NetworkImage(authState.userModel.photoUrl) as ImageProvider,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black38,
          ),
          child: Center(
              child: IconButton(
                  onPressed: _uploadImage,
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ))),
        ),
      ),
    );
  }

  void _uploadImage() {
    openImagePicker(context, (file) {
      setState(() {
        _image = File(file.path);
      });
    });
  }

  Widget _entryField(
    String title, {
    TextEditingController? controller,
    int? maxLines = 1,
    bool isenable = true,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            title,
            style: const TextStyle(color: Colors.black54),
          ),
          TextField(
            enabled: isenable,
            controller: controller,
            maxLines: maxLines,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 0,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showCallender() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2022, DateTime.now().month, DateTime.now().day),
        firstDate: DateTime(1950, DateTime.now().month, DateTime.now().day + 3),
        lastDate: DateTime.now().add(const Duration(days: 7)));
    setState(() {
      if (picked != null) {
        dob = picked.toString();
        _dob.text = Utility.getdob(dob);
      }
    });
  }

  void _submitButton() {
    var state = Provider.of<AuthState>(context, listen: false);
    UserModel? model = state.userModel!;

    if (_name.text.isNotEmpty) {
      model.displayName = _name.text;
    }
    if (_bio.text.isNotEmpty) {
      model.bio = _bio.text;
    }
    if (_location.text.isNotEmpty) {
      model.location = _location.text;
    }
    if (dob != null) {
      model.dob = dob;
    }

    state.updateUserProfile(model, image: _image);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
        title: const Text(
          'Profile Edit',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        actions: [
          InkWell(
            onTap: _submitButton,
            child: const Center(
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: _body(),
      ),
    );
  }
}
