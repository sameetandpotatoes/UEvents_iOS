//
//  File.m
//  UEvents
//
//  Created by Sameet Sapra on 7/2/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "PageContentViewController.h"
#include <sys/utsname.h>
#import <QuartzCore/QuartzCore.h>
#import "UEvents-Swift.h"
@interface PageContentViewController ()
- (void) loginViewFetchedUserInfo;
- (void) loginViewShowingLoggedOutUser;
- (UIViewController*) topMostController;
@property User *model;
@property ENVRouter *env;
@property NSMutableData *responseData;
@property AppearanceController *appearanceController;
@end
@implementation PageContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.appearanceController = [[AppearanceController alloc] init];
    if ([_titleText isEqualToString:@"1"]){
        [self.introDescription setHidden:YES];
        [self.swipeText setHidden:NO];
        [self.pageControl setCurrentPage:0];
    } else{
        [self.swipeText setHidden:YES];
        [self.introDescription setHidden:NO];
        if ([self.appearanceController isIPAD]){
            self.introDescription.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25.0];
        }
        [self.pageControl setCurrentPage:1];
    }
    self.backgroundImageView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    self.backgroundImageView.backgroundColor = [UIColor whiteColor];
    //Scaling image
    CGSize size=CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height+40);//set the width and height
    UIGraphicsBeginImageContext(size);
    [self.backgroundImageView.image drawInRect:CGRectMake(0,-40,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    self.backgroundImageView.image = newImage;
    //here is the scaled image which has been changed to the size specified
    UIGraphicsEndImageContext();
    
    [self updateView];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
//        appDelegate.session = [[FBSession alloc] initWithAppID:[self.env getFacebookAppID]
//                                                   permissions:@[
//                                                                 @"email",
//                                                                 @"user_events",
//                                                                 @"friends_events",
//                                                                 @"user_groups",
//                                                                 @"rsvp_event"
//                                                                 ]
//                                               urlSchemeSuffix:nil
//                                            tokenCacheStrategy:nil];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                [self updateView];
            }];
        }
    }
}
- (void) updateView{
    NSLog(@"Updating View");
    // get the app delegate, so that we can reference the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // long-running code
            NSString *apiRequest = [NSString stringWithFormat:@"https://graph.facebook.com/me?access_token=%@", appDelegate.session.accessTokenData.accessToken];
            NSDictionary* headers = @{@"Accept": @"application/json",
                                      @"Content-type": @"application/json"};
            
            NSMutableDictionary *json= [[NSMutableDictionary alloc] init];
            UNIUrlConnection* asyncConnection = [[UNIRest get:^(UNISimpleRequest *request) {
                [request setUrl:apiRequest];
            }] asJsonAsync:^(UNIHTTPJsonResponse *response, NSError *error) {
                // Do something
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:[response rawBody] options:0 error:nil];
                self.model = [[User alloc] initWithUser:result];
                self.model.accessToken = appDelegate.session.accessTokenData.accessToken;
                if ([self createUser]){
                    EventsController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"events"];
                    secondViewController.user = self.model;
                    secondViewController.tag = @"All";
                    [self.navigationController pushViewController:secondViewController animated: true];
                } else{
                    SchoolSelector *school = [self.storyboard instantiateViewControllerWithIdentifier:@"school"];
                    school.user = self.model;
                    [self.navigationController pushViewController:school animated:true];
                }
            }];
        });
    } else {
        // login-needed account UI is shown whenever the session is closed
//        [self.buttonLoginLogout setTitle:@"Log in" forState:UIControlStateNormal];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClickHandler:(id)sender {
    // get the app delegate so that we can access the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];
        NSLog(@"Clear session");
    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        NSLog(@"Logging in");
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            [self updateView];
        }];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Home Screen";
}
- (bool) createUser{
    self.env = [[ENVRouter alloc] initWithCurUser:self.model];
    NSDictionary* headers = @{@"Accept": @"application/json",
                              @"Content-type": @"application/json"};
    
    NSMutableDictionary *json= [[NSMutableDictionary alloc] init];
    NSMutableDictionary *realJson= [[NSMutableDictionary alloc] init];
    [realJson setObject:self.model.firstName forKey:@"first_name"];
    [realJson setObject:self.model.lastName forKey:@"last_name"];
    [realJson setObject:self.model.pictureURL forKey:@"picture_url"];
    [realJson setObject:self.model.userId forKey:@"id"];
    [realJson setObject:self.model.email forKey:@"email"];
    [realJson setObject:self.model.accessToken forKey:@"access_token"];
    [realJson setObject:@"" forKey:@"school_id"];
    UNIHTTPJsonResponse* response = [[UNIRest postEntity:^(UNIBodyRequest* request) {
        [request setUrl:[self.env getPostUserURL]];
        NSLog([self.env getPostUserURL]);
        [request setHeaders:headers];
        // Converting NSDictionary to JSON
        [request setBody:[NSJSONSerialization dataWithJSONObject:realJson options:0 error:nil]];
    }] asJson];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:[response rawBody] options:0 error:nil];
    NSLog(@"RESULT");
    NSLog(@"%@", result);
    if (result != nil){
        self.model.authToken = [[result valueForKey:@"user"] valueForKey:@"authentication_token"];
        NSDictionary *school = [[result valueForKey:@"user"] valueForKey:@"school"];
        if (!(school == [NSNull null])){
            self.model.schoolId = [school valueForKey:@"id"];
            self.model.schoolName = [school valueForKey:@"name"];
            return true;
        } else{
            return false;
        }
    } else{
        return false;
    }
}
@end
