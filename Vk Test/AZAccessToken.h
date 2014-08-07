//
//  AZAccessToken.h
//  Vk Test
//
//  Created by Artem on 23.07.14.
//  Copyright (c) 2014 eslei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZAccessToken : NSObject

@property (strong, nonatomic) NSString* token;
@property (strong, nonatomic) NSDate* expirationDate;
@property (strong, nonatomic) NSString* userID;

@end
