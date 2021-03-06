//
//  GameScreen.m
//  Blocks
//
//  Created by Mike Cohen on 4/17/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "GameLayer.h"
#import "ShapeSprite.h"
#import "GameManager.h"
#import "SimpleAudioEngine.h"
#import "LevelCompleteMsg.h"
#import "achievements.h"

@interface GameLayer (private)

- (void) addPauseButton;

@end

static BOOL BigMove(CGPoint p1, CGPoint p2)
{
#define BigMoveAmount   2
    if (ABS(p1.x - p2.x) > BigMoveAmount)
        return YES;
    if (ABS(p1.y - p2.y) > BigMoveAmount)
        return YES;
    return NO;
}

static void
eachShape(void *ptr, void* data)
{
	cpShape *shape = (cpShape*) ptr;
	CCSprite *sprite = shape->data;
	if( sprite ) {
		cpBody *body = shape->body;
		
		// TIP: cocos2d and chipmunk uses the same struct to store it's position
		// chipmunk uses: cpVect, and cocos2d uses CGPoint but in reality the are the same
		// since v0.7.1 you can mix them if you want.		
        
        // see  if piece moved
        if (BigMove([sprite position], body->p)) {
            ((GameLayer*)data).moved = YES;
        }
		[sprite setPosition: body->p];
		
		[sprite setRotation: (float) CC_RADIANS_TO_DEGREES( -body->a )];
	}
}

static void postStepExplode(cpSpace *space, cpShape *shape, void *data)
{
	ShapeSprite *sprite = shape->data;
    GameLayer *layer = (GameLayer*)data;
    CCParticleSystemQuad *explosion = [CCParticleSystemQuad particleWithFile: @"explosion.plist"];
    //layer.anExplosion = explosion;
    [layer.delegate playExplodeSound];
    explosion.position = sprite.position;
    explosion.autoRemoveOnFinish = YES;
    [layer addChild:explosion z:zOverlayLevel];
    [layer removeSprite:sprite force:YES];
}

static void postStepRemove(cpSpace *space, cpShape *shape, void *data)
{
//#ifndef NDEBUG
//    NSLog(@"remove shape");
//#endif
    [(GameLayer*)data removeShape:shape force: YES];
}

static int collisionBegin(cpArbiter *arb, struct cpSpace *space, void *data)
{
    //NSLog(@"collision handler");
    CP_ARBITER_GET_SHAPES(arb, a, b);
    cpSpaceAddPostStepCallback(space, (cpPostStepFunc)postStepRemove, b, data);
    return 0;
}

static int explosion(cpArbiter *arb, struct cpSpace *space, void *data)
{
    CP_ARBITER_GET_SHAPES(arb, a, b);
    ShapeSprite *sprite = b->data;
    if (sprite) {

        if (sprite.canRemove && (sprite.mustRemove || sprite.mustKeep)) {
            // see if we're moving in the same direction
            cpVect pos1 = a->body->p, pos2 = b->body->p;
            cpVect vel1 = a->body->v;

            if ( ((pos1.x < pos2.x) && (vel1.x > 0)) 
                || ((pos1.x > pos2.x) && (vel1.x > 0))
                || ((pos1.x > pos2.x) && (vel1.x < 0))
                || ((pos1.y > pos2.y) && (vel1.y < 0)) 
                 ) {

                if (sprite.mustRemove) {
                    GameLayer *layer = (GameLayer*)data;
                    [layer reportAchievement:red_exploded percentComplete:100];
                }

                cpSpaceAddPostStepCallback(space, (cpPostStepFunc)postStepExplode, a, data);
                cpSpaceAddPostStepCallback(space, (cpPostStepFunc)postStepRemove, b, data);
                return 0;
            }
        }
    }

    return 1;
}

@implementation GameLayer

@synthesize level = _level, sheet = _sheet;
@synthesize moved;
@synthesize anExplosion;
@synthesize theLevelInfo;

- (void)setAccellerometer
{
    self.isAccelerometerEnabled = YES;
    if (!self.isAccelerometerEnabled) {
         space->gravity = ccp(0, -200);
   }

}

- (void) setDefaultBackground
{
    self.background = [[[CCSprite alloc] initWithFile:[self XDFile:self.bgFileName]] autorelease];
}

-(id) init
{
//#ifndef NDEBUG
//    NSLog(@"Entering GameLayer init");
//#endif
    self = [super init];

    if ( self ) {
		aps = [AppSettings shared];
        self.isTouchEnabled = YES;

        _level = -1;
        _facet = FACET*_scale;
        
        _delegate.paused = NO;
    
        CGSize wins = [[CCDirector sharedDirector] winSize];
    
        [self setDefaultBackground];
        cpInitChipmunk();
		
        space = cpSpaceNew();
        cpSpaceResizeStaticHash(space, 400.0f, 40);
        cpSpaceResizeActiveHash(space, 100, 600);
		
        space->gravity = ccp(0, -200);
        space->elasticIterations = space->iterations;
        
        // create the border to test for collisions
        cpBody *staticBody = cpBodyNew(INFINITY, INFINITY);
        cpShape *shape;

        // bottom
        shape = cpSegmentShapeNew(staticBody, ccp(0,0), ccp(wins.width,0), 0.0f);
        shape->e = 1.0f; shape->u = 1.0f; shape->collision_type = kBorderCollision;
        cpSpaceAddStaticShape(space, shape);

        // top
        shape = cpSegmentShapeNew(staticBody, ccp(0,wins.height), ccp(wins.width,wins.height), 0.0f);
        shape->e = 1.0f; shape->u = 1.0f; shape->collision_type = kBorderCollision;
        cpSpaceAddStaticShape(space, shape);

        // left
        shape = cpSegmentShapeNew(staticBody, ccp(0,0), ccp(0,wins.height), 0.0f);
        shape->e = 1.0f; shape->u = 1.0f; shape->collision_type = kBorderCollision;
        cpSpaceAddStaticShape(space, shape);

        // right
        shape = cpSegmentShapeNew(staticBody, ccp(wins.width,0), ccp(wins.width,wins.height), 0.0f);
        shape->e = 1.0f; shape->u = 1.0f; shape->collision_type = kBorderCollision;
        cpSpaceAddStaticShape(space, shape);

        cpSpaceAddCollisionHandler(space, kBorderCollision, 0, collisionBegin, nil, nil, nil, self);
        cpSpaceAddCollisionHandler(space, kBorderCollision, kExplodeCollission, collisionBegin, nil, nil, nil, self);
        cpSpaceAddCollisionHandler(space, kExplodeCollission, 0, explosion, nil, nil, nil, self);

        self.sheet = [CCSpriteBatchNode batchNodeWithFile:[self scaledFile: @"Shape-Atlas.png"] capacity:100];
        [self addChild:_sheet z:zSpritesLevel tag:kTagAtlasSpriteSheet];

        [self addPauseButton];
        
        //timeLabel = [CCLabelAtlas labelAtlasWithString:@"00:00:00" charMapFile:@"fps_images.png" itemWidth:16 itemHeight:24 startCharMap:'.'];
        timeLabel = [CCLabelTTF labelWithString:@"00:00" fontName:@"Helvetica" fontSize:18*_scale];
        timeLabel.anchorPoint = ccp(0,1);
        timeLabel.position = ccp(10,wins.height - (_scale*2));
//        timeLabel.scaleX = _scale;
//        timeLabel.scaleY = _scale;
        [timeLabel setColor:ccc3(255,255,0)];
        [self addChild:timeLabel z:zOverlayLevel];
    }
//#ifndef NDEBUG
//    NSLog(@"Leaving GameLayer init");
//#endif
	return self;
}

- (void) addPauseButton
{
    CGSize wins = [[CCDirector sharedDirector] winSize];
    CCMenu *menu = (CCMenu*)[self getChildByTag:kTagPauseButton];
    if (nil != menu) {
        [self removeChild:menu cleanup:YES];
    }
    NSString *pauseName = [self scaledFile: _nightMode ? @"alt-pause-icon.png" : @"pause-icon.png"];
    menu = [CCMenu menuWithItems: [CCMenuItemImage itemFromNormalImage:pauseName
                                                                 selectedImage:pauseName
                                                                        target:self 
                                                                      selector:@selector(pause)], nil];
    [menu alignItemsVertically];
    menu.anchorPoint = ccp(1,1);
    menu.position = ccp(wins.width - (_scale*42), wins.height - (_scale*16));
    [self addChild:menu  z:zOverlayLevel tag:kTagPauseButton];
}

-(void) addSprite: (UInt32)b
{
    int x = (MapXValue(b) * (_facet/2)), y = (MapYValue(b) * (_facet/2)), kind = MapPieceValue(b);
    [self addNewSprite: kind x:x y:y];
}

-(void) addNewSprite: (int)kind x:(float)x y:(float)y
{
    //CCSpriteBatchNode *sheet = (CCSpriteBatchNode*) [self getChildByTag:kTagAtlasSpriteSheet];
	
    ShapeSprite *sprite = [ShapeSprite Sprite:kind x:x y:y withSheet:_sheet];
    [sprite addToSpace:space];
	
}

- (void)runWithMap: (UInt32*)map
{
    win = NO;
    lose = NO;
    blueRemoved = 0;

    [self clearBoard];
    for (int i=0; map[i]; ++i) {
        [self addSprite: map[i]];
    }
    [self resetScore];
    [self start];
}

- (void) resetScore
{
    moves = 0;
    elapsedtime = 0;
    [timeLabel setString:@"00:00"];
}

- (void)start
{
    [self schedule: @selector(step:)];
    [self schedule: @selector(updateTime:) interval:1.0];
    startTime = time(0L);
}

- (void)stop
{
    [self unschedule: @selector(step:)];
    [self unschedule: @selector(updateTime:)];
}

- (void)play
{
    win = lose = NO;

    [self setAccellerometer];
    [_delegate playIntroMusic];
    
    if (_delegate.paused) {
        [self resume];
    }
    else {
        [self hidePauseMenu];
        [self gotoLevel:-1];
    }
}

- (void)playLevel: (NSNumber*)num
{
    [self gotoLevel:[num intValue]];
}

- (void)restart
{
    _delegate.paused = NO;
    [self hidePauseMenu];
    [self gotoLevel:-1];
}

- (void) showPauseMenu: (BOOL)canResume
{
    if (nil == pauseMenu) {
        
        

        [self dimScreen];
        CCMenuItemImage *item1;
        CCMenuItemImage *item2 = [CCMenuItemImage itemFromNormalImage:[self scaledFile: @"pause-restart.png"]
                                                        selectedImage:[self scaledFile: @"pause-restart-sel.png"]
                                                               target:self 
                                                             selector:@selector(restart)];
        
        CCMenuItemImage *item3 = [CCMenuItemImage itemFromNormalImage:[self scaledFile: @"pause-quit.png"]
                                                        selectedImage:[self scaledFile: @"pause-quit-sel.png"]
                                                               target:self 
                                                             selector:@selector(quit)];
        
        if (canResume) {
            item1 = [CCMenuItemImage itemFromNormalImage:[self scaledFile: @"pause-resume.png"]
                                           selectedImage:[self scaledFile: @"pause-resume-sel.png"]
                                                  target:self 
                                                selector:@selector(resume)];
        }
        else {
            item1 = [CCMenuItemImage itemFromNormalImage:[self scaledFile: @"uhoh.png"] 
                                           selectedImage:[self scaledFile: @"uhoh.png"]];
        }
        
        pauseMenu = [CCMenu menuWithItems: item1, item2, item3, nil];
        [pauseMenu alignItemsVertically];
        [self addChild:pauseMenu z:zOverlayLevel tag:kTagPauseMenu];
        _delegate.paused = canResume;
    }
}

- (void) hidePauseMenu
{
    [self undimScreen];
    if (nil != pauseMenu) {
        pauseMenu.visible = NO;
        //[self removeChildByTag:kTagPauseBackground cleanup:NO];
        [self removeChild:pauseMenu cleanup:NO];
        pauseMenu = nil;
    }
    // also remove win screen if present
    [self removeChildByTag:kTagWinScreen cleanup:YES];
}

- (void)quit
{
    [aps save];
    _delegate.paused = NO;
    [self stopAllActions];
    [self hidePauseMenu];
    [_delegate menu:self];
}

- (void)pause
{
    [self stop];
    [self showPauseMenu:YES];
}

- (void)resume
{
    [self setAccellerometer];
    _delegate.paused = NO;
    [self hidePauseMenu];
    [self start];
}

- (void)removeShape: (cpShape*)shape force: (BOOL)force
{
    //NSLog(@"GaameScreen removeShape: %d",shape);
    ShapeSprite *sprite = shape->data;
    [self removeSprite: sprite force: force];
}

- (void)removeSprite: (ShapeSprite*)sprite force: (BOOL)force
{
    if ((nil != sprite) && (force || sprite.canRemove)) {
        if (sprite.mustKeep) {
            //NSLog(@"removing green object - LOSE");
            [_delegate playLoseSound];
            lose = YES;
        }
        else if (!force) {
            [_delegate playRemoveSound];
        }
        sprite.visible = NO;
        if (!sprite.mustRemove && !sprite.mustKeep) {
            blueRemoved += 1;
        }
        [_sheet removeChild:sprite cleanup:NO];
        if (!force) {
            moves += 1;
        }
        [self testWinOrLose];
    }
}

-(void) onEnter
{
	[super onEnter];
    self.isTouchEnabled = YES;
	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
}


-(void) clearBoard
{
    [_sheet removeAllChildrenWithCleanup:YES];
}

- (void) updateTime: (ccTime) dt
{
    elapsedtime += dt;
    [timeLabel setString: format_time(elapsedtime)];
     //[NSString stringWithFormat:@"%04.0f",elapsedtime]];
}

-(void) step: (ccTime) delta
{
	int steps = 2;
	CGFloat dt = delta/(CGFloat)steps;
	
    moved = NO;
    
	for(int i=0; i<steps; i++){
		cpSpaceStep(space, dt);
	}
	cpSpaceHashEach(space->activeShapes, &eachShape, self);
	cpSpaceHashEach(space->staticShapes, &eachShape, self);

    if (win && !moved) {
        //NSLog(@"%d blue pieces removed",blueRemoved);
        [self showWinScreen];
    }
    else if (lose) {
        [self showLoseScreen];
    }
}

// *** Should not be used
//- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    if (win || lose)
//        return NO;
//
//    CGPoint location = [touch locationInView: [touch view]];
//    location = [[CCDirector sharedDirector] convertToGL: location];
//    cpShape *shape = cpSpacePointQueryFirst(space, location, CP_ALL_LAYERS, 0);
//    if (nil != shape) {
//        [self removeShape: shape force: NO];
//        return YES;
//    }
//    return NO;
//}

- (ShapeSprite*) itemForTouch: (CGPoint)touch
{
//	touch = [[CCDirector sharedDirector] convertToGL: touch];
	
	ShapeSprite* sprite;
	CCARRAY_FOREACH([_sheet children], sprite){
		// ignore invisible and disabled items: issue #779, #866
        if (nil != sprite) {
            CGPoint local = [sprite convertToNodeSpace:touch];
			
			CGRect r = [sprite rect];
			r.origin = CGPointZero;
			
			if( CGRectContainsPoint( r, local ) )
				return sprite;
        }
	}
	return nil;
}


- (void) handleTouch: (CGPoint)touch
{
    ShapeSprite *sprite = [self itemForTouch:touch];
    if (nil != sprite) {
        [self removeSprite:sprite force:NO];
    }
    
//    if (win && (nil != (sprite = [self getChildByTag:kTagWinScreen])) ) {
//        if ( CGRectContainsPoint([sprite boundingBox], touch) ) {
//            [self stopAllActions];
//            [self runAction: [CCCallFunc actionWithTarget:self selector:@selector(gotoNextLevel)]];
//            return;
//        }
//    }

    /*
    CCArray *allSprites = [_sheet children];
    for (int i = 0; i < [allSprites count]; i++) {
		sprite = (ShapeSprite *)[allSprites objectAtIndex:i];
        if ( CGRectContainsPoint([sprite boundingBox], touch) ) {
            [self removeSprite:sprite force:NO];
            break;
        }
    }
     */
    
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [[CCDirector sharedDirector] convertToGL: [touch locationInView: [touch view]]];
	
	if(!_delegate.paused) {
        [self handleTouch: point];   //CGPointMake(point.x, 480 - point.y)];
    }
	
	//return YES;
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *) event
{
	//UITouch *touch = [touches anyObject];
	//CGPoint point = [touch locationInView: [touch view]];
	
	//return YES;
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *) event
{
	//UITouch *touch = [touches anyObject];
	//CGPoint point = [touch locationInView: [touch view]];
	
	//return YES;
}


// *** Version 1.0 Code
//- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if (win || lose)
//        return;
//   
//    for( UITouch *touch in touches ) {
//        CGPoint location = [touch locationInView: [touch view]];
//        location = [[CCDirector sharedDirector] convertToGL: location];
//        cpShape *shape = cpSpacePointQueryFirst(space, location, CP_ALL_LAYERS, 0);
//        if (nil != shape) {
//            [self removeShape: shape force: NO];
//        }
//    }
//}

// *** Test Version
//- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//	for( UITouch *touch in touches ) {
//        CGPoint location = [touch locationInView: [touch view]];
//		
//        location = [[CCDirector sharedDirector] convertToGL: location];
//		
//        cpShape *shape = cpSpacePointQueryFirst(space, location, CP_ALL_LAYERS, 0);
//        if (nil != shape) {
//            [self removeShape: shape force: NO];
//        }
///////
//        CGPoint location = [[CCDirector sharedDirector] convertToGL: [touch locationInView: [touch view]]];
//        ShapeSprite *child;
//        for (child in [_sheet children]) {
//            if (CGRectContainsPoint([child boundingBox], location)) {
//                [self removeSprite: child force: NO];
//                break;
//            }
//        }
//////
//	}
//}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
}

- (BOOL)hasBluePieces
{
    CCArray *allSprites = [_sheet children];
    ShapeSprite *sprite;
    for (int i = 0; i < [allSprites count]; i++) {
		sprite = (ShapeSprite *)[allSprites objectAtIndex:i];
        if (!sprite.mustRemove && !sprite.mustKeep) {
            return YES;
        }
    }
    ++blueRemoved;
    return NO;
}

- (BOOL)reportAchievement: (NSString*)identifier percentComplete: (float)percent
{
    GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
    GKAchievement* achievement = [gkHelper getAchievementByID:identifier];
    if (achievement.completed == NO) {
        [gkHelper reportAchievementWithID:identifier percentComplete:percent];
        return achievement.completed;
    }
    return YES;
}

- (void)showWinScreen
{
    CGSize wins = [[CCDirector sharedDirector] winSize];
    LevelCompleteMsg *msg = nil;
    [self stop];

    [_delegate playWinSound];

    [self dimScreen];

    [[GameManager shared] setScore:moves forLevel:self.level];
    [[GameManager shared] setTime:elapsedtime forLevel:self.level];

    NSInteger levelPoints = [theLevelInfo pointValue:moves];
    NSInteger totalPoints = aps.totalPoints + levelPoints;
    aps.totalPoints = totalPoints;

    if (self.level == 2) {
        [self reportAchievement:complete_tutorial percentComplete:100.0];
    }
    if (self.level <= 9) {
        [self reportAchievement:complete_10_levels percentComplete:(self.level + 1)*10];
    }
    if (self.level <= 19) {
        [self reportAchievement:complete_20_levels percentComplete:(self.level + 1)*5];
    }
    
    if (theLevelInfo.achievement != nil) {
        BOOL success = ( (blueRemoved == 0) || ((theLevelInfo.flags & NoBlueAchievement) == 0) );
        if (success && (theLevelInfo.flags & TimeLimitAchievement) && (elapsedtime < theLevelInfo.timeLimit) ) {
#ifdef LITE_VERSION
            [self reportAchievement:[NSString stringWithFormat:@"f%@",theLevelInfo.achievement] percentComplete:100];
#else
            [self reportAchievement:theLevelInfo.achievement percentComplete:100];
#endif
        }
        if (success && (theLevelInfo.flags & MoveNumberAchievement) && (moves < theLevelInfo.par) ) {
#ifdef LITE_VERSION
            [self reportAchievement:[NSString stringWithFormat:@"f%@",theLevelInfo.achievement] percentComplete:100];
#else
            [self reportAchievement:theLevelInfo.achievement percentComplete:100];
#endif
        }
    }

    if (self.level == INT16_MAX) {
        msg = [[LevelCompleteMsg alloc] initWithMoves:moves];
        msg.position = ccp(wins.width / 2, wins.height / 2);
    }
    else {
        [self hasBluePieces];
        if (blueRemoved == 0) {
            [self reportAchievement:no_blue_pieces percentComplete:100];
        }
        msg = [[LevelCompleteMsg alloc] initWithMoves:moves level:self.level time:elapsedtime blues:blueRemoved];
        msg.position = ccp(wins.width / 2, wins.height / 1.8);
    }
    [self addChild:msg z:zOverlayLevel tag:kTagWinScreen];
    [msg release];
    [self runAction: [CCSequence actions:[CCDelayTime actionWithDuration:3], [CCCallFunc actionWithTarget:self selector:@selector(gotoNextLevel)],nil]];

    GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
    [gkHelper submitScore:totalPoints category:gk_score_category];
}

- (void)dimScreen
{
    // make sure it doessn't get re-added
    if (nil == [self getChildByTag:kTagPauseBackground])
    {
        CGSize wins = [[CCDirector sharedDirector] winSizeInPixels];   
        CCSprite *dim = [[[CCSprite alloc] initWithFile:@"blackbg.png"] autorelease];
        dim.scaleX = wins.width;
        dim.scaleY = wins.height;
        dim.anchorPoint = ccp(0,0);
        dim.position = ccp(0,0);
        dim.opacity = floor(256 * .70);
        [self addChild:dim z:zOverlayLevel tag:kTagPauseBackground];
    }
}

- (void)undimScreen
{
    [self removeChildByTag:kTagPauseBackground cleanup:YES];
}


- (void)gotoNextLevel
{
    [self undimScreen];
    [self removeChildByTag:kTagWinScreen cleanup:YES];

    if (self.level == INT16_MAX) {
        [self gotoLevel: self.level];
    }
    else {
        [self gotoLevel: self.level + 1];
    }
}

- (void)showLoseScreen
{
    [self stop];
    [self showPauseMenu:NO];
    
}

- (BOOL)gotoLevel: (int)level
{
    if (level < 0) {
        level = _delegate.curLevel;
        if (level >= [_delegate levelCount]) {
#ifndef LITE_VERSION
            [self reportAchievement:complete_all_levels percentComplete:100];
#endif
            _delegate.curLevel = 0;
            level = 0;
        }
    }

    [self setAccellerometer];
        
    if (level < INT16_MAX) {
        self.level = level;
        aps.lastLevel = level;
        if (level > aps.highestLevel) {
            aps.highestLevel = level;
            [aps save];
        }
    }
    
    self.theLevelInfo = [[GameManager shared] GetLevel: level];
    
    NSData *map = theLevelInfo.map;
    if (nil != map) {
        BOOL tmpNightMode = isNightMode();
        if (self.nightMode != tmpNightMode) {
            self.nightMode = tmpNightMode;
            [self addPauseButton];
        }
        if (nil != theLevelInfo.background) {
            self.background = [[[CCSprite alloc] initWithFile:[self AltXDFile: theLevelInfo.background]] autorelease];
            [self removeClouds];
        }
        else {
            [self setDefaultBackground];
            [self addClouds];
            [self moveClouds];
        }

        [self runWithMap: (UInt32*)[map bytes]];
        return YES;
    }
    [GameManager shared].curLevel = 0;
    [self quit];
    return NO;
}

- (int)testWinOrLose
{
    ShapeSprite* child;
    if (lose)
        return -1;
    // check that no mustRemove objects still exist
    win = YES;
    for (child in [_sheet children]) {
        if ([child isMemberOfClass:[ShapeSprite class]]) {
            if (child.mustRemove)
                win = NO;
        }
    }
    //NSLog(@"testWinOrLose: win=%d lose-%d",win,lose);
    return (win ? 1 : (lose ? -1 : 0));
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
#define kFilterFactor 0.25f
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	CGPoint v = ccp( -accelY, accelX);
	
	space->gravity = ccpMult(v, _scale*200);
}

@end
