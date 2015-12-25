//
//  DMPausedState.m
//  chessclock
//
//  Created by Dan on 2015-12-20.
//
//

#import "DMStates.h"

@implementation DMPausedState

- (void)didEnterWithPreviousState:(GKState *)previousState
{

//    if (self.game.state == DMWhiteTurn) {
//        self.game.state = DMWhitePaused;
//        [self.white pause];
//

//
//        [self updateInterfaceWithChanges:^{
//            [self disableWhiteButton];
//
//            if (self.whitePlayerHasEndedFirstTurn == NO) {
//                [self hideStartGameLabel];
//            }
//
//            [self.view layoutIfNeeded];
//        }];
//    }
//    else if (self.game.state == DMBlackTurn) {
//        self.game.state = DMBlackPaused;
//        [self.black pause];
//
//
//        [self updateInterfaceWithChanges:^{
//            [self disableBlackButton];
//
//            [self.view layoutIfNeeded];
//        }];
//    }

    [self.gameView selectPauseButton];
    [self.gameView enableResetButton];

    if ([previousState isKindOfClass:[DMWhiteTurnState class]]) {
        [self.gameView disableWhiteButton];
    }
    else if ([previousState isKindOfClass:[DMBlackTurnState class]]) {
        [self.gameView disableBlackButton];
    }
    else if ([previousState isKindOfClass:[DMConfirmResetState class]]) {
        [self.gameView hideConfirmResetArea];
    }
    else if ([previousState isKindOfClass:[DMLoadingState class]]) {
    }
}

@end