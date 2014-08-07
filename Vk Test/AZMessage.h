//
//  AZMessage.h
//  Vk Test
//
//  Created by Artem on 25.07.14.
//  Copyright (c) 2014 eslei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZMessage : NSObject

@property (strong, nonatomic) NSString* MessageID;


@property (strong, nonatomic) NSString* userID;
@property (strong, nonatomic) NSString* from_id;
@property (strong, nonatomic) NSString* body;
@property (strong, nonatomic) NSString* date;

- (id)initWithServerResponse:(NSDictionary*) responseObject;



@end
