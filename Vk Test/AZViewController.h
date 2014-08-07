//
//  AZViewController.h
//  Vk Test
//
//  Created by Artem on 16.07.14.
//  Copyright (c) 2014 eslei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AZViewController : UITableViewController


@property(strong, nonatomic) NSString* selectUserID;

+ (AZViewController*) instance;

-(void)getFriendsFromServer;

- (IBAction)showMenu:(id)sender;


@end
