 //
//  AZServerManager.m
//  Vk Test
//
//  Created by Artem on 16.07.14.
//  Copyright (c) 2014 eslei. All rights reserved.
//

#import "AZServerManager.h"


@interface AZServerManager ()

@property(strong, nonatomic) AFHTTPRequestOperationManager* requestOperationManager;
@property (nonatomic, strong) NSURLConnection *connection;



@end



@implementation AZServerManager

+ (AZServerManager*) sharedManager {
    
    static AZServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AZServerManager alloc] init];
    });
    
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        NSURL* url = [NSURL URLWithString:@"https://api.vk.com/method/"];
        
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    }
    return self;
}

- (void)authoriseUser:(void(^)(AZUser* user))completion{
    
    AZLoginViewController* vc =
    [[AZLoginViewController alloc] initWithCompletionBlock:^(AZAccessToken *token) {
        
        self.accessToken = token;
        
        self.autorizedUserID = token.userID;
        
        if (token) {
            
            [self getUser:self.accessToken.userID
                onSuccess:^(AZUser *user) {
                    
                    self.currentUser = user;

                    
                    if (completion) {
                        completion(user);
                    }
                }
                onFailure:^(NSError *error, NSInteger statusCode) {
                    
                    
                    
                    
                    if (completion) {
                        completion(nil);
                    }
                }];
            
        } else if (completion) {
            completion(nil);
        }
        
    }];
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    UIViewController* mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    
    [mainVC presentViewController:nav
                         animated:YES
                       completion:nil];
}

- (void) getUser:(NSString*) userID
       onSuccess:(void(^)(AZUser* user)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
   // NSLog(@"userID = %@", userID);
    
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     userID,                            @"user_ids",
     @"photo_50,photo_200",        @"fields",
     @"nom",                            @"name_case", nil];
    
    [self.requestOperationManager
     GET:@"users.get"
     parameters:params
     
     
     
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"JSON: %@", responseObject);
         
         NSArray* dictsArray = [responseObject objectForKey:@"response"];
         
         if ([dictsArray count] > 0) {
             AZUser* user = [[AZUser alloc] initWithServerResponse:[dictsArray firstObject]];
             if (success) {
                 success(user);
             }
         } else {
             if (failure) {
                 failure(nil, operation.response.statusCode);
             }
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         
         if (failure) {
             failure(error, operation.response.statusCode);
         }
     }];
}


- (void) getFriendsWithOffset:(NSInteger) offset
                        count:(NSInteger) count
                    onSuccess:(void(^)(NSArray* friends)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     self.autorizedUserID,   @"user_id",
     @"name",       @"order",
     @(count),      @"count",
     @(offset),     @"offset",
     @"photo_50",   @"fields",
     @"nom",        @"name_case", nil];
    
    [self.requestOperationManager
     GET:@"friends.get"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
         
         NSLog(@"friendsJSON: %@", responseObject);
         
         NSArray* dictsArray = [responseObject objectForKey:@"response"];
         
         NSMutableArray* objectsArray = [NSMutableArray array];
         
         for (NSDictionary* dict in dictsArray) {
            
             AZUser* user = [[AZUser alloc] initWithServerResponse:dict];
         
             [objectsArray addObject:user];
         
         }
         
         if (success) {
            success(objectsArray);
         
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
         
         if (failure) {
             failure(error, operation.response.statusCode);
         
         }
         
     }];
    
}


- (void)getMessageHistoryWithOffset:(NSInteger)offset
                              Count:(NSInteger)count
                             userID:(NSInteger)userID
                          onSuccess:(void(^)(NSArray* message)) success
                          onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure{
    
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @(offset),                     @"offset",
     @(count),                      @"count",
     @(userID),                     @"user_id",
     @(0),                          @"chat_id",
     @(0),                          @"start_message_id",
     @(0),                          @"rev",
     @(5.23),                       @"v",
     self.accessToken.token,        @"access_token",nil];
    
    [self.requestOperationManager
     GET:@"messages.getHistory"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
         
         NSLog(@"getMessageHistoryWithOffsetJSON: %@", responseObject);
         
         NSDictionary* dicts = [responseObject objectForKey:@"response"];
         
         NSDictionary* dictsArray = [dicts objectForKey:@"items"];

         NSMutableArray* objectsArray = [NSMutableArray array];
         
         for (NSDictionary* dict in dictsArray) {
             
             AZMessage* message = [[AZMessage alloc] initWithServerResponse:dict];
             
             [objectsArray addObject:message];
         
             [self.messagesArray addObject:message];
             
         }
         
         if (success) {
             success(objectsArray);
             
         }

     }
     
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
         NSLog(@"Error: %@", error);

         if (failure) {
             failure(error, operation.response.statusCode);
         }
     }];
}


- (void)getDialogs:(NSInteger)offset
             Count:(NSInteger)count
            unread:(NSInteger)unread
         onSuccess:(void(^)(NSArray* message)) success
         onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure{
    
    NSLog(@"getDialogs");
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @(offset),                     @"offset",
     @(count),                      @"count",
     @(0),                          @"preview_length",
     @(unread),                     @"unread",
     @(0),                          @"start_message_id",
     @(5.23),                       @"v",
     self.accessToken.token,        @"access_token",nil];

    [self.requestOperationManager
     GET:@"messages.getDialogs"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
         
        NSLog(@"getDialogsJSON: %@", responseObject);
         
         NSDictionary* dicts = [responseObject objectForKey:@"response"];
         
         NSArray* dictsArray = [dicts objectForKey:@"items"];
         
         NSLog(@"%@", dictsArray);
         
         NSMutableArray* objectsArray = [NSMutableArray array];
         
         for (NSDictionary* dict in dictsArray) {
             
             NSDictionary* dictionary = [dict objectForKey:@"message"];
             
             
             AZDialog* dialog = [[AZDialog alloc] initWithServerResponse:dictionary];
             
             [objectsArray addObject:dialog];
             
             [self.messagesArray addObject:dialog];
             
         }
         
         if (success) {
             success(objectsArray);
             
         }
     }
     
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
         
         if (failure) {
             failure(error, operation.response.statusCode);
         }
     }];
}


- (void)sendMessage:(NSInteger)userID
            message:(NSString*)message
          onSuccess:(void(^)(NSArray* message)) success
          onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure{
    
   // NSLog(@"getMessageHistoryWithOffset");
    
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @(userID),                     @"user_id",
     @(0),                          @"domain",
     @(0),                          @"chat_id",
     @(0),                          @"user_ids",
     message,                       @"message",
     @(0),                          @"guid",
     @(0),                          @"long",
     @(0),                          @"attachment",
     @(0),                          @"forward_messages",
     @(5.23),                       @"v",
     self.accessToken.token,        @"access_token",nil];
    
    [self.requestOperationManager
            GET:@"messages.send"
     parameters:params
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
    //  NSLog(@"senfMessageJSON: %@", responseObject);

    }
     
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Error: %@", error);
                                  
            if (failure) {
                
                failure(error, operation.response.statusCode);
                
            }
    }];
}

- (void)logOut{
    
    self.accessToken = nil;
    
    
    
}



@end