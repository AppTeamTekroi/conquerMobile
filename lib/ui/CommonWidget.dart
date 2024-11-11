import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonWidget {

 static InputDecoration dropdecoration(String hintText,EdgeInsets padding) {
  return InputDecoration(
      hintText: hintText,
      contentPadding: padding,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: BorderSide(color: Colors.grey),
      ),
      hintStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold),

  );

}
  static Widget getTextWidgetPopSemi(String title,
      {textAlign = TextAlign.center,
        double size = 16,
        Color color = Colors.black}) {
    return Text(
      title,
      style: TextStyle(color: color, fontSize: size),
      textAlign: textAlign,
    );
  }

  static Widget getTextWidgetPopBold(String title,
      {textAlign = TextAlign.center,
        double size = 16,
        Color color = Colors.black}) {
    return Text(
      title,
      style: TextStyle(
          fontWeight: FontWeight.bold, color: color, fontSize: size),
      textAlign: textAlign,
    );
  }

  static Widget getTextRich(String title, String value,
      {Color titlecolor = Colors.black, Color valuecolor = Colors
          .black, double top = 5.0, double bottom = 0.0}) {
    return Container(
      margin: EdgeInsets.only(top: top, bottom: bottom),
      child: Text.rich(TextSpan(
          text: title,
          style:
          TextStyle(
              fontWeight: FontWeight.bold, color: titlecolor, fontSize: 14),
          children: [
            TextSpan(
              text: value,
              style: TextStyle(fontWeight: FontWeight.normal,
                  color: valuecolor,
                  fontSize: 14),
            )
          ])),
    );
  }

  static Widget getTextFieldWithgrayboderandclickable(String hinttext,
      TextEditingController controller, VoidCallback funtion) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      height: 40,
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: funtion,
        keyboardType: TextInputType.text,
        style: TextStyle(
            fontSize: 13, color: Colors.black, fontWeight: FontWeight.normal),
        decoration: InputDecoration(
          /*suffixIcon: Container(
            padding: EdgeInsets.all(10),
            child: Image(
              image: AssetImage("assets/images/$image.png"),
              height: 12,
              width: 12,
            ),
          ),*/
          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          filled: true,
          fillColor: Color(0xffF4F4F4),
          hintText: hinttext,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(
                  color: Color(0xffF4F4F4),
                  width: 1,
                  style: BorderStyle.solid)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(
                  color: Color(0xffF4F4F4),
                  width: 1,
                  style: BorderStyle.solid)),
        ),
      ),
    );
  }

  static Widget getTextFieldWithgrayboder(String hinttext,
      TextEditingController textEditingController,
      {double height = 40,
        int maxline = 1,
        double bottonmargin = 10,
        TextInputType textInputType = TextInputType.text}) {
    return Container(
      margin: EdgeInsets.only(bottom: bottonmargin),
      height: height,
      child: TextField(
        controller: textEditingController,
        maxLines: maxline,
        keyboardType: textInputType,
        style:
        TextStyle(color: Colors.black, fontFamily: "Krub500", fontSize: 16),
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                borderSide: BorderSide(
                    color: Color(0xffF4F4F4),
                    width: 1,
                    style: BorderStyle.solid)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                borderSide: BorderSide(
                    color: Color(0xffF4F4F4),
                    width: 1,
                    style: BorderStyle.solid)),
            contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            filled: true,
            fillColor: Color(0xffF4F4F4),
            hintText: hinttext,
            hintStyle: TextStyle(
                color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                borderSide: BorderSide(color: Color(0xffF4F4F4)))),
        //controller: userid,
      ),
    );
  }

  static Widget getGradinetButton(String title, {Color color = Colors.blue}) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      margin: EdgeInsets.only(top: 10),
      width: double.infinity,
      height: 35,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        //color: Color(0xffFF701C),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  static void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
        backgroundColor: Colors.red[100],
        content: Container(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.w500, fontSize: 16),
            )));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static ButtonStyle commonbuttonStyle =
  ElevatedButton.styleFrom(
    backgroundColor: Colors.blue, // Background color
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius:
      BorderRadius.circular(8), // Button corner radius
    ),
  );
  static const TextStyle gogo = TextStyle(
     fontSize: 18,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.italic,
    color: Colors.white,
    );

  static Widget cardTextFormField1({required Widget child}) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      child: Container(
      decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.0),
    ),
    ),);
  }

  static const TextStyle commontextstyle = TextStyle(
    color: Colors.black87,
    fontSize: 13,
    fontFamily: 'RobotoMono',

  );
  static const TextStyle commonboldTextStyle = TextStyle(
    fontSize: 15,
    color: Colors.black,
    fontFamily: 'RobotoMono',
fontWeight: FontWeight.w500
  );
  static const TextStyle commontextstylwhite = TextStyle(
    color: Colors.black87,
    fontSize: 15,
    fontFamily: 'RobotoMono',

  );


  static InputDecoration commonTextfieldStyle(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(fontWeight: FontWeight.bold),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
            color: Colors.blue, width: 2.0), // Border color when focused
      ),
    );
  }

}