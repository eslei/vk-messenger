//
//  AZMessage.m
//  Vk Test
//
//  Created by Artem on 25.07.14.
//  Copyright (c) 2014 eslei. All rights reserved.
//

#import "AZMessage.h"

@implementation AZMessage



- (id)initWithServerResponse:(NSDictionary*) responseObject

{
    
    self = [super init];
    
    if (self) {
        
        self.MessageID = [responseObject objectForKey:@"id"];
        
        self.userID = [responseObject objectForKey:@"user_id"];
        
        self.from_id = [responseObject objectForKey:@"from_id"];

        self.body = [responseObject objectForKey:@"body"];
        
        self.date = [responseObject objectForKey:@"date"];
    
    }
    
    return self;
}

@end
