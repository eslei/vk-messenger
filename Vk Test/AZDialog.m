//
//  AZDialog.m
//  Vk Test
//
//  Created by Artem on 02.08.14.
//  Copyright (c) 2014 eslei. All rights reserved.
//

#import "AZDialog.h"

@implementation AZDialog


- (id)initWithServerResponse:(NSDictionary*) responseObject

{
    
    self = [super init];
    
    if (self) {
        
        self.body = [responseObject objectForKey:@"body"];
        
        self.date = [responseObject objectForKey:@"date"];
        
        self.dialogID = [responseObject objectForKey:@"id"];
        
        self.outt = [responseObject objectForKey:@"out"];
        
        self.readState = [responseObject objectForKey:@"read_state"];

        self.userID = [responseObject objectForKey:@"user_id"];
        
    }
    
    return self;
}

@end
