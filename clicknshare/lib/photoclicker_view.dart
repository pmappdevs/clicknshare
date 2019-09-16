import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:path_provider/path_provider.dart';

class ClickPhotonVideo extends StatefulWidget {
  @override
  _ClickPhotonVideoState createState() => _ClickPhotonVideoState();
}

class _ClickPhotonVideoState extends State<ClickPhotonVideo> {
  File _orgImage;
  bool _showProgress = false;
  
  @override
  void dispose() {
    super.dispose();
    _clear();
  }
  
  @override
  Widget build(BuildContext context) {
    return _mainView();
  }

  

  Widget _mainView() {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: _appBar(),
      body: _clickNShareView(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text("Click and Share"),
      backgroundColor: Colors.purple.shade500,
      centerTitle: false,
    );
  }

  Widget _clickNShareView() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          _photoDisplayView(),
          _shareButtonView(),
        ],
      ),
    );
  }

  Widget _photoDisplayView() {
    return AnimatedContainer(
      curve: Curves.elasticIn,
      duration: Duration(milliseconds: 500),
      height: MediaQuery.of(context).size.height * 0.75,
      width: MediaQuery.of(context).size.width,
      color: Colors.purple.shade100,
      child: _photoWidget(),
    );
  }

  Widget _photoWidget() {
    if (this._orgImage != null) {
      if (_showProgress == true) {
        return Container(
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
            ),
          ),
        );
      } else {
        return Image.file(
          this._orgImage,
          fit: BoxFit.cover,
        );
      }
    } else {
      if (_showProgress == false) {
        return IconButton(
          alignment: Alignment.center,
          tooltip: "Click a photo to share",
          icon: Icon(
            Icons.add_a_photo,
            size: (MediaQuery.of(context).size.height * 0.75) * 0.4,
            color: Colors.purple,
          ),
          onPressed: () => _getImage(),
        );
      } else {
        return Container(
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
            ),
          ),
        );
      }
    }
  }

  Widget _shareButtonView() {
    return Container(
      color: Colors.purple.shade50,
      height: MediaQuery.of(context).size.height * 0.14,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Card(
            elevation: 2.0,
            child: InkWell(
              onTap: () => _getImage(),
              child: AnimatedContainer(
                padding: EdgeInsets.all((MediaQuery.of(context).size.height * 0.15) * 0.15),
                duration: Duration(milliseconds: 500),
                color: Colors.purple.shade500,
                child: Text(
                  "Take Photo",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: (MediaQuery.of(context).size.height * 0.15) * 0.18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Card(
            elevation: 2.0,
            child: InkWell(
              onTap: () => _shareImage(),
              child: AnimatedContainer(
                padding: EdgeInsets.all((MediaQuery.of(context).size.height * 0.15) * 0.15),
                duration: Duration(milliseconds: 500),
                color: Colors.purple.shade500,
                child: Text(
                  "Share",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: (MediaQuery.of(context).size.height * 0.15) * 0.18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Card(
            elevation: 2.0,
            child: InkWell(
              onTap: () => _clearImage(),
              child: AnimatedContainer(
                padding: EdgeInsets.all((MediaQuery.of(context).size.height * 0.15) * 0.15),
                duration: Duration(milliseconds: 500),
                color: Colors.purple.shade500,
                child: Text(
                  "Clear",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: (MediaQuery.of(context).size.height * 0.15) * 0.18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _clearImage() async {
    setState(() {
      this._orgImage = null;
    });
    _clear();
  }

  static Future<void> _clear() async {
    final tempDir = await getTemporaryDirectory();
    tempDir.delete(recursive: true);
  }

  Future _getImage() async {
    setState(() {
      _showProgress = true;
    });

    var _image = await ImagePicker.pickImage(source: ImageSource.camera);
    _image = _image == null ? (await ImagePicker.retrieveLostData()).file : _image;
    if (_image != null) {
      setState(() {
        this._orgImage = _image;
        this._showProgress = false;
      });
    } else {
      setState(() {
        this._showProgress = false;
      });
    }
  }

  String _createFileName() {
    var _time = _getDate();
    var _appName = "clickNShare";
    return _appName + "-" + _time;
  }

  String _getDate() {
    return DateTime.now().day.toString() +
        "-" +
        DateTime.now().month.toString() +
        "-" +
        DateTime.now().year.toString() +
        "-" +
        DateTime.now().minute.toString() +
        DateTime.now().second.toString();
  }

  void _shareImage() async {
    try {
      String _extension = ".jpg";
      String _fileName = _createFileName() + _extension;

      await Share.files(
        'Click N Share image',
        {
          '$_fileName': this._orgImage.readAsBytesSync(),
        },
        '*/*',
        text: '',
      );
    } catch (e) {
      print('Share error: $e');
    }
  }
}
