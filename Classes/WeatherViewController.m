//
//  WeatherViewController.m
//  Weather
//
//  Created by iD Student Account on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WeatherViewController.h"
#import "Seriously.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@implementation WeatherViewController

@synthesize tempF;
@synthesize tempC;
@synthesize HighF;
@synthesize HighC;
@synthesize LowF;
@synthesize LowC;
@synthesize WindM;
@synthesize WindK;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
		[super viewDidLoad];
		[self getWeatherData:@"08534"];
}


-(void)getWeatherData: (NSString *) zipCode {
	NSString *url = [NSString stringWithFormat:@"http://free.worldweatheronline.com/feed/weather.ashx?q=%@&format=json&num_of_days=2&key=a2a8021c84202616110308", zipCode];
[Seriously get:url handler:^(id body,  NSHTTPURLResponse *response, NSError *error) {
	NSDictionary * current = [[[body objectForKey:@"data"] objectForKey:@"current_condition"] objectAtIndex: 0];
	NSDictionary * highlow = [[[body objectForKey:@"data"]objectForKey:@"weather"]objectAtIndex:0];
	NSString *weatherURL = [[[current objectForKey:@"weatherIconUrl"] objectAtIndex:0] objectForKey:@"value"];
	NSDictionary * condition = [[current objectForKey:@"weatherDesc"] objectAtIndex:0];
	
	self.tempF= [current objectForKey:@"temp_F"];
	self.tempC= [current objectForKey:@"temp_C"];
	self.HighF= [highlow objectForKey:@"tempMaxF"];
	self.HighC= [highlow objectForKey:@"tempMaxC"];
	self.LowF = [highlow objectForKey:@"tempMinF"];
	self.LowC = [highlow objectForKey:@"tempMinC"];
	self.WindM = [current objectForKey: @"windspeedMiles"];
	self.WindK = [current objectForKey:@"windspeedKmph"];
	windDirec.text = [current objectForKey: @"winddir16Point"];
	humidity.text = [[current objectForKey: @"humidity"] stringByAppendingString:@"%"];
	conditions.text = [condition  objectForKey: @"value"];
	NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: weatherURL]];
	weatherStatus.image = [UIImage imageWithData: imageData];
	[self toggleTemp];		
	}];
}

-(IBAction)toggleTemp {
	switch (tempControl.selectedSegmentIndex) {
		case 0:
			currentTemp.text = [self.tempF stringByAppendingString:@"°F"];
			high.text = [self.HighF stringByAppendingString:@"°F"];
			low.text = [self.LowF stringByAppendingString:@"°F"];
			windSpeed.text = [self.WindM stringByAppendingString:@" mph"] ;
			break;
		case 1:
			currentTemp.text = [self.tempC stringByAppendingString:@"°C"] ;
			high.text = [self.HighC stringByAppendingString:@"°C"];
			low.text = [self.LowC stringByAppendingString:@"°C"];
			windSpeed.text = [self.WindK stringByAppendingString:@" kmph"];
			break;
		default:
			break;
	}
}

	
-(IBAction)onButtonPress: (id) sender {
	NSString *url = [NSString stringWithFormat:@"http://free.worldweatheronline.com/feed/weather.ashx?q=%@&format=json&num_of_days=2&key=a2a8021c84202616110308", textField.text];
	[Seriously get:url handler:^(id body,  NSHTTPURLResponse *response, NSError *error) {
				
		NSDictionary * highlow = [[[body objectForKey:@"data"] objectForKey:@"weather"]objectAtIndex:1];
		NSString *weatherURL = [[[highlow  objectForKey:@"weatherIconUrl"] objectAtIndex:0] objectForKey:@"value"];
  	NSDictionary * condition = [highlow objectForKey:@"weatherDesc"];
		
		self.tempF = @"";
		self.tempC = @"";
		self.HighF= [highlow objectForKey:@"tempMaxF"];
		self.HighC= [highlow objectForKey:@"tempMaxC"];
		self.LowF = [highlow objectForKey:@"tempMinF"];
		self.LowC = [highlow objectForKey:@"tempMinC"];
		self.WindM = [highlow objectForKey: @"windspeedMiles"];
		self.WindK = [highlow objectForKey:@"windspeedKmph"];
  	windDirec.text = [highlow objectForKey: @"winddir16Point"];
		humidity.text = @"Data not available";
		conditions.text = [[condition objectAtIndex:0] objectForKey: @"value"];
		NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: weatherURL]];
		weatherStatus.image = [UIImage imageWithData: imageData];
		[self toggleTemp];		
	}];
	
}

-(IBAction)onOtherButtonPress: (id) sender {
	[self getWeatherData: textField.text];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)textFieldShouldReturn:(UITextField *)inTextField{
			NSString *input = [[inTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]lowercaseString];
			[self getWeatherData: input];
			[inTextField resignFirstResponder];
			return YES;
}
			
			
			
	- (void)textFieldDidBeginEditing:(UITextField *)textF {
		CGRect textFieldRect = [self.view.window convertRect:textF.bounds fromView:textF];
		CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
		CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
		CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
		CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
		CGFloat heightFraction = numerator / denominator;
		if (heightFraction < 0.0)
		{
			heightFraction = 0.0;
		}
		else if (heightFraction > 1.0)
		{	
			heightFraction = 1.0;
		}
		UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
		if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
		{
			animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
		}
		else
		{
			animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
		}
		CGRect viewFrame = self.view.frame;
		viewFrame.origin.y -= animatedDistance;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
		
		[self.view setFrame:viewFrame];
		
		[UIView commitAnimations];
	}
	
	- (void)textFieldDidEndEditing:(UITextField *)textFi {
		CGRect viewFrame = self.view.frame;
		viewFrame.origin.y += animatedDistance;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
		
		[self.view setFrame:viewFrame];
		
		[UIView commitAnimations];
	}
	
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
