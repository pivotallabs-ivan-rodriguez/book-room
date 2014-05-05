//
//  BRViewController.m
//  Book Room
//
//  Created by DX169-XL on 2014-05-05.
//  Copyright (c) 2014 Pivotal Labs. All rights reserved.
//

#import "BRHomeViewController.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLCalendar.h"

static NSString * const kKeychainItemName = @"Book a Room";
static NSString * const kClientID = @"776916698629-jm882d2nnh738lo5qio3quqehej4i4a3.apps.googleusercontent.com";
static NSString * const kClientSecret = @"8hTo-W7xyeQhVO3domrWM7Ys";

@interface BRHomeViewController ()

@property (nonatomic, strong) GTLServiceCalendar *calendarService;

@end

@implementation BRHomeViewController

#pragma mark -
#pragma mark Getters

- (GTLServiceCalendar *)calendarService {
    if (!_calendarService) {
        _calendarService = [[GTLServiceCalendar alloc] init];
        _calendarService.shouldFetchNextPages = YES;
        _calendarService.retryEnabled = YES;
    }
    return _calendarService;
}

#pragma mark -
#pragma mark Private Methods

- (void)viewDidLoad
{
    [super viewDidLoad];

    GTMOAuth2Authentication *auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName clientID:kClientID clientSecret:kClientSecret];
    if ([auth canAuthorize]) {
        [self isAuthorizedWithAuthentication:auth];

    } else {
        [self showAuthLoginViewController];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
    if (error) {
        NSLog(@"Auth failed %@",error);
    } else {
        [self isAuthorizedWithAuthentication:auth];
    }

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAuthLoginViewController {
    GTMOAuth2ViewControllerTouch *authViewController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeCalendar clientID:kClientID clientSecret:kClientSecret keychainItemName:kKeychainItemName delegate:self finishedSelector:@selector(viewController:finishedWithAuth:error:)];

    [self.navigationController presentViewController:authViewController animated:YES completion:nil];
}

- (void)isAuthorizedWithAuthentication:(GTMOAuth2Authentication *)auth {
    [self.calendarService setAuthorizer:auth];
    [self loadDriveFiles];
}

- (void)loadDriveFiles {
    GTLQueryCalendar *query = [GTLQueryCalendar queryForCalendarListList];

    [self.calendarService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        if (!error) {
            NSLog(@"response %@ - %@",object,[object class]);
        } else {
            NSLog(@"Request failed %@",error);
        }
    }];
}


@end