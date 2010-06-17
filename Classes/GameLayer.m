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

enum {
	kTagAtlasSpriteSheet = 1,
};

#define kBorderCollision  888


static void
eachShape(void *ptr, void* unused)
{
	cpShape *shape = (cpShape*) ptr;
	CCSprite *sprite = shape->data;
	if( sprite ) {
		cpBody *body = shape->body;
		
		// TIP: cocos2d and chipmunk uses the same struct to store it's position
		// chipmunk uses: cpVect, and cocos2d uses CGPoint but in reality the are the same
		// since v0.7.1 you can mix them if you want.		
		[sprite setPosition: body->p];
		
		[sprite setRotation: (float) CC_RADIANS_TO_DEGREES( -body->a )];
	}
}

static void postStepRemove(cpSpace *space, cpShape *shape, void *data)
{
    NSLog(@"remove shape");
    [(GameLayer*)data removeShape:shape force: YES];
}

static int collisionBegin(cpArbiter *arb, struct cpSpace *space, void *data)
{
    NSLog(@"collision handler");
    CP_ARBITER_GET_SHAPES(arb, a, b);
    cpSpaceAddPostStepCallback(space, (cpPostStepFunc)postStepRemove, b, data);
    return 0;
}

@implementation GameLayer

@synthesize level = _level, sheet = _sheet;

-(id) init
{
    if( (self=[super init])) {
		
        self.isTouchEnabled = YES;
        self.isAccelerometerEnabled = YES;
        
        CGSize wins = [[CCDirector sharedDirector] winSize];
    
        self.background = [[[CCSprite alloc] initWithFile:@"background.png"] autorelease];

        cpInitChipmunk();
		
        space = cpSpaceNew();
        cpSpaceResizeStaticHash(space, 400.0f, 40);
        cpSpaceResizeActiveHash(space, 100, 600);
		
        space->gravity = ccp(0, -200);
        space->elasticIterations = space->iterations;

        _level = 1;
        
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

        self.sheet = [CCSpriteSheet spriteSheetWithFile:@"pieces.png" capacity:100];
        [self addChild:_sheet z:0 tag:kTagAtlasSpriteSheet];

        CCMenu *menu = [CCMenu menuWithItems: [CCMenuItemImage itemFromNormalImage:@"pause-icon.png" 
                                                                     selectedImage:@"pause-icon.png" 
                                                                            target:self 
                                                                          selector:@selector(pause)], nil];
        [menu alignItemsVertically];
        menu.anchorPoint = ccp(1,1);
        menu.position = ccp(wins.width - 42, wins.height - 16);
        [self addChild:menu];
        //[self runWithMap: lvl1 size:(sizeof(lvl1) / sizeof(UInt32))];
        //[self gotoLevel: [_delegate curLevel]];
    }
	
	return self;
}

-(void) addSprite: (UInt32)b
{
    int x = (MapXValue(b) * FACET), y = (MapYValue(b) * FACET), kind = MapPieceValue(b);
    [self addNewSprite: kind x:x y:y];
}

-(void) addNewSprite: (int)kind x:(float)x y:(float)y
{
    //CCSpriteSheet *sheet = (CCSpriteSheet*) [self getChildByTag:kTagAtlasSpriteSheet];
	
    ShapeSprite *sprite = [ShapeSprite NewSprite:kind x:x y:y withSheet:_sheet];
    [sprite addToSpace:space];
	
}

- (void)runWithMap: (UInt32*)map
{
    win = NO;
    lose = NO;

    for (int i=0; map[i]; ++i) {
        [self addSprite: map[i]];
    }
    [self reset];
    [self start];
}

- (void) reset
{
    moves = 0;
    time = 0;
}

- (void)start
{
    [self schedule: @selector(step:)];
}

- (void)pause
{
    [self stop];
    if (nil == pauseMenu) {
        
        pauseMenu = [CCMenu menuWithItems:      [CCMenuItemImage itemFromNormalImage:@"pause-restart.png" 
                                                                       selectedImage:@"pause-restart-sel.png" 
                                                                              target:self 
                                                                            selector:@selector(start)],
                                                [CCMenuItemImage itemFromNormalImage:@"pause-resume.png"
                                                                       selectedImage:@"pause-resume-sel.png"
                                                                              target:self 
                                                                            selector:@selector(resume)],
                                                [CCMenuItemImage itemFromNormalImage:@"pause-quit.png"
                                                                        selectedImage:@"pause-quit-sel.png"
                                                                               target:_delegate 
                                                                            selector:@selector(menu:)],
                                                nil];
        [pauseMenu alignItemsVertically];
        [self addChild:pauseMenu];
    }
}

- (void)resume
{
    if (nil != pauseMenu) {
        [self removeChild:pauseMenu cleanup:NO];
        pauseMenu = nil;
    }
    [self start];
}

- (void)stop
{
    [self unschedule: @selector(step:)];
}

- (void)removeShape: (cpShape*)shape force: (BOOL)force
{
    NSLog(@"GaameScreen removeShape: %d",shape);
    ShapeSprite *sprite = shape->data;
    if ((nil != sprite) && (force || sprite.canRemove)) {
        if (sprite.mustKeep) {
            NSLog(@"removing green object - LOSE");
            lose = YES;
        }
        sprite.visible = NO;
        [_sheet removeChild:sprite cleanup:NO];
        moves += 1;
        [self testWinOrLose];
    }
}

-(void) onEnter
{
	[super onEnter];
	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
}


-(void) clearBoard
{
    [_sheet removeAllChildrenWithCleanup:YES];
}

-(void) step: (ccTime) delta
{
	int steps = 2;
	CGFloat dt = delta/(CGFloat)steps;
	
	for(int i=0; i<steps; i++){
		cpSpaceStep(space, dt);
	}
	cpSpaceHashEach(space->activeShapes, &eachShape, nil);
	cpSpaceHashEach(space->staticShapes, &eachShape, nil);

    if (win) 
        [self showWinScreen];
    else if (lose) 
        [self showLoseScreen];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	for( UITouch *touch in touches ) {
        CGPoint location = [touch locationInView: [touch view]];
		
        location = [[CCDirector sharedDirector] convertToGL: location];
		
        cpShape *shape = cpSpacePointQueryFirst(space, location, CP_ALL_LAYERS, 0);
        if (nil != shape) {
            [self removeShape: shape force: NO];
        }
	}
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self clearBoard];
    if (lose) {
        //[self runWithMap: lvl1 size:(sizeof(lvl1) / sizeof(UInt32))];
        [self gotoLevel:self.level];
    }
    else if (win) {
        [self gotoLevel: self.level + 1];
    }
}

- (void)showWinScreen
{
    [self stop];
    
    UIAlertView *msg = [[UIAlertView alloc] initWithTitle: @"WIN" 
                                                  message:@"You won" 
                                                 delegate:self
                                        cancelButtonTitle:@"OK" 
                                        otherButtonTitles:nil];
    [msg show];
    [msg release];
}

- (void)showLoseScreen
{
    [self stop];

    UIAlertView *msg = [[UIAlertView alloc] initWithTitle: @"Uh Oh!" 
                                                  message:@"You lost" 
                                                 delegate:self
                                        cancelButtonTitle:@"OK" 
                                        otherButtonTitles:nil];
    [msg show];
    [msg release];
    
}

- (BOOL)gotoLevel: (int)level
{
    self.level = level;
    
    NSData *map = [[GameManager shared] GetLevel: level].map;
    if (nil != map) {
        [self runWithMap: (UInt32*)[map bytes]];
        return YES;
    }
    [GameManager shared].curLevel = 0;
    [_delegate menu:self];
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
    NSLog(@"testWinOrLose: win=%d lose-%d",win,lose);
    return (win ? 1 : (lose ? -1 : 0));
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
#define kFilterFactor 0.05f
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	CGPoint v = ccp( -accelY, accelX);
	
	space->gravity = ccpMult(v, 200);
}


@end
