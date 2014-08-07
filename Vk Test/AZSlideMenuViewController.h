//
//  AZSlideMenuViewController.h
//  Vk Test
//
//  Created by Artem on 01.08.14.
//  Copyright (c) 2014 eslei. All rights reserved.
//



@interface AZSlideMenuViewController : UIViewController <UIWebViewDelegate>


@property (strong, nonatomic) IBOutlet UIImageView *avaView;
@property (strong, nonatomic) IBOutlet UILabel *labelName;



- (IBAction)showFriends:(id)sender;

- (IBAction)showMessages:(id)sender;

- (IBAction)outLog:(id)sender;




@end

