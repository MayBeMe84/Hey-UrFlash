#import <AudioToolbox/AudioServices.h>
#include "activatorheaders/libactivator.h"

static UIWindow *window = nil;

NSTimer *viewTime;
NSMutableString *newMessage;
NSArray *devices;

@interface BCBatteryDeviceController {
	NSArray *_sortedDevices;
}
+ (id)sharedInstance;
@end

@interface BCBatteryDevice {
	long long _percentCharge;
	NSString *_name;
}
@end

@interface BatteryWidgetX : NSObject <LAListener> {
	UITextView *labelBattery;
}
-(void)tapanimation;
-(void)tapanimationSlow;
-(void)tap;
-(void)labelAppear;
@end

@implementation BatteryWidgetX

- (void)activator:(LAActivator *)activator
	 receiveEvent:(LAEvent *)event
  forListenerName:(NSString *)listenerName{

		BCBatteryDeviceController *bcb = [%c(BCBatteryDeviceController) sharedInstance];
		devices = MSHookIvar<NSArray *>(bcb, "_sortedDevices");

		newMessage = [[NSMutableString alloc] init];

		for (BCBatteryDevice *device in devices) {
			NSString *deviceName = MSHookIvar<NSString *>(device, "_name");

			long long deviceCharge = MSHookIvar<long long>(device, "_percentCharge");
			[newMessage appendString:[NSString stringWithFormat:@"• %@ : %lld%%\n", deviceName, deviceCharge]];
		}

    if (!window){
    AudioServicesPlaySystemSound(1520);
    window = [[UIWindow alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-160,270,320,270)];
    window.hidden = NO;
    window.windowLevel = UIWindowLevelStatusBar;
    window.layer.masksToBounds = YES;
    window.layer.cornerRadius = 15;
    window.alpha = 0;
    window.windowLevel = UIWindowLevelAlert;

    [UIView animateWithDuration:0.4 animations:^{
      window.alpha = 1;
    } completion:nil];

		[NSTimer scheduledTimerWithTimeInterval:0.2
																				 target:self
																			 selector:@selector(labelAppear)
																			 userInfo:nil
																				repeats:NO];

    viewTime = [NSTimer scheduledTimerWithTimeInterval:25
                                          target:self
                                        selector:@selector(tapanimationSlow)
                                        userInfo:nil
                                         repeats:NO];
    [viewTime retain];

    UIVisualEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *vView = [[UIVisualEffectView alloc]initWithEffect:blur];
    vView.frame = window.bounds;
    [window addSubview:vView];

    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapanimation)];
    [window addGestureRecognizer:gesture];

    }
}

-(void)labelAppear{

  UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-90,8,145,50)];
  label.text = @"Batteries";
  label.textColor = [UIColor whiteColor];
  label.alpha = 0;
  [label setFont:[UIFont systemFontOfSize:35]];
  [window addSubview: label];

	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.minimumLineHeight = 28.f;
	paragraphStyle.maximumLineHeight = 28.f;
	NSString *string = [[newMessage copy] autorelease];
	NSDictionary *attributtes = @{
	    NSParagraphStyleAttributeName : paragraphStyle,
	};
	labelBattery = [[UITextView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-140,85,230,160)];
  labelBattery.alpha = 0;
	labelBattery.selectable = NO;
	labelBattery.attributedText = [[NSAttributedString alloc] initWithString:string attributes:attributtes];
	labelBattery.backgroundColor = [UIColor clearColor];
	[labelBattery setTextColor:[UIColor whiteColor]];
  [labelBattery setFont:[UIFont systemFontOfSize:16]];
  [window addSubview: labelBattery];

  [UIView animateWithDuration:0.35 animations:^{
    labelBattery.alpha = 1;
    label.alpha = 1;
  } completion:nil];
}

-(void)tapanimation{
  AudioServicesPlaySystemSound(1520);
  [UIView animateWithDuration:0.35 animations:^{
    window.alpha = 0;
  } completion:nil];
  [NSTimer scheduledTimerWithTimeInterval:0.3501
                                       target:self
                                     selector:@selector(tap)
                                     userInfo:nil
                                      repeats:NO];
}

-(void)tapanimationSlow{
  [UIView animateWithDuration:1.5 animations:^{
    window.alpha = 0;
  } completion:nil];
  AudioServicesPlaySystemSound(1521);
  [NSTimer scheduledTimerWithTimeInterval:1.5001
                                       target:self
                                     selector:@selector(tap)
                                     userInfo:nil
                                      repeats:NO];
}

-(void)tap{
  window.hidden = YES;
  window = nil;
  [viewTime invalidate];
  viewTime = nil;
	[newMessage release];
	newMessage = nil;
	devices = @[];
}

@end

static BatteryWidgetX *batteryInstance;

%ctor{
	batteryInstance = [[BatteryWidgetX alloc] init];
	[[LAActivator sharedInstance] registerListener:batteryInstance
	                                       forName:@"BatteryWidgetX (Beta)"];
}
