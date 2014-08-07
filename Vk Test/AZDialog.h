//
//  AZDialog.h
//  Vk Test
//
//  Created by Artem on 02.08.14.
//  Copyright (c) 2014 eslei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZDialog : NSObject

@property (strong, nonatomic) NSString* body;
@property (strong, nonatomic) NSString* date;
@property (strong, nonatomic) NSString* dialogID;
@property (strong, nonatomic) NSString* outt;
@property (strong, nonatomic) NSString* readState;
@property (strong, nonatomic) NSString* userID;

- (id)initWithServerResponse:(NSDictionary*) responseObject;

@end
