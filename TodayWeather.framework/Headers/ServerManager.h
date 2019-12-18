//
//  ServerManager.h
//  weatherApp
//
//  Created by User on 17.12.2019.
//  Copyright © 2019 Yem Anatoly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ServerManager : NSObject

+ (ServerManager*)sharedManager;

- (void)startRequestWithMethod:(NSString*)method
                   blockResult:(void(^)(id jsonResult, NSError * error)) blockResult;

@end

NS_ASSUME_NONNULL_END
