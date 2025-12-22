import 'package:flutter/cupertino.dart';

late OverlayEntry overlayEntry;

const strAppName = 'Flutter Structure';
const strFontName = 'Roboto';
const mapKey = 'AIzaSyCTwDuyVFYSCOlJ_wltNft39LAbpJY4XRk';

const strLocationPermission =
    "Location permission is required to use this app. Please grant permission to continue. You can enable location permission in the app settings.";

///otp verification manage types

const strRegisterType = 'register';
const strForgotType = 'forgot';
const strEmailChange = 'emailChange';
const strMobileChangeType = 'mobileChange';
const strBeneficiaryLoginType = 'beneficiaryLogin';
const strBuyer = 'buyer';
// Preference //
const strWhatsApp = 'WhatsApp';
const strSMS = 'SMS';
const strDirectCall = 'Direct Call';

// ===================================================== //

/// No internet ///
const ooops = "Ooops!";
const noInternetMsg = "No internet connection,\ncheck your internet settings.";
const tryAgain = "Try Again";

/// Login ///
const welcome = "Welcome";
const loginToContinue = "Login to continue using our platform";
// const email = "Email";
const password = "Password";
const forgotPassword = "Forgot Password";
const login = "Login";
const or = "Or";
const google = "Google";
const apple = "Apple";
const doNotHaveAccount = "Don’t have an account";
const signUp = "Sign Up";
const pleaseEnterEmail = "Please enter email";
const pleaseEnterValidEmail = "Please enter valid email";
const pleaseEnterPassword = "Please enter password";

/// Register ///
const pleaseEnterFirstName = "Please enter first name";
const pleaseEnterLastName = "Please enter last name";
const pleaseEnterConfirmPassword = "Please enter confirm password";
const pleaseEnterMobileNumber = "Please enter mobile number";
const pleasePasswordAndConfirmNotSame = "Password & Confirm password are not same";

/// Otp verification ///
const pleaseEnterOTP = "Please enter OTP";
const pleaseEnterValidOTP = "Please enter Valid OTP";

/// Setup profile ///
const pleaseSelectProfileImage = "Please select profile image";
const pleaseSelectBirthDate = "Please select birth date";
const pleaseSelectCurrency = "Please select Currency";
const pleaseSelectTime = "Please select time";
const pleaseSelectCountry = "Please select Country";
const pleaseSelectState = "Please select state";
const pleaseSelectCity = "Please select city";
const pleaseSelectAddress = "Please select address";

///profile flow
const strAccount = 'Account';
const strPlatinumMonthly = 'Platinum - Monthly';
const strSilverMember = 'Silver Member';
const strEditProfile = 'Edit profile';
const strUpgrade = 'Upgrade';
const strNotification = 'Notification';
const strBeneficiaries = 'Beneficiaries';
const strSettings = 'Settings';
const strContactUs = 'Contact us';
const strContactUsCaps = 'Contact Us';
const strLogout = 'Logout';
const strGoldMember = 'Gold Member';
const strBundles = 'Bundles';
const strPlatinumMember = 'Platinum Member';
const strSubscription = 'Subscription';
const strGold = 'Gold';
const strSubscriptionText1 = 'Kementum ultricies tortor';
const strSubscriptionText2 = 'Phasellus justo kopwnb';
const strSubscriptionText3 = 'Nato penatibus magnis';
const strPlatinum = 'Platinum';
const strSilver = 'Silver';
const strContinue = 'Continue';
const strChangePassword = 'Change password';
const strChangeLanguage = 'Change language';
const strChangeMobileNumber = 'Change mobile number';
const stChangeEmailID = 'Change email ID';
const stPrivacyPolicy = 'Privacy policy';
const strTermsConditions = 'Terms & conditions';
const strDeleteAccount = 'Delete account';
const strAddBeneficiaryLongText = 'You must have at least one beneficiary to proceed.';

///edit Profile
const strEditProfileCap = 'Edit Profile';
const strSelectCountry = 'Select country';
const strSelectCurrency = 'Select Currency';
const strSaveUpdate = 'Save & Update';

///Beneficiaries
const strBeneficiariesLongText = 'Are you sure you want to delete this beneficiary?';
const strLogOutLongText = 'Are you sure you want to logout from this account?';
const strYes = 'Yes';
const strNo = 'No';
const strEditBeneficiary = 'Edit Beneficiary';
const strBeneficiaryOtpVerificationLongText = 'Enter the 6-digit code we sent to your mobile number';

///Bundle screen
const strBundlesLongText =
    'You’re just a few coins away from completing your booking. Purchase a coins bundle now and continue enjoying our premium services!';
const strDone = 'Done';
const strBundlePurchaseSuccessFully = 'Bundle purchased successfully';

///ContactUs
const strContactUsLongText = 'Hey we’re here to help !';
const strContactUsLongText2 = 'Got a question about our service ? Just ask!';
const strCallUs = 'Call us';
const emailUs = 'Email us';

///settings
const strOldPassword = 'Old password';
const strNewPassword = 'New password';
const strNewConfirmPassword = 'New confirm password';
const strUpdate = 'Update';
const strChangeEmailID = 'Change Email ID';
const strChangeEmailLongText = 'Please enter your any new email address which you want to change';
const strChangeMobileNumberCaps = 'Change Mobile Number';
const strChangeMobileLongText = 'Please enter your any new mobile number which you want to change';
const strPrivacyPolicyCaps = 'Privacy Policy';
const strTermsConditionsCaps = 'Terms & Conditions';
const strDeleteLongText = 'Are you sure you want to delete this account?';

///Services flow
const strServices = 'Services';
const strHomeCare = 'Home care';
const strHomeCareAssistance = 'Healthcare assistance';
const strPersonalCare = 'Personal care';
const strHealthcareAssistance = 'Healthcare assistance';
const strEventPlanning = 'Event planning';
const strGovernmentLiaison = 'Government liaisoning';
const strReligiousTravel = 'Religious travel';
const strLocalTransportation = 'Local transportation';
const strCustomServices = 'Custom services';
const strBook = 'Book';
const strHomeCareCaps = 'Home Care';
const strSort = 'Sort';
const strFilter = 'Filter';
const strSortBy = 'Sort By';
const strCustomServicesCaps = 'Custom Services';
const strOpen = 'Open';
const strClosed = 'Closed';
const strNoActiveService = 'No active service';
const strNoActiveServicesLongText = 'Etiam tincidunt ac lectus eu pretium phasellus porttitor aliquam.';
const strRequestDetails = 'Request Details';
const strWhatAreYouLookingFor = 'What you are looking for? ';
const strSingleDay = 'Single day';
const strMultiDays = 'Multi days';
const strFromDateTime = 'From date & time';
const strToDateTime = 'To date & time';
const strBriefAboutYourService = 'Brief about your service';
const strSelectBeneficiary = 'Select beneficiary';
const strSubmit = 'Submit';
const strToday = 'Today';
const strTypeAMessage = 'Type a message';
const strDetailsChatLongText = 'Taxi with driver (up to 8 hours and 80 kilometers)';
const strServiceLongText = 'If you do not book this service within 7 days, it will be automatically expired.';
const strServiceExpireBookedLongText = 'If you do not book this service within 7 days, it will be automatically expired.';
const strServiceOfferExpiredLongText = 'Your custom service request has expired. If you still need assistance, please submit a new service request.';
const strServiceInfo = 'Service Info';
const strServiceInfoBottomSheetLongText1 = 'What you are looking for?';
const strServiceInfoBottomSheetLongText2 = 'Taxi with driver (up to 8 hours and 80 kilometers)';
const strDateTime = 'Date & Time';
const strServiceInfoBottomSheetLongText3 =
    'Aliquam nec purus auctor, aliquet tortor sed, commodo enim. Proin dignissim metus posuere dolor fermentum quis.';
const strBeneficiaryName = 'Beneficiary name';
const strBeneficiaryCity = 'Beneficiary city';
const strServiceDescription = 'Service Description';
const strServiceDetailsLongText1 = 'For light cleaning with mop.Excludes disc machine and cabinet\'s interior cleaning.';
const strIncluded = 'Included';
const strServiceDetailsLongText2 = 'Small fittings installation (towel hangers, holders, towel shelves, and soap dispensers)';
const strServiceDetailsLongText3 = 'Procurement of spare parts (at extra cost)';
const strServiceDetailsLongText4 = 'Labour charges for one fitting)';
const strServiceDetailsLongText5 = 'UC warranty & damage cover*';
const strServiceDetailsLongText6 = 'Warranty on spare parts provided or sourced by UC';
const strHowItWorks = 'How it Work';
const strDiagnosis = 'Diagnosis';
const strPretiumJaoreet = 'Pretium Jaoreet';
const strQuisque = 'Quisque';
const strBookNow = 'Book Now';
const strBookingDetails = 'Booking Details';
const strPoints = 'Points';
const strPrice = 'Price';
const strSummary = 'Summary';
const strSubTotal = 'Sub total';
const strTotal = 'Total';
const strCheckout = 'Checkout';
const strServiceBookingLongText = 'Your services has been booked';

///Booking
const strBookings = 'Bookings';
const strService = 'Service';
const strRequestDate = 'Request date';
const strBookingID = 'Booking ID';
const strBookingDate = 'Booking date';
const strServiceFrom = 'Service from';
const strServiceTo = 'Service to';
const strStatus = 'Status';
const strInProgress = 'In Progress';
const strCancelService = 'Cancel Service';
const strDetailsBookingLongText = 'You can cancel your booking within 24 hours of the booking date and time.';
const strRequested = 'Requested';
const strTracking = 'Tracking';
const strDetailsScreenCancelServiceLongText = 'Are you sure you want to cancel this service?';

///Extra
const strDefaultName1 = 'Marina Marker';
const strDefaultEmail1 = 'marinamarker@gmail.com';
const strDefaultDays = '9 days remaining';
const strDefaultDays2 = 'Renews on 10 Nov 2024';
const strDefaultPoints2458 = '2458';
const strDefaultSilverMemberShip = 'Silver';
const strDefaultGoldMemberShip = 'Gold';
const strDefaultPlatinumMemberShip = 'Platinum';
const strServiceDetailsLongText = 'Classic full home cleaning 3BHK';

///Attachments
const strAttachments = 'Attachments';

///Notifications And Search
const strNotifications = 'Notifications';
const strNoNotificationYet = 'No notifications yet';
const strSearch = 'Search';
const strNoResultFound = 'No result found';
const strSearchLongText = 'The service you have search which is not found right now please try later';
const strRecentSearch = 'Recent search';
const strClearAll = 'Clear all';

///from where common
const strFromBundlePurchase = 'From Bundle Purchase';
const strFromServiceBooking = 'From Service Booking';
const strFromHomeServiceBooking = 'From Home Service Booking';
const strFromBookingRequestDetails = 'From Booking Request Details';

