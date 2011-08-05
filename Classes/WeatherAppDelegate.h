//
//  WeatherAppDelegate.h
//  Weather
//
//  Created by iD Student Account on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherViewController;

@interface WeatherAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    WeatherViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet WeatherViewController *viewController;

@end

