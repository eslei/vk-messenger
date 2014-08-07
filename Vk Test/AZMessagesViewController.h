//
//  AZMessagesViewController.h
//  Vk Test
//
//  Created by Artem on 24.07.14.
//  Copyright (c) 2014 eslei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AZMessagesViewController : UIViewController
<
UITableViewDelegate,
UITableViewDataSource,
UITextViewDelegate
>

@property(assign, nonatomic) NSInteger userID;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextView *messageField;
@property (strong, nonatomic) IBOutlet UIView *messageView;




- (IBAction)sendMessageButton:(id)sender;
- (CGFloat) heightForText:(NSString*) text;

@end
