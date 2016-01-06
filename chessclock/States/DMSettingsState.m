//
//  DMSettingsState.m
//  chessclock
//
//  Created by Dan on 2015-12-20.
//
//

#import "DMStates.h"

#import "DMGame.h"
#import "DMGameView.h"

@implementation DMSettingsState

- (void)willExitWithNextState:(GKState *)nextState
{
    if ([nextState isKindOfClass:[DMNewGameState class]]) {
        [self.game.interface interfaceShouldTransitionFromSettingsToNewGame:self];
    }
}

@end