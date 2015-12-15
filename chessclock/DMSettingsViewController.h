//
//  TimeSelectionControllerViewController.h
//  chessclock
//
//  Created by Dan McGinnis on 12-04-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMSettingsViewController;

@protocol DMSettingsViewControllerDelegate <NSObject>

/*
- (void)timeSelectionViewController:(DMSettingsViewController *)controller
                 didSetWhiteSeconds:(NSTimeInterval)whiteSeconds
                       blackSeconds:(NSTimeInterval)blackSeconds;
*/
@end

@interface DMSettingsViewController : UIViewController

@property (nonatomic, weak) id<DMSettingsViewControllerDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIButton *goButton;

- (IBAction)goButtonPressed:(id)sender;

@end
