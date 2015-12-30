//
//  DMGame.m
//  chessclock
//
//  Created by Dan McGinnis on 12-11-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@import GameplayKit;

#import "DMGame.h"

@interface DMGame ()

@property (nonatomic) GKStateMachine *stateMachine;

@end


@implementation DMGame

- (instancetype)init
{
    self = [super init];

    if (self) {
    }

    return self;
}

- (void)initStateMachine
{
    DMLoadingState * loadingState = [[DMLoadingState alloc] initWithGameView:self.gameView whiteClock:self.white blackClock:self.black];
    DMNewGameState * newGameState = [[DMNewGameState alloc] initWithGameView:self.gameView whiteClock:self.white blackClock:self.black];
    DMSettingsState * settingsState = [[DMSettingsState alloc] initWithGameView:self.gameView whiteClock:self.white blackClock:self.black];
    DMWhiteTurnState * whiteTurnState = [[DMWhiteTurnState alloc] initWithGameView:self.gameView whiteClock:self.white blackClock:self.black];
    DMWhiteLostState * whiteLostState = [[DMWhiteLostState alloc] initWithGameView:self.gameView whiteClock:self.white blackClock:self.black];
    DMBlackTurnState * blackTurnState = [[DMBlackTurnState alloc] initWithGameView:self.gameView whiteClock:self.white blackClock:self.black];
    DMBlackLostState * blackLostState = [[DMBlackLostState alloc] initWithGameView:self.gameView whiteClock:self.white blackClock:self.black];

    self.stateMachine = [[GKStateMachine alloc] initWithStates:@[
                                                                 loadingState,
                                                                 newGameState,
                                                                 settingsState,
                                                                 whiteTurnState,
                                                                 whiteLostState,
                                                                 blackTurnState,
                                                                 blackLostState
                                                                 ]];

}

- (DMState *)state
{

}

- (void)setState:(DMState *)state
{

}


@end
