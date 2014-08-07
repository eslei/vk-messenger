//
//  AZViewController.m
//  Vk Test
//
//  Created by Artem on 16.07.14.
//  Copyright (c) 2014 eslei. All rights reserved.
//

#import "AZViewController.h"
#import "AZServerManager.h"
#import "AZUser.h"
#import "UIImageView+AFNetworking.h"
#import "AZMessagesViewController.h"
#import "AZSlideMenuViewController.h"
#import "REFrostedViewController.h"



@interface AZViewController ()

@property(strong, nonatomic) NSMutableArray* friendsArray;
@property(assign, nonatomic) BOOL firstTimeApear;

@end

@implementation AZViewController

static NSInteger friendsInReqest = 50;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.friendsArray = [NSMutableArray array];
    
    
    if (!self.firstTimeApear) {
        [[AZServerManager sharedManager] authoriseUser:^(AZUser *user) {
            
            NSLog(@"AUTHORIZED!");
            
            NSLog(@"%@ %@", user.firstName, user.lastName);
            
        }];
        
        self.firstTimeApear = YES;
    }
    
    
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    
    [self getFriendsFromServer];
    
    
}

+ (AZViewController*) instance {
    
    static AZViewController* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AZViewController alloc] init];
    });
    
    return manager;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (IBAction)showMenu:(id)sender{
    
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];

}


#pragma mark API
-(void)getFriendsFromServer{   // получаем список друзей.
    
    [[AZServerManager sharedManager]
     getFriendsWithOffset:[self.friendsArray count]
     count:friendsInReqest
     onSuccess:^(NSArray *friends) {
         
         [self.friendsArray addObjectsFromArray:friends];
         
         NSMutableArray* newPaths = [NSMutableArray array];
         for (int i = (int)[self.friendsArray count] - (int)[friends count]; i < [self.friendsArray count]; i++) {
             [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
         }
         
         [self.tableView beginUpdates];
         [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
         [self.tableView endUpdates];
         
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@, code = %d", [error localizedDescription], statusCode);
     }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.friendsArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.row == [self.friendsArray count]) {
        
    } else {
    
        AZUser* friend = [self.friendsArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
        
        NSURLRequest* request = [NSURLRequest requestWithURL:friend.imageURL];
        
        __weak UITableViewCell* weakCell = cell;
        
        cell.imageView.image = nil;
        
        [cell.imageView
         setImageWithURLRequest:request
         placeholderImage:nil
         
         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
             
             weakCell.imageView.image = image;
             
             [weakCell layoutSubviews];
             
         }
         
         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
             
         }];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AZMessagesViewController* messagesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageControler"];
    
    AZUser* user = [self.friendsArray objectAtIndex:indexPath.row];

    messagesVC.userID = [user.userID intValue];
    
    NSLog(@"didSelectRowAtIndexPath");
    
    [self.navigationController pushViewController:messagesVC animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    
        [self getFriendsFromServer];

    
}

@end
