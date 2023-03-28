import 'package:flutter/material.dart';

const defaultInputDecoration = InputDecoration(

    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15))
    ),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(
            color: Colors.deepOrangeAccent
        )
    )
);

