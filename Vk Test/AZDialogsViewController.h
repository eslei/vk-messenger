//
//  AZDialogsViewController.h
//  Vk Test
//
//  Created by Artem on 02.08.14.
//  Copyright (c) 2014 eslei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AZDialogsViewController : UITableViewController
<
UITableViewDataSource,
UITableViewDelegate
>

- (IBAction)showMenu:(id)sender;

-(void)refreshDialogs;

@end
