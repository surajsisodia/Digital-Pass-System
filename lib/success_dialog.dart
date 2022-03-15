import 'package:ccet_qr_scan/person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({Key? key, required this.person}) : super(key: key);

  final Person person;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                person.isClaimed! ? "Member Already Claimed" : "Member Found",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 18,
              ),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: person.isClaimed! ? Colors.yellow : Colors.green,
                    shape: BoxShape.circle),
                child: person.isClaimed!
                    ? Text(
                        " ! ",
                        style: TextStyle(fontSize: 22),
                      )
                    : Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "${person.name}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Text(
                "${person.branch} (${person.year})",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 14,
              ),
              MaterialButton(
                onPressed: () async {
                  if (!person.isClaimed!)
                    await FirebaseFirestore.instance
                        .collection('passData')
                        .doc(person.id)
                        .update({
                      'isClaimed': true,
                      'claimTimeStamp': FieldValue.serverTimestamp()
                    });
                  Navigator.of(context).pop();
                },
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                child: Text(
                  person.isClaimed! ? "Rescan" : "Verify",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            ],
          )),
    );
  }
}
