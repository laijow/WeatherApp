//
//  WeatherManager.m
//  weatherApp
//
//  Created by User on 17.12.2019.
//  Copyright © 2019 Yem Anatoly. All rights reserved.
//

#import "WeatherManager.h"
#import "ServerManager.h"
#import "LocationModel.h"
#import "NSArrayExtension.h"
#import "NSDateExtension.h"

#define NOTHING_FOUND @"Nothing found"

typedef NS_ENUM (NSInteger, ModelType) {
    locationType,
    weatherType
};

@interface WeatherManager()

@property (nonatomic) NSArray<LocationModel*>* locations;

@end

@implementation WeatherManager {
    
    NSString * locationMethod;
    NSString * weatherMethod;
    
}

- (void)getLocationsWithString:(NSString *)string {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self startSearchLocation:string];
    });
    
}

- (void)currentWeatherWithLocation:(LocationModel*)location {
         
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self startSearchWeatherWithLocation:location];
    });
    
}

- (void)requestWithMethod:(NSString*)method
         andWithModelType:(ModelType)type
               endRequest:(void(^)(NSArray<RootModel*>* results))success {
    
    [[ServerManager sharedManager] startRequestWithMethod:method
                                              blockResult:^(id jsonResult, NSError * error) {
        id result;
        if(error != nil)
            result = error;
        else
            result = [self createMethodWithResponseDictionary:jsonResult
                                                   withMethod:method
                                             andWithModelType:type];
        
        if([result isKindOfClass:[NSError class]]) {
            [self errorWithDescription:error.localizedDescription];
        } else {
            success(result);
        }
    }];
    
}

- (void)startSearchLocation:(NSString *)location {
    
    locationMethod = [NSString stringWithFormat:@"search/?query=%@", location];
    
    [self requestWithMethod:locationMethod
           andWithModelType:locationType
                 endRequest:^(NSArray<RootModel *> *results) {
        self.locations = (NSArray<LocationModel*>*)results;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate locationsDidFound:self.locations];
        });
    }];
    
}

- (id)createMethodWithResponseDictionary:(id)data
                              withMethod:(NSString*)method
                        andWithModelType:(ModelType)type {
    
    NSMutableArray * tempArray = [NSMutableArray new];
    
    if(data != nil && [data isKindOfClass:[NSArray class]]) {
        if(type == locationType) {
            for(NSDictionary * dict in data) {
                LocationModel * location = [[LocationModel alloc] initWithDictionary:dict];
                [tempArray addObject:location];
            }
        } else {
            for(NSDictionary * dict in data) {
                WeatherModel * weather = [[WeatherModel alloc] initWithDictionary:dict];
                [tempArray addObject:weather];
            }
        }
    } else [self errorWithDescription:NOTHING_FOUND];
    return tempArray;
    
}

- (void)startSearchWeatherWithLocation:(LocationModel*)location{
    
    weatherMethod = [NSString stringWithFormat:@"%ld/%@", location.woeid, [NSDate todayDateString]];
    [self requestWithMethod:weatherMethod
           andWithModelType:weatherType
                 endRequest:^(NSArray<RootModel *> *results) {
        location.weathers = (NSArray<WeatherModel*>*)results;
        if([location.weathers isEmpty])
            [self errorWithDescription:NOTHING_FOUND];
        else
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate weatherDidFoundAtLocation:location];
            });
    }];
        
}

- (void)errorWithDescription:(NSString*)errorDescription {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate errorSearchWeatherWithErrorDescription:errorDescription];
    });
    
}

@end
