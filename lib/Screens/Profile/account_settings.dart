import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:location/location.dart';
import 'package:mango/Models/cloud/post_services.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Models/customModel/playlist.dart';
import 'package:mango/Models/customModel/post.dart';
import 'package:mango/Models/customModel/user.dart';
import 'package:mango/Screens/AccountSetup/interests.dart';
import 'package:mango/Screens/Episodes/episodes_widget.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../Models/customModel/mango_tags.dart';
import '../../constants.dart';
import '../../main.dart';
import '../PDFReader/API/pdf_api.dart';
import '../PDFReader/page/pdf_viewer_page.dart';
import 'professions.dart';
import '../Posts/Widgets/tags.dart';

class AccountSettings extends StatefulWidget {
  final userId;
  const AccountSettings({Key? key, required this.userId}) : super(key: key);

  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  final PostService _postService = PostService();
  final UserService _userService = UserService();
  int followers = 0;
  int following = 0;
  ScrollController _scrollController = ScrollController();
  var profileImage = '';
  final bool isEmpty = true;
  bool picked = false;
  bool pickedBanner = false;
  var _value;
  // Position? _currentPosition;
  String? _currentAddress;

  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController professionsController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String name = '';
  String displayName = '';
  String bio = '';
  String dob = '';
  File? _profileImage;
  File? _bannerImage;
  final picker = ImagePicker();

  late bool _isEditingDOB = false;
  late bool _isEditingProfession = false;
  late bool _isEditingPhone = false;
  late bool _isEditingAddress = false;
  bool _isNameEditing = false;
  String initialName = "Initial Text";
  bool _isDisplayNameEditing = false;
  String initialDisplayName = "Initial Text";
  bool _isBioEditing = false;
  String initialBio = "Initial Text";

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("USA"), value: "USA"),
      const DropdownMenuItem(child: Text("Canada"), value: "Canada"),
      const DropdownMenuItem(child: Text("Brazil"), value: "Brazil"),
      const DropdownMenuItem(child: Text("England"), value: "England"),
    ];
    return menuItems;
  }

  final List<MangoTags> _tags = [];
  final List<String> _tagsSelected = [];

  final TextEditingController _searchTextEditingController = TextEditingController();
  String get _searchText => _searchTextEditingController.text.trim();

  String selectedValue = "USA";
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? _userLocation;

  Future<void> _getUserLocation() async {
    Location location = Location();

    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final _locationData = await location.getLocation();
    setState(() {
      _userLocation = _locationData;
    });
  }

  Future<void> _displayTextInputDialog(context, valueText, hint) async {
    String? val;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // title: Text(title),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  val = value;
                });
              },
              // controller: controller,
              decoration: InputDecoration(hintText: hint),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey,
                        ),
                        child: const Center(
                            child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ))),
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                  ),
                  TextButton(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green,
                        ),
                        child: const Center(
                            child: Text(
                          'save',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ))),
                    onPressed: () async {
                      Navigator.pop(context);
                      if (val!.isNotEmpty) {
                        if (valueText == 'displayName') {
                          await _userService.updateDisplayName(val);
                        } else if (valueText == 'username') {
                          await _userService.updateUsername(val);
                        } else if (valueText == 'bio') {
                          await _userService.updateBio(val);
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          );
        });
  }

  final MangoUser _user = MangoUser(
      bannerImageUrl: '',
      bio: '',
      displayName: '',
      username: '',
      id: '',
      hobbies: [],
      phone: '',
      profession: '',
      city: '',
      country: '',
      state: '',
      dob: '',
      password: '',
      gender: '',
      profileImage: '',
      email: '',
      fcmToken: '',
      verified: false);

  refresh() {
    setState(() {
      Future<List<String>> usersFollowing =
          UserService().whoFollowsUser(FirebaseAuth.instance.currentUser!.uid);
      followers = usersFollowing.asStream().toString().length;
    });
  }

  TextEditingController dateInput = TextEditingController();

  @override
  void initState() {
    dateInput.text = "";
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    displayName = Provider.of<MangoUser>(context).displayName;
    name = Provider.of<MangoUser>(context).username;
    bio = Provider.of<MangoUser>(context).bio;

    // bio = Provider.of<MangoUser>(context).bio;
    // bio = Provider.of<MangoUser>(context).bio;
    double _height = MediaQuery.of(context).size.height;
    refresh();
    String formattedDate = '';
    String? selectedProfession = '';
    String selectedPhoneNumber = '';
    String selectedCountry = '';
    String selectedState = '';
    String selectedEmail = '';
    String selectedCity = '';
    List<String?> selectedHobbies = [];

    if (kDebugMode) {
      print(widget.userId);
    }

    return MultiProvider(
      providers: [
        StreamProvider<bool>(
            create: (context) => _userService.isFollowing(
                FirebaseAuth.instance.currentUser!.uid, widget.userId),
            initialData: false),
        StreamProvider<int>(
            create: (context) => _userService
                .noFollowers(FirebaseAuth.instance.currentUser!.uid),
            initialData: 0),
        StreamProvider<int>(
            create: (context) => _userService
                .noFollowing(FirebaseAuth.instance.currentUser!.uid),
            initialData: 0),
        StreamProvider<MangoUser?>(
            create: (context) => _userService.getUserInfo(widget.userId),
            initialData: _user),
        StreamProvider(
          initialData: const <MangoPost>[],
          create: (BuildContext context) {
            return _postService.getPostsByUser(widget.userId);
          },
        ),
      ],
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Scaffold(
            body: DefaultTabController(
              length: 4,
              child: NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder: (context, _) {
                    return [
                      SliverAppBar(
                        floating: false,
                        pinned: true,
                        backgroundColor: Colors.transparent,
                        leading: const CloseButton(
                          color: Colors.white,
                        ),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                if (dateInput.text.isNotEmpty) {
                                  await _userService.updateDOB(dateInput.text);
                                }
                                if (professionsController.text.isNotEmpty) {
                                  await _userService.updateProfession(
                                      professionsController.text);
                                }
                                if (_tags.isNotEmpty) {
                                  await _userService
                                      .updateHobbies(_tagsSelected);
                                }
                                if (country.text.isNotEmpty) {
                                  await _userService
                                      .updateCountry(country.text);
                                }
                                if (state.text.isNotEmpty) {
                                  await _userService.updateState(state.text);
                                }
                                if (phoneController.text.isNotEmpty) {
                                  await _userService.updatePhone(phoneController.text);
                                }
                                if (city.text.isNotEmpty) {
                                  await _userService.updateCity(city.text);
                                }
                                if(_profileImage != null) {
                                  await _userService.updateProfileImage(_profileImage);
                                }
                                if(_bannerImage != null) {
                                  await _userService.updateBannerImage(_bannerImage);
                                }
                                Navigator.pop(context);
                              },
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.green,
                                  ),
                                  child: const Center(
                                      child: Text(
                                    'Save profile',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ))))
                        ],
                        shadowColor: Colors.transparent,
                        expandedHeight: _height / 4.8,
                        stretch: true,
                        flexibleSpace: FlexibleSpaceBar(
                          background: pickedBanner
                              ? Image.file(
                                  _bannerImage!,
                                  // width: 120,
                                  // height: 50,
                                  fit: BoxFit.cover,
                                )
                              : CachedNetworkImage(
                                  imageUrl: Provider.of<MangoUser>(context)
                                      .bannerImageUrl,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: PopupMenuButton(
                                      child: Container(
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.4),
                                        ),
                                        child: const Icon(
                                            Icons.add_a_photo_outlined),
                                      ),
                                      onSelected: (newValue) {
                                        if (newValue == 0) {
                                          pickFromCamera(context, 1);
                                        }
                                        if (newValue == 1) {
                                          pickFromGallery(context, 1);
                                        } // add this property
                                        setState(() {
                                          _value =
                                              newValue; // it gives the value which is selected
                                        });
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          child: Text("From Camera"),
                                          value: 0,
                                        ),
                                        const PopupMenuItem(
                                          child: Text("From gallery"),
                                          value: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Column(
                              children: [
                                const SizedBox(
                                  height: 60,
                                ),
                                PopupMenuButton(
                                  child: const Text(
                                    "change image",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green),
                                  ),
                                  onSelected: (newValue) {
                                    if (newValue == 0) {
                                      pickFromCamera(context, 0);
                                    }
                                    if (newValue == 1) {
                                      pickFromGallery(context, 0);
                                    } // add this property
                                    setState(() {
                                      _value =
                                          newValue; // it gives the value which is selected
                                    });
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      child: Text("From Camera"),
                                      value: 0,
                                    ),
                                    const PopupMenuItem(
                                      child: Text("From gallery"),
                                      value: 1,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 40),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            Provider.of<MangoUser>(context)
                                                .displayName,
                                            style: textHeader2,
                                          ),
                                          Provider.of<MangoUser>(context)
                                                      .verified ==
                                                  true
                                              ? const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 2.0),
                                                  child: Icon(
                                                    Icons.verified,
                                                    size: 20,
                                                  ),
                                                )
                                              : const SizedBox(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2.0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _isDisplayNameEditing = true;
                                                  _displayTextInputDialog(
                                                      context,
                                                      'displayName',
                                                      'Display Name');
                                                });
                                              },
                                              child: const Icon(
                                                Icons.edit,
                                                size: 20,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            Provider.of<MangoUser>(context)
                                                .username,
                                            style: textBody3,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2.0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _isNameEditing = true;
                                                  _displayTextInputDialog(
                                                      context,
                                                      'username',
                                                      'Username');
                                                });
                                              },
                                              child: const Icon(
                                                Icons.edit,
                                                color: Colors.grey,
                                                size: 20,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            Provider.of<MangoUser>(context).bio,
                                            textWidthBasis:
                                                TextWidthBasis.longestLine,
                                            overflow: TextOverflow.fade,
                                            maxLines: 4,
                                            textAlign: TextAlign.center,
                                            style: playlistCardStat,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2.0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _isBioEditing = true;
                                                  _displayTextInputDialog(
                                                      context,
                                                      'bio',
                                                      'add a Bio');
                                                });
                                              },
                                              child: const Icon(
                                                Icons.edit,
                                                size: 20,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                  body: SizedBox(
                    height: 400,
                    child: SingleChildScrollView(
                      child: StreamBuilder<MangoUser?>(
                          initialData: _user,
                          stream: _userService.getUserInfo(
                              FirebaseAuth.instance.currentUser!.uid),
                          builder: (BuildContext context,
                              AsyncSnapshot<MangoUser?> user) {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Divider(
                                    thickness: 1.5,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 20.0, left: 20.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.person_outline_sharp,
                                          color: Colors.grey.shade500,
                                          size: 24,
                                        ),
                                        const SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          "Personal Details",
                                          style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        ),
                                        // SizedBox(
                                        //   width: 5.0,
                                        // ),
                                      ]),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20.0, bottom: 20.0),
                                    child: _isEditingDOB
                                        ? Container(
                                            height: 45,
                                            child: Center(
                                                child: TextField(
                                              style:
                                                  const TextStyle(fontSize: 14),
                                              controller:
                                                  dateInput, //editing controller of this TextField
                                              decoration: InputDecoration(
                                                icon: const Icon(Icons
                                                    .calendar_today), //icon of text field
                                                labelText: "Enter DOB",
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                filled: true,
                                                fillColor: Colors
                                                    .transparent, //label text of field
                                              ),
                                              readOnly:
                                                  true, //set it true, so that user will not able to edit text
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                    await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate: DateTime(
                                                            1900), //DateTime.now() - not to allow to choose before today.
                                                        lastDate:
                                                            DateTime(2101));

                                                if (pickedDate != null) {
                                                  print(pickedDate);
                                                  setState(() {
                                                    formattedDate =
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(pickedDate);
                                                  }); //pickedDate output format => 2021-03-10 00:00:00.000
                                                  print(
                                                      formattedDate); //formatted date output using intl package =>  2021-03-16
                                                  //you can implement different kind of Date Format here according to your requirement

                                                  setState(() {
                                                    dateInput.text =
                                                        formattedDate; //set output date to TextField value.
                                                  });
                                                } else {
                                                  print("Date is not selected");
                                                }
                                              },
                                            )))
                                        : SizedBox(
                                            height: 55,
                                            child: Center(
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                      Icons.calendar_month),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  Expanded(
                                                      child: Container(
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          user.data!.dob,
                                                          style: const TextStyle(
                                                              color: Colors.black,
                                                              // fontWeight: FontWeight.w600,
                                                              fontSize: 14),
                                                        ),
                                                        InkWell(
                                                          onTap: () =>
                                                              setState(() {
                                                            _isEditingDOB =
                                                                true;
                                                          }),
                                                          child: Container(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 5),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .black,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                              child:
                                                                  const Center(
                                                                child: Text(
                                                                  'Change',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ))
                                                ],
                                              ),
                                            ),
                                          )),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0, bottom: 20.0),
                                  child: _isEditingProfession
                                      ? SizedBox(
                                          height: 55,
                                          child: DropdownSearch<String>(
                                            searchBoxController:
                                                professionsController,
                                            //mode of dropdown
                                            mode: Mode.DIALOG,
                                            //to show search box
                                            showSearchBox: true,
                                            showSelectedItem: true,
                                            //list of dropdown items
                                            items: professions,
                                            label: "Profession",
                                            onChanged: (val) {
                                              setState(() {
                                                selectedProfession = val;
                                                professionsController.text =
                                                    val!;
                                              });
                                              print(val);
                                            },
                                            //show selected item
                                            selectedItem: "What do you do?",
                                            searchBoxDecoration:
                                                InputDecoration(
                                              //icon of text field
                                              labelText:
                                                  "Search job description",
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.black,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.black,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              filled: true,
                                              fillColor: Colors
                                                  .transparent, //label text of field
                                            ),
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                              icon: const Icon(Icons.work),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.black,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.black,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              filled: true,
                                              fillColor: Colors
                                                  .transparent, //label text of field
                                            ),
                                            searchBoxStyle: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                            dropdownSearchBaseStyle:
                                                const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 55,
                                          child: Center(
                                            child: Row(
                                              children: [
                                                const Icon(
                                                    Icons.work),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Expanded(
                                                    child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        user.data!.profession,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            // fontWeight: FontWeight.w600,
                                                            fontSize: 14),
                                                      ),
                                                      InkWell(
                                                        onTap: () =>
                                                            setState(() {
                                                          _isEditingProfession =
                                                              true;
                                                        }),
                                                        child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        5),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .black,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                            child: const Center(
                                                              child: Text(
                                                                'Change',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                              ],
                                            ),
                                          ),
                                        ),
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          // mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.smart_toy,
                                              color: Colors.grey.shade500,
                                              size: 24,
                                            ),
                                            const SizedBox(
                                              width: 15.0,
                                            ),
                                            Text(
                                              "What are your hobbies?",
                                              style: TextStyle(
                                                  color: Colors.grey.shade500,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ),
                                            // SizedBox(
                                            //   width: 5.0,
                                            // ),
                                          ]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: user.data!.hobbies.isNotEmpty ? Wrap(
                                        alignment: WrapAlignment.start,
                                        children: user.data!.hobbies.map((tagModel) => tagChipOwned(
                                          tagModel: tagModel,
                                          action: 'Explore',
                                        ))
                                            .toSet()
                                            .toList(),
                                      ) : Container(
                                        height: 55,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .center,
                                          children: [
                                            Text(
                                              "You have no hobbies here",
                                              style: TextStyle(
                                                  color: Colors.grey.shade500,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ),
                                            InkWell(
                                              onTap: () => setState(() {
                                                _isEditingPhone = true;
                                              }),
                                              child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                      color:
                                                      Colors.black,
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          20)),
                                                  child: const Center(
                                                    child: Text(
                                                      'Change',
                                                      style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .w600,
                                                        color: Colors
                                                            .white,
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 20.0, left: 20.0),
                                  child: _tagIcon(),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Divider(
                                    thickness: 1.5,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 20.0, left: 20.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.contact_mail,
                                          color: Colors.grey.shade500,
                                          size: 24,
                                        ),
                                        const SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          "Contact Details",
                                          style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        ),
                                        // SizedBox(
                                        //   width: 5.0,
                                        // ),
                                      ]),
                                ),
                                _isEditingPhone
                                    ? Container(
                                        padding: const EdgeInsets.only(
                                            bottom: 20.0,
                                            left: 20.0,
                                            right: 20.0),
                                        child: IntlPhoneField(
                                          decoration: InputDecoration(
                                            labelStyle:
                                                const TextStyle(fontSize: 14),
                                            // icon: const Icon(Icons.work),
                                            labelText: "Phone Number",
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.black,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.black,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            filled: true,
                                            fillColor: Colors.transparent,
                                          ),
                                          initialCountryCode:
                                              'NG', //default contry code, NP for Nepal
                                          onChanged: (phone) {
                                            setState((){
                                              phoneController.text = phone
                                                  .completeNumber;
                                            });
                                            //when phone number country code is changed
                                            print(phone
                                                .completeNumber); //get complete number
                                            print(phone
                                                .countryCode); // get country code only
                                            print(phone
                                                .number); // only phone number
                                          },
                                        ))
                                    : Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        height: 55,
                                        child: Center(
                                          child: Row(
                                            children: [
                                              const Icon(Icons.phone),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Expanded(
                                                  child: Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  border: Border.all(
                                                      color: Colors.black,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      user.data!.phone,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          // fontWeight: FontWeight.w600,
                                                          fontSize: 14),
                                                    ),
                                                    InkWell(
                                                      onTap: () => setState(() {
                                                        _isEditingPhone = true;
                                                      }),
                                                      child: Container(
                                                          padding: const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 10,
                                                              vertical: 5),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.black,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child: const Center(
                                                            child: Text(
                                                              'Change',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                            ],
                                          ),
                                        ),
                                      ),
                                const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Divider(
                                    thickness: 1.5,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 20.0, left: 20.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.grey.shade500,
                                          size: 24,
                                        ),
                                        const SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          "Address",
                                          style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        ),
                                        // SizedBox(
                                        //   width: 5.0,
                                        // ),
                                      ]),
                                ),
                                _isEditingAddress
                                    ? Container(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          bottom: 20,
                                        ),
                                        // height: 600,
                                        child: Column(
                                          children: [
                                            CountryStateCityPicker(
                                              country: country,
                                              state: state,
                                              city: city,
                                              textFieldInputBorder:
                                                  OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.black,
                                                    width: 4),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                        height: 55,
                                        child: Center(
                                          child: Row(
                                            children: [
                                              const Icon(Icons.flag),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Expanded(
                                                  child: Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  border: Border.all(
                                                      color: Colors.black,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      user.data!.country,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          // fontWeight: FontWeight.w600,
                                                          fontSize: 14),
                                                    ),
                                                    InkWell(
                                                      onTap: () => setState(() {
                                                        _isEditingAddress =
                                                            true;
                                                      }),
                                                      child: Container(
                                                          padding: const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 10,
                                                              vertical: 5),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.black,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child: const Center(
                                                            child: Text(
                                                              'Change',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                            ],
                                          ),
                                        ),
                                      ),
                                const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Divider(
                                    thickness: 1.5,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 30.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          MaterialButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Interests(
                                                              uid: FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid)));
                                            },
                                            color: const Color(0xff022C43),
                                            textColor: Colors.white,
                                            child: const Icon(
                                              Icons.attractions,
                                              size: 24,
                                            ),
                                            padding: const EdgeInsets.all(16),
                                            shape: const CircleBorder(),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text("Edit\nInterests",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              )),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        children: [
                                          MaterialButton(
                                            onPressed: () {
                                              Share.share(
                                                  'Download the Mango test app. \n \n Get the android app here \n http://tiny.cc/qhssuz',
                                                  subject: "Get Mango");
                                            },
                                            color: const Color(0xff022C43),
                                            textColor: Colors.white,
                                            child: const Icon(
                                              Icons.group,
                                              size: 24,
                                            ),
                                            padding: const EdgeInsets.all(16),
                                            shape: const CircleBorder(),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text("Tell a\nfriend",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              )),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        children: [
                                          MaterialButton(
                                            onPressed: () async {
                                              final file = await PDFApi.loadNetwork(
                                                  'https://firebasestorage.googleapis.com/v0/b/mango-cloud-34e08.appspot.com/o/mango_docs%2Fcreate%20your%20space.pdf?alt=media&token=eb23352f-930a-4e5c-a211-7add3e3c9d3d');
                                              openPDF(context, file, 'FAQ');
                                            },
                                            color: const Color(0xff022C43),
                                            textColor: Colors.white,
                                            child: const Icon(
                                              Icons.question_answer_outlined,
                                              size: 24,
                                            ),
                                            padding: const EdgeInsets.all(16),
                                            shape: const CircleBorder(),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text("FAQs",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                    onPressed: () async {
                                      await FirebaseAuth.instance.signOut();
                                      // await _googleSignIn.signOut();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Mango()));
                                    },
                                    child: const Text("Log out")),
                                const SizedBox(
                                  height: 40,
                                )
                              ],
                            );
                          }),
                    ),
                  )),
            ),
          ),
          StreamProvider.value(
              value: _postService.getPlaylistsByUser(widget.userId),
              initialData: const <MangoPlaylist>[],
              child: ProfilePicture(
                controller: _scrollController,
                uid: widget.userId, picked: picked, image: _profileImage,
              )),
        ],
      ),
    );
  }

  final List<MangoTags> _tagsToSelect = hobbies;
  final List<MangoTags> _limitedToSelect = hobbiesLimited;

  List<MangoTags> _filterSearchResultList() {
    if (_searchText.isEmpty) return _limitedToSelect;

    List<MangoTags> _tempList = [];
    for (int index = 0; index < _tagsToSelect.length; index++) {
      MangoTags tagModel = _tagsToSelect[index];
      if (tagModel.title
          .toLowerCase()
          .trim()
          .contains(_searchText.toLowerCase())) {
        _tempList.add(tagModel);
      }
    }

    return _tempList;
  }

  Widget _buildSearchFieldWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchTextEditingController,
              decoration: const InputDecoration.collapsed(
                hintText: 'Search hobbies',
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              style: const TextStyle(
                fontSize: 16.0,
              ),
              textInputAction: TextInputAction.search,
            ),
          ),
          _searchText.isNotEmpty
              ? InkWell(
                  child: Icon(
                    Icons.clear,
                    color: Colors.grey.shade700,
                  ),
                  onTap: () => _searchTextEditingController.clear(),
                )
              : Icon(
                  Icons.search,
                  color: Colors.grey.shade700,
                ),
          Container(),
        ],
      ),
    );
  }

  Widget _tagIcon() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _tagsWidget(),
      ],
    );
  }

  Widget _tagsWidget() {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 15,
          ),
          _tags.isNotEmpty
              ? Column(children: [
                  Wrap(
                    alignment: WrapAlignment.start,
                    children: _tags
                        .map((tagModel) => tagChip(
                              tagModel: tagModel,
                              onTap: () => _removeTag(tagModel),
                              action: 'Remove',
                            ))
                        .toSet()
                        .toList(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ])
              : Container(),
          _buildSearchFieldWidget(),
          _displayTagWidget(),
        ],
      ),
    );
  }

  _displayTagWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _filterSearchResultList().isNotEmpty
          ? _buildSuggestionWidget()
          : const Text('No Labels added'),
    );
  }

  Widget _buildSuggestionWidget() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (_filterSearchResultList().length != _tags.length)
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(20)),
              child: const Text(
                'Suggestions',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              )),
        ),
      Wrap(
        alignment: WrapAlignment.start,
        children: _filterSearchResultList()
            .where((tagModel) => !_tags.contains(tagModel))
            .map((tagModel) => tagChip(
                  tagModel: tagModel,
                  onTap: () => _addTags(tagModel),
                  action: 'Add',
                ))
            .toList(),
      ),
    ]);
  }

  _addTags(tagModel) async {
    if (!_tags.contains(tagModel)) {
      setState(() {
        _tags.add(tagModel);
        _tagsSelected.add(tagModel.title);
        print(_tags);
        print(_tagsSelected);
      });
    }
  }

  _removeTag(tagModel) async {
    if (_tags.contains(tagModel)) {
      setState(() {
        _tags.remove(tagModel);
        _tagsSelected.remove(tagModel.title);
      });
    }
  }

  Widget tagChipOwned({
    tagModel,
    action,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 5.0,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0,
        ),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Text(
          tagModel,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }

  Widget tagChip({
    tagModel,
    onTap,
    action,
  }) {
    return InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 5.0,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: Text(
                  '${tagModel.title}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            const Positioned(
              right: 0,
              child: CircleAvatar(
                backgroundColor: Colors.black26,
                radius: 8.0,
                child: Icon(
                  Icons.clear,
                  size: 10.0,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ));
  }

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
// Allows you to get a list of all the ItemTags
  _getAllItem() {
    List<Item>? lst = _tagStateKey.currentState?.getAllItem;
    if (lst != null) {
      lst.where((a) => a.active == true).forEach((a) => print(a.title));
    }
  }

  Future pickFromGallery(BuildContext context, int type) async {
    final getMedia = ImagePicker().pickImage;
    final media = await getMedia(source: ImageSource.gallery);
    final file = File(media!.path);
    setState(() {
      if (type == 0) {
        _profileImage = file;
        picked = true;
      }
      if (type == 1) {
        _bannerImage = file;
        pickedBanner = true;
      }
    });
  }

  Future pickFromCamera(BuildContext context, int type) async {
    final getMedia = ImagePicker().pickImage;
    final media = await getMedia(source: ImageSource.camera);
    final file = File(media!.path);
    setState(() {
      if (type == 0) {
        _profileImage = file;
        picked = true;
      }
      if (type == 1) {
        _bannerImage = file;
        pickedBanner = true;
      }
    });
  }

  void openPDF(BuildContext context, File file, String title) =>
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => PDFViewerPage(
                  file: file,
                  title: title,
                )),
      );
}

class ProfilePicture extends StatefulWidget {
  final controller;
  final uid;
  final picked;
  File? image;
  ProfilePicture({Key? key, required this.controller, required this.picked, this.image, required this.uid})
      : super(key: key);

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double defaultTopMargin = (_height / 4) - 60.0;
    //pixels from top where scaling should start
    const double scaleStart = 96.0;
    //pixels from top where scaling should end
    const double scaleEnd = scaleStart / 2;

    final image = Provider.of<MangoUser>(context).profileImage;

    double top = defaultTopMargin;
    double scale = 1.0;
    if (widget.controller.hasClients) {
      double offset = widget.controller.offset;
      top -= offset;
      if (offset < defaultTopMargin - scaleStart) {
        //offset small => don't scale down
        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        //offset between scaleStart and scaleEnd => scale down
        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        //offset passed scaleEnd => hide fab
        scale = 0.0;
      }
    }
    return Positioned(
      top: top,
      child: Transform(
        transform: Matrix4.identity()..scale(scale),
        alignment: Alignment.center,
        child: !widget.picked ? CachedNetworkImage(
          height: 100,
          width: 100,
          imageUrl: image,
          imageBuilder: (context, imageProvider) => Stack(
            children: [
              CircleAvatar(
                backgroundImage: imageProvider,
                radius: 50,
              ),
            ],
          ),
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 50.0,
              child: Icon(Icons.image)),
          placeholderFadeInDuration: const Duration(seconds: 3),
        ) : CircleAvatar(
          backgroundImage: FileImage(widget.image!),
          radius: 50,
        ),
      ),
    );
  }
}
