//
//  WeatherManager.h
//  weatherApp
//
//  Created by User on 17.12.2019.
//  Copyright © 2019 Yem Anatoly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Models.h"

/**
 Search result
*/
@protocol WeatherManagerDelegate <NSObject>

- (void)locationsDidFound:(NSArray<LocationModel*>*)locations;

- (void)weatherDidFoundAtLocation:(LocationModel*)location;

- (void)errorSearchWeatherWithErrorDescription:(NSString*)errorDescription;

@end

@interface WeatherManager : NSObject

@property (weak, nonatomic) id<WeatherManagerDelegate> delegate;

/**
 Returns a list of locations
 */
- (void)getLocationsWithString:(NSString*)string;
 
/**
 Method for obtaining weather at a given location
 */
- (void)currentWeatherWithLocation:(LocationModel*)location;

@end
