# Steps to deploy iOS

 1. Create a new App Bundle ID (com.meta.Facebook) on the Apple Developer web platform, under [Certificates, Identifiers & Profiles](https://developer.apple.com/account/resources/identifiers/bundleId/add/bundle). On same form we'll select the **App/Bundle Id**, **Platform (iOS)**, **Description**, and, **App Capabilities**
     *  ### Capabilities
        -   Access WiFi Information
        -   Associated Domains
        -   AutoFill Credential Provider
        -   Communication Notifications
        -   Fonts
        -   HLS Interstitial Previews
        -   Low Latency HLS
        -   Maps
        -   MDM Managed Associated Domains
        -   Multipath
        -   Push Notifications
        -   Time Sensitive Notifications

2. Create a new App [link](https://appstoreconnect.apple.com/apps)
  - Company name = Facebook Inc
  - Name  = Facebook
  - Language = English (US)
  - Bundle Id = created @ step one (*com.meta.Facebook*)
  - SKU = ER45462US (randomly generated AlphaNumeric)
  - Apple ID = 430234520


3. Create a certificate
 - Generate a Certificate, you need a Certificate Signing Request (CSR) file [read more](https://help.apple.com/developer-account/#/dfa00fef7)
 - Certificate location [ios/CertificateSigningRequest.certSigningRequest](./CertificateSigningRequest.certSigningRequest)

<!-- 3.1 Create a APNs certificate [ios/PushCertificateSigningRequest.certSigningRequest](./PushCertificateSigningRequest.certSigningRequest)
 - And convert the certificate to p12 and upload to firebase -->
 
4. Create an archive and upload/distribute to the AppStore connect, [tutorial](https://www.youtube.com/watch?v=akFF1uJWZck) 
  * NOTE: When creating an archive on Xcode choose _Any iOS device(arm 64)_ as a target device instead of selecting a specific device.
5. Create APNs key and upload to firebase [link](https://developer.apple.com/account/resources/authkeys/lists) **To Enable FB to send Notifications**
   * ```ios/AuthKey_45785W75K.p8```
   * ```ios/AuthKey_NGT54654.p8```
