//
// cocos2d Hello World example
// http://www.cocos2d-iphone.org
//

// Import the interfaces
#import "MainScreen.h"

enum {
	kTagAtlasSpriteSheet = 1,
};

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

// HelloWorld implementation
@implementation MainScreen

+(id) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];

    // 'layer' is an autorelease object.
	 MainScreen *layer = [MainScreen node];
	
	 // add layer as a child to scene
    [scene addChild: layer];
	
    // return the scene
    return scene;
}


-(void) addNewSpriteX: (float)x y:(float)y
{
	int posx, posy;
	
	CCSpriteSheet *sheet = (CCSpriteSheet*) [self getChildByTag:kTagAtlasSpriteSheet];
	
	posx = (CCRANDOM_0_1() * 200);
	posy = (CCRANDOM_0_1() * 200);
	
	posx = (posx % 4) * 64;
	posy = (posy % 3) * 64;
	
	CCSprite *sprite = [CCSprite spriteWithSpriteSheet:sheet rect:CGRectMake(posx, posy, 64, 64)];
	[sheet addChild: sprite];
	
	sprite.position = ccp(x,y);
	
	int num = 4;
	CGPoint verts[] = {
		ccp(-26,-26),
		ccp(-26, 26),
		ccp( 26, 26),
		ccp( 26,-26),
	};
	
	cpBody *body = cpBodyNew(1.0f, cpMomentForPoly(1.0f, num, verts, CGPointZero));
	
	// TIP:
	// since v0.7.1 you can assign CGPoint to chipmunk instead of cpVect.
	// cpVect == CGPoint
	body->p = ccp(x, y);
	cpSpaceAddBody(space, body);
	
	cpShape* shape = cpPolyShapeNew(body, num, verts, CGPointZero);
	shape->e = 0.5f; shape->u = 0.5f;
	shape->data = sprite;
	cpSpaceAddShape(space, shape);
	
}
-(id) init
{
	if( (self=[super init])) {
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
		CGSize wins = [[CCDirector sharedDirector] winSize];
		cpInitChipmunk();
		
		cpBody *staticBody = cpBodyNew(INFINITY, INFINITY);
		space = cpSpaceNew();
		cpSpaceResizeStaticHash(space, 400.0f, 40);
		cpSpaceResizeActiveHash(space, 100, 600);
		
		space->gravity = ccp(0, -1000);
		space->elasticIterations = space->iterations;
		
//        CCSprite *back = [[CCSprite alloc] initWithFile:@"background.png" 
//                                                   rect: CGRectMake(0, 0, wins.width * 2, wins.height * 2)];
//        background = back;
//        [self addChild:background];
//        [background release];
    
		cpShape *shape;
		
		// bottom
		shape = cpSegmentShapeNew(staticBody, ccp(0,0), ccp(wins.width,0), 0.0f);
		shape->e = 1.0f; shape->u = 1.0f;
		cpSpaceAddStaticShape(space, shape);
		
		// top
		shape = cpSegmentShapeNew(staticBody, ccp(0,wins.height), ccp(wins.width,wins.height), 0.0f);
		shape->e = 1.0f; shape->u = 1.0f;
		cpSpaceAddStaticShape(space, shape);
		
		// left
		shape = cpSegmentShapeNew(staticBody, ccp(0,0), ccp(0,wins.height), 0.0f);
		shape->e = 1.0f; shape->u = 1.0f;
		cpSpaceAddStaticShape(space, shape);
		
		// right
		shape = cpSegmentShapeNew(staticBody, ccp(wins.width,0), ccp(wins.width,wins.height), 0.0f);
		shape->e = 1.0f; shape->u = 1.0f;
		cpSpaceAddStaticShape(space, shape);
		
		CCSpriteSheet *sheet = [CCSpriteSheet spriteSheetWithFile:@"pieces.png" capacity:100];
		[self addChild:sheet z:0 tag:kTagAtlasSpriteSheet];
		
		[self addNewSpriteX: 200 y:200];
		
		[self schedule: @selector(step:)];
	}
	
	return self;
}

-(void) onEnter
{
	[super onEnter];
	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
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
}

- (void)removeShape: (cpShape*)shape
{
    CCSprite *sprite = shape->data;
    if (nil != sprite) {
        sprite.visible = NO;
        [self removeChild:sprite cleanup:NO];
    }
    cpSpaceRemoveShape(space, shape);
}


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	for( UITouch *touch in touches ) {
        CGPoint location = [touch locationInView: [touch view]];
		
        location = [[CCDirector sharedDirector] convertToGL: location];
		
        cpShape *shape = cpSpacePointQueryFirst(space, location, CP_ALL_LAYERS, 0);
        if (nil != shape) {
            [self removeShape: shape];
        }
        else {
            [self addNewSpriteX: location.x y:location.y];
        }
	}
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
#define kFilterFactor 0.05f
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	CGPoint v = ccp( accelX, accelY);
	
	space->gravity = ccpMult(v, 200);
}
@end
