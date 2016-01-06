//
//  DMLostState.m
//  chessclock
//
//  Created by Dan on 2015-12-31.
//
//

#import "DMStates.h"

@import AudioToolbox;

#import "DMGame.h"
#import "DMGameView.h"

@implementation DMLostState

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    // Vibrate the device, if possible
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

@end
