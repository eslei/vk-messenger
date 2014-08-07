//
//  AZServerManager.h
//  Vk Test
//
//  Created by Artem on 16.07.14.
//  Copyright (c) 2014 eslei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AZMessage.h"
#import "AFNetworking.h"
#import "AZUser.h"
#import "AZLoginViewController.h"
#import "AZAccessToken.h"
#import "AZViewController.h"
#import "AZMessagesViewController.h"
#import "AZDialog.h"


@class AZUser;


@interface AZServerManager : NSObject 

@property(strong, nonatomic) AZUser* currentUser;
@property(strong, nonatomic) NSMutableArray* messagesArray;
@property(strong, nonatomic) NSString* autorizedUserID;
@property(strong, nonatomic) AZAccessToken* accessToken;






+ (AZServerManager*)sharedManager;


- (void)authoriseUser:(void(^)(AZUser* user))completion;

- (void)getUser:(NSString*)userID
      onSuccess:(void(^)(AZUser* user)) success
      onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getFriendsWithOffset:(NSInteger)offset
                        count:(NSInteger)count
                    onSuccess:(void(^)(NSArray* friends)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void)getMessageHistoryWithOffset:(NSInteger)offset
             Count:(NSInteger)count
            userID:(NSInteger)userID
         onSuccess:(void(^)(NSArray* message)) success
         onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;





- (void)getDialogs:(NSInteger)offset
             Count:(NSInteger)count
            unread:(NSInteger)unread
         onSuccess:(void(^)(NSArray* message)) success
         onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;





- (void)sendMessage:(NSInteger)userID
            message:(NSString*)message
          onSuccess:(void(^)(NSArray* message)) success
          onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void)logOut;



@end
