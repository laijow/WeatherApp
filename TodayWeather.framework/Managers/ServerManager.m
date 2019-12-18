//
//  ServerManager.m
//  weatherApp
//
//  Created by User on 17.12.2019.
//  Copyright © 2019 Yem Anatoly. All rights reserved.
//

#import "ServerManager.h"

#define API_URL_BASE @"https://www.metaweather.com/api/location/"

@interface ServerManager()

@property (strong, nonatomic) NSURLSession * session;

@end

@implementation ServerManager

+ (ServerManager *)sharedManager {
    
    static ServerManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    
    return manager;
    
}

- (void)startRequestWithMethod:(NSString*)method blockResult:(nonnull void (^)(id , NSError *))blockResult {
    
    NSString * stringUrl = [NSString stringWithFormat:@"%@%@",API_URL_BASE, method];
    NSString * characterStringUrl = [stringUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:characterStringUrl];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];

    [urlRequest setHTTPMethod:@"GET"];

    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData     *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200) {
            NSError *parseError = nil;
            id jsonResult = [NSJSONSerialization JSONObjectWithData:data options:0   error:&parseError];
            NSLog(@"The response is - %@",jsonResult);
            
            blockResult(jsonResult, nil);
        } else {
            NSLog(@"Error");
            blockResult(nil, error);
        }
    }];
    [dataTask resume];
    
}

@end
