//
//  AZDialogsViewController.m
//  Vk Test
//
//  Created by Artem on 02.08.14.
//  Copyright (c) 2014 eslei. All rights reserved.
//

#import "AZDialogsViewController.h"
#import "AZServerManager.h"
#import "AZDialog.h"
#import "UIImageView+AFNetworking.h"
#import "AZUser.h"
#import "REFrostedViewController.h"
#import "AZDialogCell.h"

@interface AZDialogsViewController ()

@property(strong, nonatomic) UITableView* tableView;
@property(strong, nonatomic) NSMutableArray* dialogsArray;
@property(assign, nonatomic) NSInteger count;

@end

@implementation AZDialogsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dialogsArray = [NSMutableArray array];
    
    [self getDialogFromServer:[self.dialogsArray count]];
    
    UIRefreshControl* refresh = [[UIRefreshControl alloc] init];
    
    self.refreshControl = refresh;

    
    [self.refreshControl addTarget:self action:@selector(refreshDialogs) forControlEvents:UIControlEventValueChanged];
    
    
    
    
   }


-(void)refreshDialogs {
    
    
    [[AZServerManager sharedManager]
     getDialogs:0
     Count:MAX(50, [self.dialogsArray count])
     unread:0
     onSuccess:^(NSArray *message) {
         
         [self.dialogsArray removeAllObjects];
         
         [self.dialogsArray addObjectsFromArray:message];
         
         [self.tableView reloadData];
         
         [self.refreshControl endRefreshing];

         
     }
     
     onFailure:^(NSError *error, NSInteger statusCode) {
         
         NSLog(@"error = %@, code = %d", [error localizedDescription], statusCode);
         
         [self.refreshControl endRefreshing];
     }];


}



#pragma mark - API

-(void)getDialogFromServer:(NSInteger)offset{   // получаем список сообщений.
    
    [[AZServerManager sharedManager]
     getDialogs:offset
     Count:50
     unread:0
     onSuccess:^(NSArray *message) {
         
         self.count = 0;
         
         [self.dialogsArray addObjectsFromArray:message];
         
         [self.tableView reloadData];
         
     }
     
     onFailure:^(NSError *error, NSInteger statusCode) {
         
         NSLog(@"error = %@, code = %d", [error localizedDescription], statusCode);

     }];
    
    }

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dialogsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    AZDialogCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

    }
    
    AZDialog* dialog = [self.dialogsArray objectAtIndex:indexPath.row];
    

    
    
    
    __weak AZDialogCell* weakCell = cell;

    [[AZServerManager sharedManager]
     getUser:dialog.userID
     onSuccess:^(AZUser *user) {
         
         
         NSURLRequest* request = [NSURLRequest requestWithURL:user.imageURL];
         
         cell.userImage.image = nil;
         
         [cell.imageView
          setImageWithURLRequest:request
          placeholderImage:nil
          
          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
              
              weakCell.userImage.image = image;
              
              weakCell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
              
              [weakCell layoutSubviews];
              
          }
          
          failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
              
          }];
         
     }
     
        onFailure:^(NSError *error, NSInteger statusCode) {
         weakCell.textLabel.text = [NSString stringWithFormat:@"ERROR"];
         
     }];
    
        NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
    
        [dateFormater setDateFormat:@"dd MMMM yyyy, HH:mm"];
    
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dialog.date intValue]];
    
        cell.dateLabel.text = [NSString stringWithFormat:@"%@", [dateFormater stringFromDate:date]];
    
        cell.messageLabel.text =[NSString stringWithFormat:@"%@", dialog.body];
    
    return cell;
}

#pragma marl - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPathХ {
        
    self.count = 1;
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    if (self.count == 1) {
        
        [self getDialogFromServer:[self.dialogsArray count]];
        self.count = 0;
    }

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AZMessagesViewController* messagesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageControler"];
    
    AZUser* user = [self.dialogsArray objectAtIndex:indexPath.row];
    
    messagesVC.userID = [user.userID intValue];
    
    [self.navigationController pushViewController:messagesVC animated:YES];
    
}



- (IBAction)showMenu:(id)sender {
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}
@end
