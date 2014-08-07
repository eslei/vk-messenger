//
//  AZLoginViewController.m
//  Vk Test
//
//  Created by Artem on 23.07.14.
//  Copyright (c) 2014 eslei. All rights reserved.
//

#import "AZLoginViewController.h"
#import "AZAccessToken.h"
#import "AZServerManager.h"
@interface AZLoginViewController () <UIWebViewDelegate>

@property (copy, nonatomic) AZLoginCompletionBlock completionBlock;
@property (weak, nonatomic) UIWebView* webView;

@end

@implementation AZLoginViewController

- (id) initWithCompletionBlock:(AZLoginCompletionBlock) completionBlock {
    
    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view.
    
    CGRect r = self.view.bounds;
    
    r.origin = CGPointZero;
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:r];
    
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:webView];
    
    self.webView = webView;
    
    self.navigationItem.title = @"Login";
    
    NSString* urlString =
    @"https://oauth.vk.com/authorize?"
    "client_id=4472858&"
    "scope=12290&"
    "redirect_uri=https://oauth.vk.com/blank.html&"
    "display=mobile&"
    "v=5.23&"
    "response_type=token";
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    //  NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    
    webView.delegate = self;
    
    [webView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) dealloc {
    self.webView.delegate = nil;
}


#pragma mark - UIWebViewDelegete

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    //NSLog(@"request = %@",[[request URL] description]);
    
        if ([[[request URL] description] rangeOfString:@"access_token="].location != NSNotFound) {
        
        AZAccessToken* token = [[AZAccessToken alloc] init];
        
        NSString* query = [[request URL] description];
        
        NSArray* array = [query componentsSeparatedByString:@"#"];
        
        if ([array count] > 1) {
            query = [array lastObject];
        }
        
        NSArray* pairs = [query componentsSeparatedByString:@"&"];
        
        for (NSString* pair in pairs) {
            
            NSArray* values = [pair componentsSeparatedByString:@"="];
            
            if ([values count] == 2) {
                
                NSString* key = [values firstObject];
                
                if ([key isEqualToString:@"access_token"]) {
                    token.token = [values lastObject];
                } else if ([key isEqualToString:@"expires_in"]) {
                    
                    NSTimeInterval interval = [[values lastObject] doubleValue];
                    
                    token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                    
                } else if ([key isEqualToString:@"user_id"]) {
                    
                    token.userID = [values lastObject];
                }
            }
        }
        
        self.webView.delegate = nil;
        
        if (self.completionBlock) {
            self.completionBlock(token);
        }
        
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
        
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"");
}


@end
