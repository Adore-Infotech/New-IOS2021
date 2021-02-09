//
//  NSObject+LoginViewController.m
//  Riot
//
//  Created by Arun on 28/02/18.
//  Copyright © 2018 matrix.org. All rights reserved.
//

#import "LoginViewController.h"
#import "ThemeService.h"
#import "Riot-Swift.h"
#import "Tools.h"

#import "CountryPickerViewController.h"
#import "NBPhoneNumberUtil.h"

#import "RiotNavigationController.h"
#import "NSData+AES.h"
#import "NSString+hex.h"
#import <MatrixSDK/MatrixSDK.h>
@interface LoginViewController ()
{
    
    UINavigationController *phoneNumberPickerNavigationController;
    CountryPickerViewController *phoneNumberCountryPicker;
    NBPhoneNumber *nbPhoneNumber;
    
    UIView *modalView;
    
    MXRestClient *mxRestClient;
    MXHTTPOperation *mxCurrentOperation;
}
@end
@implementation LoginViewController

#pragma mark - View Design & Loading

-(void)viewDidLoad {
   
    self.tipView.hidden = true;
    self.tipImg.image = [UIImage imageNamed:@"slider1.png"];
    
    self.continueButton.userInteractionEnabled = false;
    self.continueButton.enabled = false;
    self.continueButton.alpha = 0.5;

    self.termsView.hidden = false;
    self.termsTxt.text = @"GoIP2call have created this privacy statement to demonstrate commitment to our customer. Please read the privacy policy carefully to get a clear understanding of how we collect, use, protect or otherwise handle your Personally Identifiable Information in accordance with our website, products, and Mobile Apps. The following discloses our information gathering and dissemination practices for www.goip2call.com. \n\nGoIP2call provides Voice Call, Video Call, messaging, and other services to users around the globe. Our Privacy Policy helps explain our information practices connected to what information we collect and how this affects you. the policy also clarifies the steps in place to protect your privacy in our Mobile Apps, so delivered messages are not stored and giving you control over who you communicate with on our Services. \n\nThis Privacy Policy (“Privacy Policy”) applies to all of our apps, services, features, software, and website (together, “Services”) unless specified otherwise. \n\nInformation We Collect \n\nGoIP2call receives or collects information when we operate and provide our Services, including when you install, access, or use our apps and software. \n\nInformation You Provide \n\nYour Account Information – You provide your mobile phone number to create an account. You provide us the phone numbers in your mobile address book on a regular basis, including those of both the users of our Services and your other contacts. You confirm you are authorized to provide us such numbers. GoIP2call uploads your Phone book contacts to https://billing.goip2call.com/ to find out your friendly contacts in our Communicator. This enables you to connect with your friends, families and others who are already registered in GoIP2call Communicator. \n\nYour Messages – We do not retain your messages in the ordinary course of providing our Services to you. Once your messages (including your chats, photos, videos, voice messages, files etc.) are delivered, they are deleted from our servers. Your messages are stored on your own device. We also offer end-to-end encryption for our Services, which is on by default. End-to-end encryption means that your messages are encrypted to protect against us and third parties from reading them. \n\nYour Connections – To help you organize how you communicate with others; we may create a favorites list of your contacts for you and lists get associated with your account information. \n\nCustomer Support – You may provide us with information related to your use of our Services, including copies of your messages, and how to contact you so we can provide you customer support. For example, you may send us an email with information relating to our app performance or other issues along with you can directly contact us with our Live Support Customer Care on our website www.goip2call.com. \n\nAutomatically Collected Information \n\nUsage and Log Information – We collect service-related, diagnostic, and performance information. This includes information about your activity (such as how you use our Services, how you interact with others using our Services, and the like), log files, and diagnostic, crash, website, and performance logs and reports. \n\nTransactional Information – If you pay for our Services, we may receive information and confirmations, such as payment receipts, including from app stores or other third parties processing your payment. \n\nDevice and Connection Information – We collect device-specific information when you install, access, or use our Services. This includes information such as hardware model, operating system information, browser information, IP address, mobile network information including phone number, and device identifiers. We collect device location information if you use our location features, such as when you choose to share your location with your contacts. \n\nCookies – We use cookies to operate and provide our Services, improve your experiences, understand how our Services are being used, and customize our Services. We may use cookies to remember your choices, such as your language preferences, and otherwise to customize our Services for you. We use cookies to understand, secure, operate, and provide our Services. For example, we use cookies: \n\n* to provide GoIP2call website and other Services, improve your experiences, understand how our Services are being used, and customize our Services. \n\n* to remember your choices, such as your language preferences, and otherwise to customize our Services for you \n\n* Status Information. We collect information about your online and status message changes on our Services, such as whether you are online (your “online status”), when you last used our Services (your “last seen status”), and when you last updated your status message. \n\nThird-Party Information \n\nInformation Others Provide About You – We receive information other people provide us, which may include information about you. For example, when other users you know use our Services, they may provide your phone number from their mobile address book (just as you may provide theirs), or they may send you a message to which you belong, or call you. \n\nThird-Party Providers – We work with third-party providers to help us operate, provide, improve, understand, customize, support, and market our Services. For example, we work with companies to distribute our apps, provide our infrastructure, delivery, and other systems, process payments, help us understand how people use our Services, and market our Services. These providers may provide us information about you in certain circumstances; for example, app stores may provide us reports to help us diagnose and fix service issues. \n\nThird-Party Services – We allow you to use our Services in connection with third-party services. If you use our Services with such third-party services, we may receive information about you from them. \n\nHow We Use Information \n\nWe use all the information that help us operate, provide, improve, understand, customize, support, and market our products and services. \n\nOur Products & Services – We operate and provide our products & Services, including providing customer support, and improving, fixing, and customizing our Products. We understand how people use our Products and analyze and use the information that help to evaluate and improve our Products, research, develop, and test new features, and conduct troubleshooting activities. We also use your information to respond to you when you contact us. \n\nSafety and Security – We verify accounts and activity and promote safety and security on and off our Services, such as by investigating suspicious activity or violations of our Terms, and to ensure our Services are being used legally. \n\nThird-Party Banner Ads – We do not allow third-party banner ads on our products and mobile apps. We have no intention to introduce them, but if we ever do, we will update this policy. \n\nInformation You and We Share \n\nYou share your information as you use and communicate through our products and mobile apps, and we share your information to help us operate, provide, improve, understand, customize, support, and improve our Services. \n\nAccount Information – Your phone number, profile name and photo, online status and status message, last seen status, and receipts may be available to anyone who uses our Services and connect with you via GoIP2call’s Apps. \n\nYour Contacts and Others – Users with whom you communicate may store or reshare your information (including your phone number or messages) with others on and off our Services. You can use your Services settings and the block feature in our Services to manage the users of our Services with whom you communicate and certain information you share. \n\nThird-Party Providers – We work with third-party providers to help us added add-ons features in our Mobile Apps. When you use these features with third-party, we require them to use your information in accordance with our instructions and terms or with express permission from you. \n\nThird-Party Services – When you use third-party services that are integrated with our apps, they may receive information about what you share with them. If you interact with a third-party service linked through our Services, you may be providing information directly to such third party. Please note that when you use third-party services, their own terms and privacy policies will govern your use of those services. \n\nManaging Your Information \n\nIf you would like to manage, change, limit, or delete your information, we allow you to do that through the following tools: \n\nServices Settings. You can change your Services settings to manage certain information available to other users. You can manage your contacts, groups, and broadcast lists, to manage the users with whom you communicate. \n\nChanging Your Mobile Phone Number, Profile Name and Picture. You must change your mobile phone number using our in-app change number feature. You can also change your profile name, profile picture, and status message at any time. \n\nDeleting Your Account. You may delete your account at any time. When you delete your account, your undelivered messages are deleted from our servers as well as any of your other information we no longer need to operate and provide our Services. Be mindful that if you only delete our Services from your device without using our in-app delete my account feature, your information may be stored with us for a longer period. Please remember that when you delete your account, it does not affect the information other users have relating to you, such as their copy of the messages you sent them. \n\nLaw and Protection \n\nWe may collect, use, preserve, and share your information if we have a good-faith belief that it is reasonably necessary to: (a) respond pursuant to applicable law or regulations, to legal process, or to government requests; (b) enforce our Terms and any other applicable terms and policies, including for investigations of potential violations; (c) detect, investigate, prevent, and address fraud and other illegal activity, security, or technical issues; or (d) protect the rights, property, and safety of our users. \n\nUpdates to Our Policy \n\nWe may amend or update our Privacy Policy. We will provide you notice of amendments to this Privacy Policy, If you do not agree to our Privacy Policy, as amended, you must stop using our Services. Please review our Privacy Policy from time to time. \n\nIf you have questions about our Privacy Policy, please contact us. goip2call@goiptrading.com or visit our website www.goip2call.com and chat with our support team.";

    [self customizeViewRendering];
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    self.isoCountryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    [self setIsoCountryCode:self.isoCountryCode];
   
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    // numberToolbar.barStyle =UIBarStyleBlackTranslucent;
    
    [numberToolbar setTranslucent:NO];
    [numberToolbar setBackgroundColor:[UIColor purpleColor]];
    numberToolbar.items = [NSArray arrayWithObjects:
                           
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignkeyboards)],
                           nil];
    [numberToolbar sizeToFit];
    _emailTextField.inputAccessoryView = numberToolbar;
    _phoneTextField.inputAccessoryView = numberToolbar;
    _otpTextField.inputAccessoryView = numberToolbar;
    
}

- (IBAction)btnResendOnClick:(id)sender {
    [self RequestOTP];
}

-(void)resignkeyboards
{
    [_emailTextField resignFirstResponder];
    [_phoneTextField resignFirstResponder];
    [_otpTextField resignFirstResponder];
}

-(void)customizeViewRendering
{
    
//    self.phoneTextField.textColor = kRiotPrimaryTextColor;
//
//    self.isoCountryCodeLabel.textColor = kRiotPrimaryTextColor;
//    self.callingCodeLabel.textColor = kRiotPrimaryTextColor;
    
    self.view.backgroundColor = ThemeService.shared.theme.backgroundColor;
    self.phoneTextField.textColor = ThemeService.shared.theme.textPrimaryColor;
    self.otpTextField.textColor = ThemeService.shared.theme.textPrimaryColor;
    self.emailTextField.textColor = ThemeService.shared.theme.textPrimaryColor;

    self.isoCountryCodeLabel.textColor = ThemeService.shared.theme.textPrimaryColor;
    self.callingCodeLabel.textColor = ThemeService.shared.theme.textPrimaryColor;
    
    if (ThemeService.shared.theme.placeholderTextColor)
    {
        if (self.phoneTextField.placeholder)
        {
            self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc]
                                                         initWithString:self.emailTextField.placeholder
                                                         attributes:@{NSForegroundColorAttributeName: ThemeService.shared.theme.placeholderTextColor}];

            self.phoneTextField.attributedPlaceholder = [[NSAttributedString alloc]
                                                         initWithString:self.phoneTextField.placeholder
                                                         attributes:@{NSForegroundColorAttributeName: ThemeService.shared.theme.placeholderTextColor}];
        }
        
    }
}

#pragma mark -
- (IBAction)selectPhoneNumberCountry:(id)sender
{
    phoneNumberCountryPicker = [CountryPickerViewController countryPickerViewController];
    phoneNumberCountryPicker.delegate = self;
    phoneNumberCountryPicker.showCountryCallingCode = YES;
    
    phoneNumberPickerNavigationController = [[UINavigationController alloc] initWithRootViewController:phoneNumberCountryPicker];
    
    // Set Riot navigation bar colors
    phoneNumberPickerNavigationController.navigationBar.barTintColor = ThemeService.shared.theme.backgroundColor;
    NSDictionary<NSString *,id> *titleTextAttributes = phoneNumberPickerNavigationController.navigationBar.titleTextAttributes;
    if (titleTextAttributes)
    {
        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionaryWithDictionary:titleTextAttributes];
        textAttributes[NSForegroundColorAttributeName] = ThemeService.shared.theme.placeholderTextColor;
        phoneNumberPickerNavigationController.navigationBar.titleTextAttributes = textAttributes;
    }
    else if (ThemeService.shared.theme.placeholderTextColor)
    {
        phoneNumberPickerNavigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: ThemeService.shared.theme.placeholderTextColor};
    }
    
    //[phoneNumberPickerNavigationController pushViewController:phoneNumberCountryPicker animated:NO];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissCountryPicker)];
    phoneNumberCountryPicker.navigationItem.leftBarButtonItem = leftBarButtonItem;
    [self presentViewController:phoneNumberPickerNavigationController animated:YES completion:nil];
    
    //[self.navigationController pushViewController:phoneNumberPickerNavigationController animated:YES];
    //[self presentViewController:phoneNumberPickerNavigationController];
}

#pragma mark - MXKCountryPickerViewControllerDelegate

- (void)countryPickerViewController:(MXKCountryPickerViewController *)countryPickerViewController didSelectCountry:(NSString *)isoCountryCode { 
    self.isoCountryCode = isoCountryCode;
    
    nbPhoneNumber = [[NBPhoneNumberUtil sharedInstance] parse:self.phoneTextField.text defaultRegion:isoCountryCode error:nil];
    [self setIsoCountryCode:isoCountryCode];
    [self formatNewPhoneNumber];
    
    [self dismissCountryPicker];
}
#pragma mark -
- (void)setIsoCountryCode:(NSString *)isoCountryCode
{
    _isoCountryCode = isoCountryCode;
    
    NSNumber *callingCode = [[NBPhoneNumberUtil sharedInstance] getCountryCodeForRegion:isoCountryCode];
    
    self.callingCodeLabel.text = [NSString stringWithFormat:@"+%@", callingCode.stringValue];
    
    self.isoCountryCodeLabel.text = isoCountryCode;
    
    // Update displayed phone
    [self textFieldDidChange:self.phoneTextField];
}
- (void)dismissCountryPicker
{
    [phoneNumberCountryPicker withdrawViewControllerAnimated:YES completion:nil];
    [phoneNumberCountryPicker destroy];
    phoneNumberCountryPicker = nil;
    
    [phoneNumberPickerNavigationController dismissViewControllerAnimated:YES completion:nil];
    phoneNumberPickerNavigationController = nil;
}
- (void)formatNewPhoneNumber
{
    if (nbPhoneNumber)
    {
        NSString *formattedNumber = [[NBPhoneNumberUtil sharedInstance] format:nbPhoneNumber numberFormat:NBEPhoneNumberFormatINTERNATIONAL error:nil];
        
        NSString *prefix = self.callingCodeLabel.text;
       
        if ([formattedNumber hasPrefix:prefix])
        {
            // Format the display phone number
            self.phoneTextField.text = [formattedNumber substringFromIndex:prefix.length];
        }
    }
}
- (IBAction)textFieldDidChange:(id)sender
{
    UITextField* textField = (UITextField*)sender;
    
    if (textField == self.phoneTextField)
    {
        nbPhoneNumber = [[NBPhoneNumberUtil sharedInstance] parse:self.phoneTextField.text defaultRegion:self.isoCountryCode error:nil];
        
        [self formatNewPhoneNumber];
    }
}

- (IBAction)checkButtonClick:(id)sender {

    if ([self.checkButton.currentImage isEqual:[UIImage imageNamed:@"uncheck.png"]]) {
     
        [self.checkButton setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        
        self.continueButton.userInteractionEnabled = true;
        self.continueButton.enabled = true;
        self.continueButton.alpha = 1.0;

    } else {

        [self.checkButton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        
        self.continueButton.userInteractionEnabled = false;
        self.continueButton.enabled = false;
        self.continueButton.alpha = 0.5;
    }
}

- (IBAction)continueButtonClick:(id)sender {

    self.termsView.hidden = true;
}

- (IBAction)tipButtonClick:(id)sender {

    if ([self.tipImg.image isEqual:[UIImage imageNamed:@"slider1.png"]]) {

        //Slider 1
        
        [UIView animateWithDuration:2.0f animations:^{

            self.tipImg.image = [UIImage imageNamed:@"slider2.png"];

        } completion:nil];
    }
    else if ([self.tipImg.image isEqual:[UIImage imageNamed:@"slider2.png"]]) {
        
        //Slider 2
        
        [UIView animateWithDuration:2.0f animations:^{

            self.tipImg.image = [UIImage imageNamed:@"slider3.png"];

        } completion:nil];
    }
    else if ([self.tipImg.image isEqual:[UIImage imageNamed:@"slider3.png"]]) {
        
        //Slider 3
        
        [UIView animateWithDuration:2.0f animations:^{

            self.tipImg.image = [UIImage imageNamed:@"slider4.png"];

        } completion:nil];
    }
    else if ([self.tipImg.image isEqual:[UIImage imageNamed:@"slider4.png"]]) {
        
        //Slider 4
        
        UIImage *btnImage = [UIImage imageNamed:@"ok.png"];
        [self.tipNextButton setImage:btnImage forState:UIControlStateNormal];
        
        [self loginWithParameters:loginParameters];
    }
}

- (IBAction)nextButtonClick:(id)sender {
   
    /*
     modalView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     modalView.opaque = NO;
     modalView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
     CGRect screenRect = [[UIScreen mainScreen] bounds];
     CGFloat screenWidth = screenRect.size.width;
     CGFloat screenHeight = screenRect.size.height;
     
     UILabel *label = [[UILabel alloc] init];
     label.frame=CGRectMake(0, screenHeight/2, screenWidth, 50);
     label.text = @"Please wait...";
     label.textColor = [UIColor whiteColor];
     label.backgroundColor = [UIColor clearColor];
     label.opaque = NO;
     //[label sizeToFit];
     label.textAlignment=NSTextAlignmentCenter;
     [modalView addSubview:label];
     [self.view addSubview:modalView];
     [self performSelectorInBackground:@selector(RequestOTP) withObject:nil];
     */
    [self RequestOTP];
}

- (IBAction)verifyButtonClick:(id)sender{
    [self VerifyOTP];
}


//light blue : #00afef  Dark code: #3e4095


#pragma mark - API Calls

-(void)RequestOTP {
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        self->_nextButton.userInteractionEnabled = false;
    });
    
    [_phoneTextField resignFirstResponder];
        
    if ([[NBPhoneNumberUtil sharedInstance] isPossibleNumber:nbPhoneNumber]) {
        
        if (_emailTextField.text.length > 0 && [self isValidEmail:_emailTextField.text]) {
          
            [self addPendingActionMask:_LoginContainer];

            NSString *ccode = [[[NBPhoneNumberUtil sharedInstance] getCountryCodeForRegion:self.isoCountryCode] stringValue];
            
            NSString *phone = [[NBPhoneNumberUtil sharedInstance] format:nbPhoneNumber numberFormat:NBEPhoneNumberFormatE164 error:nil];
            NSString *prefix = self.callingCodeLabel.text;
           
            if ([phone hasPrefix:prefix])
            {
                phone = [phone substringFromIndex:prefix.length];
            }
            
            NSString *key = RiotSettings.shared.encKey;
            NSData *plain = [ccode dataUsingEncoding:NSUTF8StringEncoding];
            NSData *cipher = [plain AES128EncryptedDataWithKey:key];
            NSString *base64Encoded = [cipher base64EncodedStringWithOptions:0];
            NSString *hexccode = [base64Encoded stringToHex:base64Encoded];
            
            plain = [phone dataUsingEncoding:NSUTF8StringEncoding];
            cipher = [plain AES128EncryptedDataWithKey:key];
            base64Encoded = [cipher base64EncodedStringWithOptions:0];
            NSString *hexphone = [base64Encoded stringToHex:base64Encoded];
            
            plain = [_emailTextField.text dataUsingEncoding:NSUTF8StringEncoding];
            cipher = [plain AES128EncryptedDataWithKey:key];
            base64Encoded = [cipher base64EncodedStringWithOptions:0];
            NSString *hexemail = [base64Encoded stringToHex:base64Encoded];

            NSString *post = [NSString stringWithFormat:@"ccode=%@&phone=%@&email=%@", hexccode, hexphone, hexemail];
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            NSString *url_string = RiotSettings.shared.otpRequestUrl;
            [request setURL:[NSURL URLWithString:url_string]];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    [self removePendingActionMask];
                });

                NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                NSLog(@"requestReply: %@", requestReply);
               
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    self->_nextButton.userInteractionEnabled = true;
                });
                
                if (data == nil)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert78 = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                          message:@"Please Make sure you have a Working Internet Connection."
                                                                         delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: Nil];
                        
                        
                        [alert78 show];
                    });
                }
                else
                {
                    if (requestReply != nil || ![requestReply isEqual:@""])
                    {
                        
                        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        NSLog(@"%@",json);
                     
                        if (json != nil) {
                            
                            NSString *result =[json objectForKey:@"result"];
                            NSString *msg = [json objectForKey:@"OTP"];
                            if([result isEqualToString:@"success"]){
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [UIView transitionWithView:_LoginContainer
                                                      duration:0.4
                                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                                    animations:^{
                                                        _LoginContainer.hidden = YES;
                                                    }
                                                    completion:NULL];
                                    [UIView transitionWithView:_OTPContainer
                                                      duration:0.4
                                                       options:UIViewAnimationOptionShowHideTransitionViews
                                                    animations:^{
                                                        _OTPContainer.hidden = NO;
                                                    }
                                                    completion:NULL];
                                    [_otpTextField becomeFirstResponder];
                                    //int msg1 = [[json objectForKey:@"otpinfo"]intValue];
                                   
                                    UIAlertView *alert78 = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                                      message:msg
                                                                                     delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: Nil];
                                    
                                    
                                    [alert78 show];
                                    
                                });
                            } else {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    UIAlertView *alert78 = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                                      message:msg
                                                                                     delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: Nil];
                                    
                                    
                                    [alert78 show];
                                });
                            }
                        }
                        else
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIAlertView *alert78 = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                                  message:@"An error occured please try again later."
                                                                                 delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: Nil];
                                
                                
                                [alert78 show];
                            });
                            
                        }
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *alert78 = [[UIAlertView alloc]  initWithTitle:@"Alert"
                                                                               message:@"Please Make sure you have a Working Internet Connection."
                                                                              delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: Nil];
                            
                            
                            [alert78 show];
                        });
                    }
                }
            }] resume];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert78 = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                  message:@"Please enter valid email id"
                                                                 delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: Nil];
                
                
                [alert78 show];
            });
            
            return;
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert78 = [[UIAlertView alloc]  initWithTitle:@"Alert"
                                                               message:@"Please enter a valid phone number."
                                                              delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: Nil];
            
            
            [alert78 show];
        });
    }
}

-(BOOL)isValidEmail : (NSString*)emailAddress
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailPredicate evaluateWithObject:emailAddress];
}

-(void)VerifyOTP {
    
    [_otpTextField resignFirstResponder];
   
    if (_otpTextField.text.length >= 4) {
        
        [self addPendingActionMask:_OTPContainer];

        NSString *ccode = [[[NBPhoneNumberUtil sharedInstance] getCountryCodeForRegion:self.isoCountryCode] stringValue];
        
        NSString *phone = [[NBPhoneNumberUtil sharedInstance] format:nbPhoneNumber numberFormat:NBEPhoneNumberFormatE164 error:nil];
        
        phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];

        NSString *prefix = self.callingCodeLabel.text;
       
        if ([phone hasPrefix:prefix])
        {
            phone = [phone substringFromIndex:prefix.length];
        }
        
        NSString *key = RiotSettings.shared.encKey ;
        NSData *plain = [ccode dataUsingEncoding:NSUTF8StringEncoding];
        NSData *cipher = [plain AES128EncryptedDataWithKey:key];
        NSString *base64Encoded = [cipher base64EncodedStringWithOptions:0];
        NSString *hexccode = [base64Encoded stringToHex:base64Encoded];
        
        plain = [phone dataUsingEncoding:NSUTF8StringEncoding];
        cipher = [plain AES128EncryptedDataWithKey:key];
        base64Encoded = [cipher base64EncodedStringWithOptions:0];
        NSString *hexphone = [base64Encoded stringToHex:base64Encoded];
        
        NSString *otp = _otpTextField.text;
        plain = [otp dataUsingEncoding:NSUTF8StringEncoding];
        cipher = [plain AES128EncryptedDataWithKey:key];
        base64Encoded = [cipher base64EncodedStringWithOptions:0];
        NSString *hexotp = [base64Encoded stringToHex:base64Encoded];
        
        plain = [_emailTextField.text dataUsingEncoding:NSUTF8StringEncoding];
        cipher = [plain AES128EncryptedDataWithKey:key];
        base64Encoded = [cipher base64EncodedStringWithOptions:0];
        NSString *hexemail = [base64Encoded stringToHex:base64Encoded];

        NSString *post = [NSString stringWithFormat:@"ccode=%@&phone_user=%@&otp=%@&email=%@", hexccode, hexphone, hexotp, hexemail];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSString *url_string = RiotSettings.shared.otpVerifyUrl;
        [request setURL:[NSURL URLWithString:url_string]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
          
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [self removePendingActionMask];
            });

            NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"requestReply: %@", requestReply);
         
            if (data == nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert78 = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                      message:@"Please Make sure you have a Working Internet Connection."
                                                                     delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: Nil];
                    
                    
                    [alert78 show];
                });
            }
            else
            {
                if(requestReply!=nil||![requestReply isEqual:@""])
                {
                    
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    NSLog(@"%@",json);
                  
                    if (json != nil)
                    {
                        NSString *result =[json objectForKey:@"result"];
                        
                        NSString *msg = [json objectForKey:@"OTP"];
                        
                        if ([result isEqualToString:@"success"]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                NSString *Username =[[json objectForKey:@"userinfo"] objectForKey:@"username"];
                                NSString *Password =[[json objectForKey:@"userinfo"] objectForKey:@"password"];
                                
                                [[NSUserDefaults standardUserDefaults] setObject:Username forKey:@"Username"];
                                [[NSUserDefaults standardUserDefaults] setObject:Password forKey:@"Password"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                NSLog(@"Username: %@ --- Password: %@",Username,Password);
                                
                                    self->loginParameters = @{
                                                   @"type": kMXLoginFlowTypePassword,
                                                   @"identifier": @{
                                                           @"type": kMXLoginIdentifierTypeUser,
                                                           @"user": Username
                                                           },
                                                   @"password": Password
                                                   };
                                
                                [self.tipView setAlpha:0.0f];

                                //fade in
                                [UIView animateWithDuration:2.0f animations:^{

                                    [self.tipView setAlpha:1.0f];

                                } completion:nil];

                                self.tipView.hidden = false;
                                
                                //[self loginWithParameters:parameters];
                                
                            });
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIAlertView *alert78 = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                                  message:msg
                                                                                 delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: Nil];
                                
                                
                                [alert78 show];
                            });
                        }
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *alert78 = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                              message:@"An error occured please try again later."
                                                                             delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: Nil];


                            [alert78 show];
                        });

                    }
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert78 = [[UIAlertView alloc]  initWithTitle:@"Alert"
                                                                           message:@"Please Make sure you have a Working Internet Connection."
                                                                          delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: Nil];
                        
                        
                        [alert78 show];
                    });
                }
            }
        }] resume];
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert78 = [[UIAlertView alloc]  initWithTitle:@"Alert"
                                                               message:@"Please enter a valid OTP."
                                                              delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: Nil];
            
            
            [alert78 show];
        });
    }
}

- (void)loginWithParameters:(NSDictionary*)parameters
{
    // Add the device name
    NSMutableDictionary *theParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    theParameters[@"initial_device_display_name"] = nil;
    NSString *homeserverURL = RiotSettings.shared.homeserverUrlString ;
    NSString *identityserverurl = RiotSettings.shared.identityServerUrlString;
    
    mxRestClient = [[MXRestClient alloc]initWithHomeServer:homeserverURL andOnUnrecognizedCertificateBlock:nil];
    mxRestClient.identityServer = identityserverurl;
    mxCurrentOperation = [mxRestClient login:theParameters success:^(NSDictionary *JSONResponse) {
        
        MXLoginResponse *loginResponse;
        MXJSONModelSetMXJSONModel(loginResponse, MXLoginResponse, JSONResponse);

        MXCredentials *credentials = [[MXCredentials alloc] initWithLoginResponse:loginResponse
                                                            andDefaultCredentials:self->mxRestClient.credentials];
        /// Sanity check
        if (!credentials.userId || !credentials.accessToken)
        {
            [self onFailureDuringAuthRequest:[NSError errorWithDomain:MXKAuthErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:[NSBundle mxk_localizedStringForKey:@"not_supported_yet"]}]];
        }
        else
        {
            NSLog(@"[MXKAuthenticationVC] Login process succeeded");

            // Report the certificate trusted by user (if any)
            credentials.allowedCertificate = self->mxRestClient.allowedCertificate;
            
            [self onSuccessfulLogin:credentials];
        }
        
    } failure:^(NSError *error) {
        
        [self onFailureDuringAuthRequest:error];
        
    }];
}

- (void)onSuccessfulLogin:(MXCredentials*)credentials
{
  
    mxCurrentOperation = nil;
   
    
    // Sanity check: check whether the user is not already logged in with this id
    if (![[MXKAccountManager sharedManager] accountForUserId:credentials.userId])
    {
        // Report the new account in account manager
        MXKAccount *account = [[MXKAccount alloc] initWithCredentials:credentials];
        //NSString *identityserverurl = [[NSUserDefaults standardUserDefaults] objectForKey:@"identityserverurl"];
        //account.identityServerURL = identityserverurl;
        //[account setIdentityServerURL:identityserverurl];
        
        [[MXKAccountManager sharedManager] addAccount:account andOpenSession:YES];
        if (self.authVCDelegate)
        {
            [self.authVCDelegate authenticationViewControllerDidDismiss:self];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}
-(void)onFailureDuringAuthRequest:(NSError *)error {
    UIAlertView *alert78 = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                      message:@"Login failed"
                                                     delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: Nil];
    
    
    [alert78 show];
}

- (void)removePendingActionMask
{
    if (self->pendingMaskSpinnerView)
    {
        [self->pendingMaskSpinnerView removeFromSuperview];
        self->pendingMaskSpinnerView = nil;
    }
}

- (void)addPendingActionMask:(UIView *)view
{
    // Add a spinner above the tableview to avoid that the user tap on any other button
    pendingMaskSpinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    pendingMaskSpinnerView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5];
    pendingMaskSpinnerView.frame = CGRectMake(0, 0, 50, 50);
    pendingMaskSpinnerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    pendingMaskSpinnerView.center = view.center;
    pendingMaskSpinnerView.layer.cornerRadius = 5.0;
    
    // append it
    [view.superview addSubview:pendingMaskSpinnerView];
    
    // animate it
    [pendingMaskSpinnerView startAnimating];
    
    // Show the spinner after a delay so that if it is removed in a short future,
    // it is not displayed to the end user.
    pendingMaskSpinnerView.alpha = 0;
    
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        pendingMaskSpinnerView.alpha = 1;
        
    } completion:^(BOOL finished) {
    }];
}

@end
