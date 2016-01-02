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
    if ([previousState isKindOfClass:[DMLoadingState class]]) {
        [self.game.view showResetButton];
    } else if ([previousState isKindOfClass:[DMTurnState class]]) {
        [self.game.view hidePauseButton];
    } else if ([previousState isKindOfClass:[DMConfirmResetState class]]) {
        [self.game.view showResetButton];
    }

    [self.game.view enableResetButton];
    [self.game.view enableWhiteButton];
    [self.game.view enableBlackButton];

    // Vibrate the device, if possible
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

- (void)willExitWithNextState:(GKState *)nextState
{
    [self.game.view hideResetButton];
}

@end
