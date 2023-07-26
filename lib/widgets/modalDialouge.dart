import 'package:flutter/material.dart';

void ModalWidget(BuildContext context,
    {VoidCallback? tapOnCamera, VoidCallback? tapOnGallery}) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    elevation: 10,
    enableDrag: true,
    context: context,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: tapOnCamera,
              child: Container(
                child: const Icon(
                  Icons.camera,
                  size: 35,
                  color: Colors.black,
                ),
              ),
            ),
            GestureDetector(
              onTap: tapOnGallery,
              child: Container(
                child: const Icon(
                  Icons.photo,
                  size: 35,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}
