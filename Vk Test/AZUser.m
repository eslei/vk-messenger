//
//  AZUser.m
//  Vk Test
//
//  Created by Artem on 23.07.14.
//  Copyright (c) 2014 eslei. All rights reserved.
//

#import "AZUser.h"

@implementation AZUser


- (id) initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super init];
    if (self) {
        
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName = [responseObject objectForKey:@"last_name"];
        self.userID = [responseObject objectForKey:@"user_id"];
        
        NSString* urlString = [responseObject objectForKey:@"photo_50"];
        NSString* bigImageURL = [responseObject objectForKey:@"photo_200"];

        
        if (urlString) {
            self.imageURL = [NSURL URLWithString:urlString];
        }
        
        if (bigImageURL) {
            self.bigImageURL = [NSURL URLWithString:bigImageURL];
        }
    }
    return self;
}


@end
