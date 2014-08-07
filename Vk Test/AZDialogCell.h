//
//  AZDialogCell.h
//  Vk Test
//
//  Created by Artem on 05.08.14.
//  Copyright (c) 2014 eslei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AZDialogCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *userImage;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;




@end
