//
//  ViewController.m
//  Snake
//
//  Created by 明妍 on 2019/1/30.
//  Copyright © 2019 明妍. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>
#import <Masonry/Masonry.h>
#import "MYSnakeItemBox.h"
#import "MYGridView.h"
#import "MYRestartView.h"
#import "MYSnakeFood.h"

CGFloat kSnakeInitialCount = 6;
CGFloat kPlandLength = 20;

typedef enum : NSUInteger {
    MYCurrentDirectionLeft,
    MYCurrentDirectionRight,
    MYCurrentDirectionFore,
    MYCurrentDirectionBack,
    MYCurrentDirectionTop,
    MYCurrentDirectionBottom,
} MYCurrentDirection;

@interface ViewController ()

@property (nonatomic, strong) SCNView *threeDscnView; /**< 3D View  */
@property (nonatomic, strong) SCNScene *threeScene; /**< 3D场景  */
@property (nonatomic, strong) NSMutableArray<MYSnakeItemBox *> *snakeItems; /**< 蛇身体的每一块 初始值有6块 */

@property (nonatomic, strong) SCNPlane *bottomPlane; /**< 底板  */
@property (nonatomic, strong) SCNPlane *leftPlane; /**< 左侧板  */
@property (nonatomic, strong) SCNPlane *rightPlane; /**< 右侧板  */
@property (nonatomic, strong) SCNPlane *topPlane; /**< 顶部板  */
@property (nonatomic, strong) SCNPlane *forePlane; /**< 前部板  */
@property (nonatomic, strong) SCNPlane *backPlane; /**< 背部板  */

@property (nonatomic, strong) SCNCamera *camera; /**< 照相机  */

@property (nonatomic, assign) BOOL isPlaying;/** < 是否正在游戏*/
@property (nonatomic, strong) NSTimer *timer; /**< 每秒做的动作  */
@property (nonatomic, assign) MYCurrentDirection currentDirection;/** < 当前的方向*/
@property (nonatomic, assign) NSInteger timeStep;/** < 时间间隔*/

@property (nonatomic, strong) MYRestartView *pageView;
@property(nonatomic, weak) MYSnakeItemBox *headItemBox;
@property(nonatomic, weak) MYSnakeItemBox *lastItemBox;
@property (nonatomic, strong) MYSnakeFood *snakeFood;
@property (nonatomic, assign) SCNVector3 lastVector;/** < 蛇尾的位置*/

@end

@implementation ViewController

#pragma mark - --------------------dealloc ------------------
#pragma mark - --------------------life cycle--------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    self.timeStep = 1;
   
}

- (void)initData {
    [self setupSnake];
    [self setupFood];
}

- (void)initView {
    [self.view addSubview:self.threeDscnView];
    [self.threeDscnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view addSubview:self.pageView];
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        
    }];
}

- (void)setupFood {
    SCNNode *node = [SCNNode node];
    MYSnakeFood *snakeFood = [MYSnakeFood snakeFood];
    node.geometry = snakeFood;
    node.position = [self getFoodPosition];
    [self.threeScene.rootNode addChildNode:node];
    self.snakeFood = snakeFood;
    snakeFood.position = node.position;
}

- (SCNVector3)getFoodPosition {
//    return SCNVector3Make(.25, .25, 1.25);
    SCNVector3 vector = SCNVector3Zero;
    BOOL isLegalFoodPosition = YES;
    do {
        int i = 9;
        CGFloat vectorX = 0.25 + 0.5 * i;
        CGFloat vectorY = 0.25 + 0.5 * i;
        CGFloat vectorZ = 0.25 + 0.5 * i;
        SCNVector3 vector = SCNVector3Make(vectorX, vectorY, vectorZ);
        for (MYSnakeItemBox *itemBox in self.snakeItems) {
            if (SCNVector3EqualToVector3(vector, itemBox.position)) {
                isLegalFoodPosition = NO;
                break;
            }
        }
    } while (!isLegalFoodPosition);
    return vector;
}

- (void)refreshFoodPosition {
    self.snakeFood.position = [self getFoodPosition];
}

/**
 初始化蛇item
 */
- (void)setupSnake {
    MYSnakeItemBox *preItemBox;
    SCNVector3 vector = SCNVector3Make(1.25, 1.25, 1.25);
    for (int i = 0; i < kSnakeInitialCount; i++) {

        MYSnakeItemBox *itemBox = [MYSnakeItemBox snakeItemBox];
        itemBox.position = vector;
        preItemBox.nextItemBox = itemBox;
        itemBox.preItemBox = preItemBox;
        preItemBox = itemBox;
        
        // 改变vector
        if (arc4random() % 2) {
            vector.x += 0.5;
        } else {
            vector.y += 0.5;
        }
        [self.snakeItems addObject:itemBox];
        if (i == kSnakeInitialCount - 1) {
            self.lastItemBox = itemBox;
        }
    }
    // 添加蛇到场景中
    for (MYSnakeItemBox *snakeItemBox in self.snakeItems) {
        SCNNode *node = [SCNNode nodeWithGeometry:snakeItemBox];
        node.position = snakeItemBox.position;
        snakeItemBox.node = node;
        [self.threeScene.rootNode addChildNode:node];
    }
    MYSnakeItemBox *firstSnakeItemBox = [self.snakeItems objectAtIndex:0];
    self.headItemBox = firstSnakeItemBox;
    SCNMaterial *material = [SCNMaterial material];
    material.diffuse.contents = [UIColor greenColor];
    firstSnakeItemBox.materials = @[material];
}

#pragma mark - --------------------UITableViewDelegate--------------
#pragma mark - --------------------CustomDelegate--------------
#pragma mark - --------------------Event Response--------------

- (void)onClickTap:(UIGestureRecognizer *)recognizer {
//    if (!self.isPlaying) {
//        self.isPlaying = YES;
//    }
    if ([recognizer.view isEqual:self.threeDscnView]) {
         CGPoint point = [recognizer locationInView:self.threeDscnView];
        NSArray<SCNHitTestResult *> *results = [self.threeDscnView hitTest:point options:nil];
        SCNHitTestResult *result = results.firstObject;
        if (result) {
            SCNPlane *plane = (SCNPlane*)result.node.geometry;
            if ([plane isKindOfClass:[SCNPlane class]]) {
                if ([plane isEqual:self.bottomPlane]) {
                    self.currentDirection = MYCurrentDirectionBottom;
                    [self singleStepBottom];
                }
                if ([plane isEqual:self.topPlane]) {
                    self.currentDirection = MYCurrentDirectionTop;
                    [self singleStepTop];
                }
                if ([plane isEqual:self.leftPlane]) {
                    self.currentDirection = MYCurrentDirectionLeft;
                    [self singleStepLeft];
                }
                if ([plane isEqual:self.rightPlane]) {
                    self.currentDirection = MYCurrentDirectionRight;
                    [self singleStepRight];
                }
                if ([plane isEqual:self.forePlane]) {
                    self.currentDirection = MYCurrentDirectionFore;
                    [self singleStepFore];
                }
                if ([plane isEqual:self.backPlane]) {
                    self.currentDirection = MYCurrentDirectionBack;
                    [self singleStepBack];
                }
            }
        }
        BOOL isEat = [self checkCanEat];
        if (isEat) {
            [self addNewSnakeItem];
        }
    }
}

/**
 后移一格
 */
- (void)singleStepBack {
    [self actionfollowSnakeItem];
    [self moveSnakeHead:SCNVector3Make(0 , 0, - 0.5)];
}

- (void)moveSnakeHead:(SCNVector3)diffVector {
    MYSnakeItemBox *box = self.headItemBox;
    SCNVector3 vector = box.position;
    SCNVector3 newVector = SCNVector3Make(vector.x + diffVector.x , vector.y + diffVector.y, vector.z + diffVector.z);
    SCNNode *node = box.node;
    SCNAction *action = [SCNAction moveTo:newVector duration:0.5];
    //    NSLog(@"vector = {%f,%f,%f}",vector.x,vector.y,vector.z);
    //    NSLog(@"newVector = {%f,%f,%f}",newVector.x,newVector.y,newVector.z);
    [node runAction:action];
    box.position = newVector;
    BOOL isAlive = [self checkIsALive];
    if (!isAlive) {
        [self failGame];
    }
}

- (void)failGame {
    self.isPlaying = NO;
    //弹出页面
    [self pushRestartPage];
}

/**
 弹出重新开始页面
 */
- (void)pushRestartPage {
    //TODO: wmy
    self.pageView.alpha = 0;
    self.pageView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.pageView.alpha = 1;
    }];
}

- (void)restart {
    //TODO: wmy 重新开始
    
}

/**
 确认蛇是否存活
 */
- (BOOL)checkIsALive {
    //1. 蛇头是否在蛇身体内
    BOOL isInSnakeBody = [self checkHeadIsInSnakeBody];
    //2. 蛇头是否到了边界
    BOOL isExceedEdge = [self checkHeadIsExceedEdge];
    return !isInSnakeBody && !isExceedEdge;
}

/**
 是否越过边界
 */
- (BOOL)checkHeadIsExceedEdge {
    MYSnakeItemBox *firstBox = self.headItemBox;
    if (fabsf(firstBox.position.x) < 5.f &&
        (firstBox.position.y < 10.f && firstBox.position.y >0) &&
        fabsf(firstBox.position.z) < 5.f) {
        return NO;
    }
    return YES;
}

- (BOOL)checkHeadIsInSnakeBody {
    MYSnakeItemBox *firstBox = self.headItemBox;
    for (int i = 1; i < self.snakeItems.count; i++) {
        MYSnakeItemBox *box = [self.snakeItems objectAtIndex:i];
        if (SCNVector3EqualToVector3(firstBox.position, box.position)) {
            return YES;
        }
    }
    return NO;
}

/**
 是否吃到了
 */
- (BOOL)checkCanEat {
    MYSnakeItemBox *itemBox = self.headItemBox;
    if (SCNVector3EqualToVector3(itemBox.position, self.snakeFood.position)) {
        return YES;
    }
    return NO;
}

/**
 前移一格
 */
- (void)singleStepFore {
    [self actionfollowSnakeItem];
    [self moveSnakeHead:SCNVector3Make(0, 0, 0.5)];
}

- (void)actionfollowSnakeItem {
    MYSnakeItemBox *lastItemBox = [self.snakeItems objectAtIndex:self.snakeItems.count - 1];
    self.lastVector = lastItemBox.position;
    for (int i = (int)self.snakeItems.count - 1; i >0 ; i--) {
        MYSnakeItemBox *followBox = [self.snakeItems objectAtIndex:i];
        SCNNode *node = followBox.node;
        SCNAction *action = [SCNAction moveTo:followBox.preItemBox.position duration:0.5];
        //        NSLog(@"vector = {%f,%f,%f}",followBox.preItemBox.position.x,followBox.preItemBox.position.y,followBox.preItemBox.position.z);
        [node runAction:action];
        followBox.position = followBox.preItemBox.position;
    }
}

/**
 右移一格
 */
- (void)singleStepRight {
    [self actionfollowSnakeItem];
    [self moveSnakeHead:SCNVector3Make(0.5, 0, 0)];
}

/**
 左移一格
 */
- (void)singleStepLeft {
    [self actionfollowSnakeItem];
    [self moveSnakeHead:SCNVector3Make(-0.5, 0, 0)];
}


/**
 下降一格
 */
- (void)singleStepBottom {
    [self actionfollowSnakeItem];
    [self moveSnakeHead:SCNVector3Make(0, -0.5, 0)];
}

/**
 上升一格
 */
- (void)singleStepTop {
    [self actionfollowSnakeItem];
    [self moveSnakeHead:SCNVector3Make(0, 0.5, 0)];
}

- (void)addNewSnakeItem {
 
    MYSnakeItemBox *itemBox = [MYSnakeItemBox snakeItemBox];
    self.lastItemBox.nextItemBox = itemBox;
    itemBox.preItemBox = self.lastItemBox;
    itemBox.position = self.lastVector;
    
    self.lastItemBox = itemBox;
    SCNNode *node = [SCNNode nodeWithGeometry:itemBox];
    node.position = itemBox.position;
    itemBox.node = node;
    [self.threeScene.rootNode addChildNode:node];
    [self getFoodPosition];
}

#pragma mark - --------------------private methods--------------
#pragma mark - --------------------getters & setters & init members ------------------

- (void)setIsPlaying:(BOOL)isPlaying {
    _isPlaying = isPlaying;
//    if (isPlaying && !_timer) {
//        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.timeStep
//                                                              target:self
//                                                            selector:@selector(onTimer)
//                                                            userInfo:nil
//                                                             repeats:YES];
//            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//            self.timer = timer;
//        });
//    } else {
//        [self.timer invalidate];
//        _timer = nil;
//    }
}

- (void)onTimer {
    switch (self.currentDirection) {
        case MYCurrentDirectionTop: {
            [self singleStepTop];
        }
            break;
        case MYCurrentDirectionBack: {
            [self singleStepBack];
        }
            break;
        case MYCurrentDirectionFore: {
            [self singleStepFore];
        }
            break;
        case MYCurrentDirectionBottom: {
            [self singleStepBottom];
        }
            break;
        case MYCurrentDirectionLeft: {
            [self singleStepLeft];
        }
            break;
        case MYCurrentDirectionRight: {
            [self singleStepRight];
        }
            break;
        default:
            break;
    }
    BOOL isEat = [self checkCanEat];
    if (isEat) {
        [self addNewSnakeItem];
    }
}

- (SCNCamera *)camera {
    if (!_camera) {
        _camera = [[SCNCamera alloc] init];
    }
    return _camera;
}

- (NSMutableArray<MYSnakeItemBox *> *)snakeItems {
    if (!_snakeItems) {
        _snakeItems = [NSMutableArray<MYSnakeItemBox *> array];
    }
    return _snakeItems;
}

- (SCNScene *)threeScene {
    if (!_threeScene) {
        _threeScene = [SCNScene sceneNamed:@"snake.scnassets/snake.scn"];
        // 添加照相机
        SCNNode *bottomNode = [_threeScene.rootNode childNodeWithName:@"bottomPlane" recursively:NO];
        SCNNode *topNode = [_threeScene.rootNode childNodeWithName:@"topPlane" recursively:NO];
        SCNNode *backNode = [_threeScene.rootNode childNodeWithName:@"backPlane" recursively:NO];
        SCNNode *leftNode = [_threeScene.rootNode childNodeWithName:@"leftPlane" recursively:NO];
        SCNNode *foreNode = [_threeScene.rootNode childNodeWithName:@"forePlane" recursively:NO];
        SCNNode *rightNode = [_threeScene.rootNode childNodeWithName:@"rightPlane" recursively:NO];
        SCNNode *cameraNode = [_threeScene.rootNode childNodeWithName:@"camera" recursively:NO];

        self.bottomPlane = (SCNPlane *)bottomNode.geometry;
        self.topPlane = (SCNPlane *)topNode.geometry;
        self.backPlane = (SCNPlane *)backNode.geometry;
        self.leftPlane = (SCNPlane *)leftNode.geometry;
        self.rightPlane = (SCNPlane *)rightNode.geometry;
        self.forePlane = (SCNPlane *)foreNode.geometry;

        self.camera = cameraNode.camera;

        SCNMaterial *material = [SCNMaterial material];
        material.diffuse.contents = [MYGridView gridImage];
        // 底板
        self.bottomPlane.materials = @[material];
        // 顶板
        self.topPlane.materials = @[material];
        // 后侧
        self.backPlane.materials = @[material];
        // 前侧
        self.forePlane.materials = @[material];
        // 左侧
        self.leftPlane.materials = @[material];
        // 右侧
        self.rightPlane.materials = @[material];
        
        self.camera.focalLength = 70;
        
        
 
    }
    return _threeScene;
}

- (SCNView *)threeDscnView {
    if (!_threeDscnView) {
        _threeDscnView = [[SCNView alloc] init];
        UITapGestureRecognizer *sceneTap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                  action:@selector(onClickTap:)];
        sceneTap.numberOfTapsRequired = 1;
        sceneTap.numberOfTouchesRequired = 1;
        [_threeDscnView addGestureRecognizer:sceneTap];
        _threeDscnView.scene = self.threeScene;
        _threeDscnView.backgroundColor = [UIColor grayColor];
        _threeDscnView.allowsCameraControl = YES;
        _threeDscnView.showsStatistics = YES;
        _threeDscnView.autoenablesDefaultLighting = YES;
        _threeDscnView.playing = YES;
        
    }
    return _threeDscnView;
}

- (MYRestartView *)pageView {
    if (!_pageView) {
        _pageView = [[MYRestartView alloc] init];
        [_pageView setTextName:@"欢迎欢迎\n点击任意一个面开始游戏"];
        [_pageView setButtonName:@"进入游戏"];
        __block ViewController *weakSelf = self;
        _pageView.clickBlock = ^{
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.pageView.alpha = 0;
            } completion:^(BOOL finished) {
                weakSelf.pageView.hidden = YES;
            }];
        };
    }
    return _pageView;
}

@end
