//
//  AZLoginViewController.h
//  Vk Test
//
//  Created by Artem on 23.07.14.
//  Copyright (c) 2014 eslei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"

@class AZAccessToken;

typedef void(^AZLoginCompletionBlock)(AZAccessToken* token);

@interface AZLoginViewController : UIViewController <UIWebViewDelegate>




- (id) initWithCompletionBlock:(AZLoginCompletionBlock) completionBlock;






@end
