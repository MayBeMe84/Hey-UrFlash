#import <AudioToolbox/AudioServices.h>

@interface SBUIFlashlightController
+(id)sharedInstance;
-(void)_setFlashlightLevel:(float)arg1;
@end

#define flashLevel [[%c(SBUIFlashlightController) sharedInstance] level]

int volume = 0;
int volume2 = 0;

NSTimer *viewTime;
NSTimer *viewTime2;

NSDictionary *bundleEnable = [[NSUserDefaults standardUserDefaults]
persistentDomainForName:@"com.maybeme.heyurflashpref"];

NSDictionary *bundleTime = [[NSUserDefaults standardUserDefaults]
persistentDomainForName:@"com.maybeme.heyurflashpref"];

NSDictionary *bundleHaptic = [[NSUserDefaults standardUserDefaults]
persistentDomainForName:@"com.maybeme.heyurflashpref"];

NSDictionary *bundleVolumeControle = [[NSUserDefaults standardUserDefaults]
persistentDomainForName:@"com.maybeme.heyurflashpref"];

NSDictionary *bundleBrightness = [[NSUserDefaults standardUserDefaults]
persistentDomainForName:@"com.maybeme.heyurflashpref"];

id isEnable = [bundleEnable valueForKey:@"isEnable"];
double secondTime = [[bundleTime valueForKey:@"setTime"] doubleValue];
id isHaptic = [bundleHaptic valueForKey:@"isHaptic"];
id isVolumeControle = [bundleVolumeControle valueForKey:@"isVolumeControle"];
double brutBrightness = [[bundleTime valueForKey:@"setBrightness"] doubleValue];

double setTime = secondTime * 60;
double setBrightness = brutBrightness * 0.1;

@interface VolumeControl
-(void)VarTimer;
-(void)flashOn;
@end

%hook VolumeControl

-(void)increaseVolume {
[self VarTimer];
volume2 = 1;
if(volume == 1 && volume2 == 1) {
  if(flashLevel == 0){
    if ([isVolumeControle isEqual:@1]) {
    [self flashOn];
    }
  }
}
else if(volume == 0 && volume2 == 1) {
%orig;
}
}

-(void)decreaseVolume {
[self VarTimer];
volume = 1;
if(volume2 == 1 && volume == 1) {
  if(flashLevel == 0){
    if ([isVolumeControle isEqual:@1]) {
    [self flashOn];
    }
  }
}
else if(volume == 1 && volume2 == 0) {
%orig;
}
}

%new
-(void)VarTimer{
  [NSTimer scheduledTimerWithTimeInterval:0.015
                                       target:self
                                     selector:@selector(SetVolumeVar)
                                     userInfo:nil
                                      repeats:NO];
}

%new
-(void)SetVolumeVar {
volume = 0;
volume2 = 0;
}

%new
-(void)flashOn{

if ([isEnable isEqual:@1]) {
  if ([isHaptic isEqual:@1]) {
AudioServicesPlaySystemSound(1519);
}
  [[%c(SBUIFlashlightController) sharedInstance] _setFlashlightLevel:setBrightness];
  viewTime = [NSTimer scheduledTimerWithTimeInterval:setTime
                                       target:self
                                     selector:@selector(flashOff)
                                     userInfo:nil
                                      repeats:NO];
  [viewTime retain];

  [NSTimer scheduledTimerWithTimeInterval:0.02
                                       target:self
                                     selector:@selector(offIsOn)
                                     userInfo:nil
                                      repeats:NO];
  }
}

%new
-(void)offIsOn{
if ([isEnable isEqual:@1]) {
  if (flashLevel == 0){
    [viewTime invalidate];
    viewTime = nil;
    [viewTime2 invalidate];
    viewTime2 = nil;
    if ([isHaptic isEqual:@1]) {
  AudioServicesPlaySystemSound(1521);
  }
}
}
}

%new
-(void)flashOff{
if ([isEnable isEqual:@1]) {
  if (flashLevel > 0){
    [viewTime invalidate];
    viewTime = nil;
    [viewTime2 invalidate];
    viewTime2 = nil;
    if ([isHaptic isEqual:@1]) {
  AudioServicesPlaySystemSound(1521);
  }
    [[%c(SBUIFlashlightController) sharedInstance] _setFlashlightLevel:0];
}
}
}

%end

%hook SBUIFlashlightController

-(void)_postLevelChangeNotification:(unsigned long long)arg1 {
  %orig;
if ([isEnable isEqual:@1]) {
  if(flashLevel > 0){
  viewTime2 = [NSTimer scheduledTimerWithTimeInterval:setTime
                                       target:self
                                     selector:@selector(flashOff2)
                                     userInfo:nil
                                      repeats:NO];
  [viewTime2 retain];
}
[NSTimer scheduledTimerWithTimeInterval:0.02
                                     target:self
                                   selector:@selector(offIsOn2)
                                   userInfo:nil
                                    repeats:NO];
}
}

%new
-(void)flashOff2{
if ([isEnable isEqual:@1]) {
  if (flashLevel > 0){
    [viewTime invalidate];
    viewTime = nil;
    [viewTime2 invalidate];
    viewTime2 = nil;
    if ([isHaptic isEqual:@1]) {
  AudioServicesPlaySystemSound(1521);
  }
    [[%c(SBUIFlashlightController) sharedInstance] _setFlashlightLevel:0];
}
}
}

%new
-(void)offIsOn2{
if ([isEnable isEqual:@1]) {
  if (flashLevel == 0){
    [viewTime invalidate];
    viewTime = nil;
    [viewTime2 invalidate];
    viewTime2 = nil;
    if ([isHaptic isEqual:@1]) {
  AudioServicesPlaySystemSound(1521);
  }
}
}
}
%end
