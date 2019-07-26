#include "XXXRootListController.h"
#include <spawn.h>
#include <signal.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#import <MessageUI/MessageUI.h>

@interface ViewController : UIViewController <MFMailComposeViewControllerDelegate>
@end

@implementation XXXRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

-(void)respring {
	AudioServicesPlaySystemSound(1519);
	pid_t pid;
	int status;
	const char *argv[] = {"killall", "SpringBoard", NULL};
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)argv, NULL);
	waitpid(pid, &status, WEXITED);
}

-(void)mailAction {
		AudioServicesPlaySystemSound(1519);
    NSString *messageBody = @"Message :";
    NSArray *toRecipents = [NSArray arrayWithObject:@"maybeme.tweak@gmail.com"];
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    if ([MFMailComposeViewController canSendMail]) {
        picker.mailComposeDelegate = (id)self;
        [picker setSubject:@"Support Hey!UrFlash"];
        [picker setMessageBody:messageBody isHTML:NO];
        [picker setToRecipients:toRecipents];
        [self presentViewController:picker animated:YES completion:NULL];
    }
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)twitterAction {
		AudioServicesPlaySystemSound(1519);
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"https://twitter.com/valentin6Plus"];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened twitter url");
        }
    }];
}

@end
