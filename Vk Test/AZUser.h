//
//  AZUser.h
//  Vk Test
//
//  Created by Artem on 23.07.14.
//  Copyright (c) 2014 eslei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZUser : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSURL* imageURL;
@property (strong, nonatomic) NSURL* bigImageURL;

@property (strong, nonatomic) NSString* userID;


- (id) initWithServerResponse:(NSDictionary*) responseObject;

@end
