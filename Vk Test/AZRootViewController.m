//
//  AZMenuViewController.m
//  Vk Test
//
//  Created by Artem on 01.08.14.
//  Copyright (c) 2014 eslei. All rights reserved.
//

#import "AZRootViewController.h"
#import "AZServerManager.h"
#import "AZUser.h"

@interface AZRootViewController ()

@end

@implementation AZRootViewController




-(void)awakeFromNib{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
}

@end
