import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  static const routeName = "terms_of_service_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Terms of Service")),
      body: SingleChildScrollView(child: termsOfService()),
    );
  }

  Widget termsOfService() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Center(
            child: Text('Terms of Service',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 20),
          Text(
            'Safety',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Biking can be a dangerous activity. Make sure to follow traffic laws in accordance with your state or local area and bike in designated areas. Other safety suggestions that may help make biking a more safe activity are as follows: ',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 10),
          Text(
            'Wear a helmet. Always.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 10),
          Text(
            'Look both ways before crossing any street or intersection.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 10),
          Text(
            'Let others know where you are biking and when you plan to leave and return',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 10),
          Text(
            'Do not wear earbuds while biking as they impair hearing.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 10),
          Text(
            'Remain vigilant for other traffic and pedestrians.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 10),
          Text(
            'In the case of an accident, call the local authorities.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 10),
          Text(
            'Theft',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Bike theft is a serious crime and depending on the state and local laws and the value of the bike may be a misdemeanor or even a felony. These crimes often result in fines, restitution, probation and even prison time. \nIf you or someone you know sees someone steal a bike, please report the theft to your local authorities. \nIf you arrive in the location of a bicycle on the Bike Kollective app and it is missing, please report the bike stolen/missing on the app so the team can follow up. \nEach user is allotted 8 hours to use a bike after checkout. The user will be shown a screen with a timer which chows their remaining usage time. If the bike is not returned in 24 hours, the user will be removed from the app.',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 10),
          Text(
            'Liability',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'The Bike Kollective will not be held liable for any injury, damage to property, or theft that results in using the app, riding a bike on the app, or adding a bike to the app. Please be aware that there are no guarantees that your bike will not be stolen when it is added to the app. The Bike Kollective will not be responsible if this happens, and we encourage users to reach out to their local authorities in the case of theft and or injury.',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 10),
          Text(
            'Changes to This Terms of Service',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'We may update our Terms of service from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Terms of Service on this page.These terms of Service are effective as of 2021-05-22',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 10),
          Text(
            'Contact Us',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at supermeanbikergang@gmail.com.',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }
}
