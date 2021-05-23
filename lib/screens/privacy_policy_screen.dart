import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  static const routeName = "privacy_policy_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Privacy Policy")),
      body: SingleChildScrollView(child: privacyPolicy()),
    );
  }

  Widget privacyPolicy() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
      children: [
        Text('Privacy Policy', 
          textAlign: TextAlign.center, 
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)
        ), 
        SizedBox(height: 20),
        Text('The Super Mean Biker Gang built the Bike Kollective app as a Free app. This SERVICE is provided by The Super Mean Biker Gang at no cost and is intended for use as is.This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service. If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy. The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at Bike Kollective unless otherwise defined in this Privacy Policy.',
        style: TextStyle(fontSize: 15),
        ),
        SizedBox(height: 10),
        Text('Information Collection and Use', 
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text('For a better experience, while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to email. The information that we request will be retained by us and used as described in this privacy policy.',
        style: TextStyle(fontSize: 15),
        ),
        SizedBox(height: 10),
        Text('Cookies',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),        
        ),
        SizedBox(height: 10),
        Text("Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory. This Service does not use these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.",
        style: TextStyle(fontSize: 15),
        ),
        SizedBox(height: 10),
        Text('Service Providers', 
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text('We may employ third-party companies and individuals due to the following reasons: ', style: TextStyle(fontSize: 15),),
        SizedBox(height: 10),
        Text('To facilitate our Service;',
        style: TextStyle(fontSize: 15)),
        SizedBox(height: 10),
        Text('To provide the Service on our behalf;', 
        style: TextStyle(fontSize: 15)),
        SizedBox(height: 10),
        Text('To perform Service-related services; or',
        style: TextStyle(fontSize: 15)),
        SizedBox(height: 10),
        Text('To assist us in analyzing how our Service is used.',
        style: TextStyle(fontSize: 15)),
        SizedBox(height: 10),
        Text('We want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.',
        style: TextStyle(fontSize: 15)),
        SizedBox(height: 10),
        Text('Security',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text('We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.',
        style: TextStyle(fontSize: 15),
        ),
        SizedBox(height: 10),
        Text('Children’s Privacy',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text('These Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13 years of age. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do necessary actions.',
        style: TextStyle(fontSize: 15),
        ),
        SizedBox(height: 10),
        Text('Changes to This Privacy Policy', 
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text('We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page. This policy is effective as of 2021-05-22',
        style: TextStyle(fontSize: 15),
        ),
        SizedBox(height: 10),
        Text('Contact Us',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text('If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at supermeanbikergang@gmail.com.',
        style: TextStyle(fontSize: 15),
        ),
        SizedBox(height:20)
      ],
    ));
  }
}
