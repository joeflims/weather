//
//  WeatherViewController.h
//  Weather
//
//  Created by iD Student Account on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WeatherViewController : UIViewController {
	IBOutlet UITextField * textField;
	IBOutlet UIImageView * weatherStatus;
	IBOutlet UILabel * currentTemp;
	IBOutlet UILabel * conditions;
	IBOutlet UILabel * windSpeed;
	IBOutlet UILabel * windDirec;
	IBOutlet UILabel * place;
	IBOutlet UILabel * humidity;
	IBOutlet UILabel * high;
	IBOutlet UILabel * low;
	IBOutlet UIButton * tomorrow;
	IBOutlet UIButton * today;
	CGFloat animatedDistance;
	IBOutlet UISegmentedControl *tempControl;
	NSString * tempF;
	NSString * tempC;
	NSString * HighF;
	NSString * HighC;
	NSString * LowF;
	NSString * LowC;
	NSString * WindM;
	NSString * WindK;
	

}

-(void)getWeatherData: (NSString *) zipCode;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

- (void)textFieldDidBeginEditing:(UITextField *)textF;

- (void)textFieldDidEndEditing:(UITextField *)textFi;

-(IBAction)toggleTemp;

-(IBAction)onButtonPress: (NSString *) zipCode;

-(IBAction)onOtherButtonPress: (NSString *) zipCode;

@property (retain) NSString * tempF;
@property (retain) NSString * tempC;
@property (retain) NSString * HighF;
@property (retain) NSString * HighC;
@property (retain) NSString * LowF;
@property (retain) NSString * LowC;
@property (retain) NSString * WindM;
@property (retain) NSString * WindK;



@end

