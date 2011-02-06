//
//  GameKitHelper+Additions.h
//  Removr
//
//  Created by Mike Cohen on 2/5/11.
//  Copyright 2011 MC Development. All rights reserved.
//

#import "GameKitHelper.h"

@protocol GKAdditions

-(void) onAchievementDescriptionsLoaded:(NSDictionary*)achievementDescriptions;

@end

@interface GameKitHelper (Additions)

-(void) loadAchievementDescriptions;

- (GKAchievementDescription*)getAchievementDescription:(NSString*)ident;

@end
