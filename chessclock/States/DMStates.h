//
//  DMStates.m
//  chessclock
//
//  Created by Dan on 2015-12-20.
//
//

#import "DMState.h"

@interface DMLoadingState : DMState
@end

@interface DMNewGameState : DMState
@end

@interface DMSettingsState : DMState
@end

@interface DMPausedState : DMState
@end

@interface DMConfirmResetState : DMState
@end

@interface DMTurnState : DMState
@end

@interface DMWhiteTurnState : DMTurnState
@end

@interface DMBlackTurnState : DMTurnState
@end

@interface DMLostState : DMState
@end

@interface DMBlackLostState : DMLostState
@end

@interface DMWhiteLostState : DMLostState
@end
