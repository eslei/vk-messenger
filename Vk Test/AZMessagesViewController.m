//
//  AZMessagesViewController.m
//  Vk Test
//
//  Created by Artem on 24.07.14.
//  Copyright (c) 2014 eslei. All rights reserved.
//

#import "AZMessagesViewController.h"
#import "AZServerManager.h"
#import "AZUser.h"
#import "AZViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"


@interface AZMessagesViewController ()

@property(strong, nonatomic) NSMutableArray* messagesArray;
@property(strong, nonatomic) AZMessage* message;
@property(strong, nonatomic) NSString* userName;
@property(assign, nonatomic) NSInteger count;
@property(strong, nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic, assign) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation AZMessagesViewController

static NSString* selectCellUserID;
static NSInteger messagesInReqest = 50;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messagesArray = [NSMutableArray array];
    
    [self getMessagesFromServer:self.userID];
    //self.messageField.delegate = self;
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshMeesage) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void) viewWillDisappear:(BOOL)paramAnimated{
    [super viewWillDisappear:paramAnimated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)sendMessageButton:(id)sender {
    
    [[AZServerManager sharedManager]
     sendMessage:self.userID
     message:[self.messageField text]
     onSuccess:^(NSArray *message) {
         [self getMessagesFromServer:self.userID];
         
     }
     
     onFailure:^(NSError *error, NSInteger statusCode) {
         
         NSLog(@"error = %@, code = %d", [error localizedDescription], statusCode);

     }];
    
    self.messageField.text = nil;
    
}



- (CGFloat) heightForText:(NSString*) text {
    
    CGFloat offset = 5.0;
    
    UIFont* font = [UIFont systemFontOfSize:14.f];
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0.5;
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentCenter];
    
    NSDictionary* attributes =
    [NSDictionary dictionaryWithObjectsAndKeys:
     font, NSFontAttributeName,
     paragraph, NSParagraphStyleAttributeName,
     shadow, NSShadowAttributeName, nil];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(320 - 2 * offset, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    
    return CGRectGetHeight(rect) + 2 * offset;
}



#pragma mark API


-(void)refreshMeesage {
    
    [[AZServerManager sharedManager]
    
getMessageHistoryWithOffset:0
    
Count:MAX(messagesInReqest, [self.messagesArray count])
userID:[selectCellUserID intValue]
onSuccess:^(NSArray* message) {

    [self.messagesArray removeAllObjects];
    
    [self.messagesArray addObjectsFromArray:message];
    
    [self.tableView reloadData];
    
    [self.refreshControl endRefreshing];
    
}
onFailure:^(NSError *error, NSInteger statusCode) {
    NSLog(@"error = %@, code = %d", [error localizedDescription], statusCode);
    [self.refreshControl endRefreshing];


    
}];
    
}


-(void)getMessagesFromServer:(NSInteger)userID{   // получаем список сообщений.
    
    [[AZServerManager sharedManager]
     
     getMessageHistoryWithOffset:[self.messagesArray count]
     
     Count:messagesInReqest
     userID:userID
     onSuccess:^(NSArray* message) {
         self.count = 0;

         selectCellUserID = [NSString stringWithFormat:@"%d", userID];
         
         [self.messagesArray addObjectsFromArray:message];
         
           [self.tableView reloadData];

         
             }
     onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@, code = %d", [error localizedDescription], statusCode);
         
     }];
    }


# pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.messagesArray count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row == 1) {
        
    AZMessage *message = [self.messagesArray objectAtIndex:indexPath.section];
        
    self.message = message;
        
    NSString* from_id = [NSString stringWithFormat:@"%@", message.from_id];
    
     __weak UITableViewCell* weakCell = cell;
    
    [[AZServerManager sharedManager]
     getUser:from_id
     onSuccess:^(AZUser *user) {
         
         weakCell.backgroundColor = [UIColor whiteColor];
         
         
         weakCell.textLabel.text = [NSString stringWithFormat:@"%@",message.body];
         cell.imageView.image = nil;
         
       //  NSLog(@"user_id: %@ from_id: %@  name: %@  body: %@", message.userID, message.from_id, userName, message.body);
         [weakCell layoutSubviews];

     }
     
     onFailure:^(NSError *error, NSInteger statusCode) {
         weakCell.textLabel.text = [NSString stringWithFormat:@"ERROR"];

     }];
    }
    
    if (indexPath.row == 0) {
        self.message = [self.messagesArray objectAtIndex:indexPath.section];
        
        NSString* from_id = [NSString stringWithFormat:@"%@", self.message.from_id];
        
        
        
        __weak UITableViewCell* weakCell = cell;
        
        [[AZServerManager sharedManager]
         getUser:from_id
         onSuccess:^(AZUser *user) {
             
             weakCell.backgroundColor = [UIColor lightGrayColor];
             
             NSURLRequest* request = [NSURLRequest requestWithURL:user.imageURL];
             
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
             
             weakCell.backgroundColor = [UIColor clearColor];
             
             
              AZMessage *message = [self.messagesArray objectAtIndex:indexPath.section];
              
              NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
              
              [dateFormater setDateFormat:@"MM MMMM yyyy, HH:mm"];
              
              NSDate *date = [NSDate dateWithTimeIntervalSince1970:[message.date intValue]];
             
             weakCell.textLabel.text = [NSString stringWithFormat:@"%@   %@", user.firstName, [dateFormater stringFromDate:date]];
             
         }
         
         onFailure:^(NSError *error, NSInteger statusCode) {
             weakCell.textLabel.text = [NSString stringWithFormat:@"ERROR"];
             
         }];
    
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPathХ {
    
    NSLog(@"willDisplayCell");

    self.count = 1;

}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    NSLog(@"didEndDisplayingCell");

    if (self.count == 1) {
        
        [self getMessagesFromServer:self.userID];
        self.count = 0;


    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return self.userName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        
        AZMessage *message = [self.messagesArray objectAtIndex:indexPath.section];
        
        return [self heightForText:message.body];
    }else{
    return tableView.rowHeight;
}
}

#pragma mark - UITextViewDelegate


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////

- (void)_performCommentViewAnimationWithNotification:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    CGFloat animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardRect = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            self.bottomConstraint.constant = keyboardRect.size.height;
        }
        else {
            self.bottomConstraint.constant = [self _bottomConstraintForPadWithKeyboardRect:keyboardRect];
        }
    }
    
    [self.view setNeedsUpdateConstraints];
    
    __weak AZMessagesViewController *weakSelf = self;
    id animationBlock = ^{
        [weakSelf.view layoutIfNeeded];
    };
    
    BOOL iOS7 = floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1;
    
    if (iOS7) {
        UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        
        [UIView animateWithDuration:animationDuration
                              delay:0.0
                            options:(animationCurve << 16)
                         animations:animationBlock
                         completion:nil];
    }
    else {
        [UIView animateWithDuration:animationDuration
                         animations:animationBlock];
    }
}

- (CGFloat)_bottomConstraintForPadWithKeyboardRect:(CGRect)keyboardRect {
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        return keyboardRect.size.width;
    }
    return keyboardRect.size.height;
}

#pragma mark — Keyboard Methods

- (void)_hideKeyboard {
    [self.messageField resignFirstResponder];
    [self.messageField resignFirstResponder];
    
    [self.view endEditing:YES];
}

- (void)_keyboardWillShow:(NSNotification *)notification {
    [self.messageField becomeFirstResponder];
    
    [self _performCommentViewAnimationWithNotification:notification];
}

- (void)_keyboardWillHide:(NSNotification *)notification {
    self.bottomConstraint.constant = 0;
    
    [self _performCommentViewAnimationWithNotification:notification];
}
@end
