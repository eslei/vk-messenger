//
//  AZNavigationController.m
//  Vk Test
//
//  Created by Artem on 02.08.14.
//  Copyright (c) 2014 eslei. All rights reserved.
//

#import "AZNavigationController.h"
#import "REFrostedViewController.h"

@interface AZNavigationController ()

@end

@implementation AZNavigationController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
     [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
	// Do any additional setup after loading the view.
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController panGestureRecognized:sender];
}


@end
