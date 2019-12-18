//
//  LocationModel.h
//  weatherApp
//
//  Created by User on 17.12.2019.
//  Copyright © 2019 Yem Anatoly. All rights reserved.
//

#import "RootModel.h"
#import "WeatherModel.h"

@interface LocationModel : RootModel

/**
 Weather in this location
 */
@property (strong, nonatomic) NSArray<WeatherModel*>* weathers;

/**
 City name
 */
@property (strong, nonatomic) NSString * city;

/**
 Where On Earth ID
 */
@property (assign, nonatomic) long woeid;

@end
