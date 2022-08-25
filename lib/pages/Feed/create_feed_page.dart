import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_flutter/helper/constants.dart';
import 'package:twitter_flutter/states/auth_state.dart';
import 'package:twitter_flutter/widgets/custom_appbar.dart';
import 'package:twitter_flutter/widgets/custom_widget.dart';

class CreateFeedPage extends StatefulWidget {
  const CreateFeedPage({Key? key}) : super(key: key);

  @override
  State<CreateFeedPage> createState() => _CreateFeedPageState();
}

class _CreateFeedPageState extends State<CreateFeedPage> {
  late final TextEditingController _textEditingController;
  File? _image;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  Widget _descriptionEntry() {
    return TextField(
      controller: _textEditingController,
      onChanged: (value) {},
      maxLines: null,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: "What happening?",
        hintStyle: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _imageFeed() {
    return _image == null
        ? Container()
        : Stack(
            children: [
              Container(
                alignment: Alignment.topRight,
                child: Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.all(0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black26,
                  ),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          _image = null;
                        });
                      },
                      padding: const EdgeInsets.all(0),
                      iconSize: 20,
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.onPrimary,
                      )),
                ),
              ),
            ],
          );
  }

  void _selectImageBottom(context) {
    openImagePicker(context, (file) {
      setState(() {
        _image = File(file.path);
      });
    });
  }

  void _onSubmitButton() async {
    if (_textEditingController.text.isEmpty) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar(
        title: const Text(''),
        submitButtonText: 'Tweet',
        onActionPressed: _onSubmitButton,
        isCrossButton: true,
        isSubmitDisable: _textEditingController.text.isEmpty,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _selectImageBottom(context);
        },
        child: const Icon(Icons.image),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customImage(
                    context,
                    authState.userModel!.photoUrl ?? dummyProfilePic,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: _descriptionEntry(),
                  ),
                ],
              ),
              _imageFeed()
            ],
          ),
        ),
      ),
    );
  }
}
