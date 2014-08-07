//
//  AZSlideMenuViewController.m
//  Vk Test
//
//  Created by Artem on 01.08.14.
//  Copyright (c) 2014 eslei. All rights reserved.
//

#import "AZSlideMenuViewController.h"
#import "AZServerManager.h"
#import "AZUser.h"
#import "UIImageView+AFNetworking.h"
#import "AZNavigationController.h"
#import "AZViewController.h"
#import "AZLoginViewController.h"
#import "REFrostedViewController.h"
#import "AZDialogsViewController.h"

@interface AZSlideMenuViewController ()

@property(weak, nonatomic) UIWebView* webView;



@end

@implementation AZSlideMenuViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    
    AZUser* user = [AZServerManager sharedManager].currentUser;
    
    
    [self.avaView setImageWithURL:user.bigImageURL];
    
    
    self.labelName.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];

}





- (IBAction)showFriends:(id)sender {
    
    AZNavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    
        AZViewController *frindsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"friendsController"];
        navigationController.viewControllers = @[frindsViewController];
       
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}

- (IBAction)showMessages:(id)sender {
    
    AZNavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    
    AZDialogsViewController *DialogsController = [self.storyboard instantiateViewControllerWithIdentifier:@"DialogsController"];
    navigationController.viewControllers = @[DialogsController];
    
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];

    
    
}

- (IBAction)outLog:(id)sender {
    
    NSHTTPCookie *c;
    NSHTTPCookieStorage *s = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (c in [s cookies]) {
        NSString* domainName = [c domain];
        NSRange domainRange = [domainName rangeOfString:@"vk.com"];
        if(domainRange.length > 0) {
            [s deleteCookie:c];
        }
    }
    
    [[AZServerManager sharedManager] authoriseUser:^(AZUser *user) {
        
    }];
    
}



@end
