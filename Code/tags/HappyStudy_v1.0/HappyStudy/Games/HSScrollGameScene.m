//
//  HSScrollGameScene.m
//  HappyStudy
//
//  Created by Q on 14/10/28.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HSScrollGameScene.h"
#import "IndexControllerCell.h"
#import "AccountMgr.h"

#define MoveSpeed 100

@interface HSScrollGameScene ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate>

@property (strong, nonatomic) UIView *uikitContainer;
@property (strong, nonatomic) UICollectionView *indexController;
@property (strong, nonatomic) UIButton *heart;

@property (strong, nonatomic) NSMutableArray *layers;
@property (nonatomic) BOOL worldMovedForUpdate;

@end

@implementation HSScrollGameScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _layers = [NSMutableArray arrayWithCapacity:HSSWorldLayerCount];
        for (int i = 0; i < HSSWorldLayerCount; i++) {
            SKNode *layer = [[SKNode alloc] init];
            layer.zPosition = i - HSSWorldLayerCount;
            layer.userInteractionEnabled = NO;
            [self addChild:layer];
            [_layers addObject:layer];
        }
    }
    
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    [self addIndexController];
    [self resetAnalyze];
    
    [self addObserver:self
           forKeyPath:@"curIndex"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:nil];
    [self addObserver:self
           forKeyPath:@"worldMovedForUpdate"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:nil];
}

- (void)willMoveFromView:(SKView *)view {
    [self clearIndexController];
    [self removeObserver:self forKeyPath:@"curIndex"];
    [self removeObserver:self forKeyPath:@"worldMovedForUpdate"];
    
    [super willMoveFromView:view];
}

- (void)addIndexController {
    _uikitContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 16, self.size.width, 120)];
    _uikitContainer.backgroundColor = [UIColor clearColor];
    _uikitContainer.clipsToBounds = YES;
    [self.view addSubview:_uikitContainer];
    
    CGRect naviFrame = CGRectMake(74, 8, 918, 99);
    UIImageView *bgIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navi_bg"]];
    bgIV.frame = naviFrame;
    [_uikitContainer addSubview:bgIV];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 100, 0, 100);
//    layout.itemSize = CGSizeMake(50, 99);
//    layout.minimumInteritemSpacing = 0;
//    layout.minimumLineSpacing = 68;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _indexController = [[UICollectionView alloc] initWithFrame:CGRectMake(naviFrame.origin.x,
                                                                          naviFrame.origin.y,
                                                                          naviFrame.size.width - 30,
                                                                          naviFrame.size.height)
                                          collectionViewLayout:layout];
    _indexController.backgroundColor = [UIColor whiteColor];
    _indexController.showsHorizontalScrollIndicator = NO;
    _indexController.showsVerticalScrollIndicator = NO;
    _indexController.delegate = self;
    _indexController.dataSource = self;
    _indexController.backgroundColor = [UIColor clearColor];
    _indexController.layer.cornerRadius = 40.;
    _indexController.layer.masksToBounds = YES;
    [_uikitContainer addSubview:_indexController];
    
    [_indexController registerNib:[UINib nibWithNibName:@"IndexControllerCell" bundle:nil]
       forCellWithReuseIdentifier:@"IndexControllerCell"];
    
    _heart = [UIButton buttonWithType:UIButtonTypeCustom];
    _heart.userInteractionEnabled = NO;
    _heart.frame = CGRectMake(30, 0, 135, 115);
    [_heart setBackgroundImage:[UIImage imageNamed:@"heart"]
                      forState:UIControlStateNormal];
    [_heart setTitle:[NSString stringWithFormat:@"%@", @([AccountMgr sharedInstance].user.score)]
            forState:UIControlStateNormal];
    _heart.titleLabel.font = [UIFont fontWithName:FONT_NAME_HP size:60.];
    _heart.titleEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, 0);
    [_uikitContainer addSubview:_heart];
    
    [self performSelector:@selector(setDefaultSelection)
               withObject:nil
               afterDelay:0.5];
}

- (void)addNode:(SKNode *)node atWorldLayer:(HSSWorldLayer)layer {
    SKNode *layerNode = self.layers[layer];
    [layerNode addChild:node];
}

- (void)animationCorrect:(SKNode *)node {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Environment"];
    SKSpriteNode *heart = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"heart"]];
    [heart setScale:0.];
    heart.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    [self addNode:heart atWorldLayer:HSSWorldLayerControl];
    
    SKAction *zoomOut = [SKAction scaleTo:1.5 duration:0.5];
    SKAction *move = [SKAction moveTo:CGPointMake(70, 700) duration:0.3];
    SKAction *zoomIn = [SKAction scaleTo:0. duration:0.3];
    SKAction *group = [SKAction group:@[move, zoomIn]];
    [heart runAction:[SKAction sequence:@[zoomOut, group]] completion:^{
        [heart removeFromParent];
        [AccountMgr sharedInstance].user.score++;
        [self refreshScore];
    }];
}

- (void)clearIndexController {
    [self.uikitContainer removeFromSuperview];
}

- (void)expandIndexController {
    NSMutableArray *insertItems = [NSMutableArray array];
    NSInteger totalCount = [self currentTotalCount];
    for (NSInteger i = self.pageCount; i < totalCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [insertItems addObject:indexPath];
    }
    self.pageCount = totalCount;
    [self.indexController insertItemsAtIndexPaths:insertItems];
}

- (void)focusOn:(NSInteger)index oldIndex:(NSInteger)oldIndex {
    if ([self currentTotalCount] == 0) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldIndex inSection:0];
    [self.indexController selectItemAtIndexPath:indexPath
                                       animated:YES
                                 scrollPosition:UICollectionViewScrollPositionRight];
//    [self collectionView:self.indexController didSelectItemAtIndexPath:indexPath];
//    if (index != oldIndex) {
//        [self collectionView:self.indexController didDeselectItemAtIndexPath:oldIndexPath];
//    }
    
    IndexControllerCell *oldCell = (IndexControllerCell *)[self.indexController cellForItemAtIndexPath:oldIndexPath];
    oldCell.titleLab.textColor = colorRGB(255, 240, 210, 1);
    IndexControllerCell *newCell = (IndexControllerCell *)[self.indexController cellForItemAtIndexPath:indexPath];
    newCell.titleLab.textColor = colorRGB(255, 0, 0, 1);
    
//    self.worldMovedForUpdate = YES;
    if (self.scrollWorld) {
        CGPoint targetPos = CGPointMake(-self.curIndex * self.frame.size.width, self.position.y);
        SKNode *node = self.layers[HSSWorldLayerCharacter];
        SKAction *action = [SKAction moveTo:targetPos duration:0.5];
        [node runAction:action completion:^{
            [self destroyCharacters];
        }];
    }
}

- (void)finishAll {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Well Done ~, Completed!"
                                                   delegate:self
                                          cancelButtonTitle:@"Replay"
                                          otherButtonTitles:@"Back", nil];
    [alert show];
}

- (SKNode *)layerWith:(HSSWorldLayer)layerID {
    if (layerID >= self.layers.count) {
        return nil;
    }
    
    return self.layers[layerID];
}

- (void)playSoundWrong {
    [self runAction:[SKAction playSoundFileNamed:@"answer_wrong.wav" waitForCompletion:NO]];
}

- (void)playSoundCorrect {
    [self runAction:[SKAction playSoundFileNamed:@"correct.wav" waitForCompletion:NO]];
}

- (void)refreshScore {
    [self.heart setTitle:[NSString stringWithFormat:@"%@", @([AccountMgr sharedInstance].user.score)]
                forState:UIControlStateNormal];
}

- (void)resetAnalyze {
    self.timingDate = [NSDate date];
    self.clickCount = 0;
}

- (void)setDefaultSelection {
    [self focusOn:0 oldIndex:0];
}

- (void)refreshCurrentItem {
    [self resetAnalyze];
    [self addCharacters:self.curIndex];
    [self focusOn:self.curIndex oldIndex:self.curIndex];
}

- (void)startFromBegain {
    if (self.curIndex == 0) {
        [self resetAnalyze];
        [self addCharacters:0];
        [self focusOn:0 oldIndex:0];
    }
    
    self.curIndex = 0;
}

#pragma mark - Subclass Override
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval {
    // 子类继承
}

- (void)addCharacters:(NSInteger)index {
    // 子类继承
}

- (void)destroyCharacters {
    // 子类继承
}

- (NSString *)indexStringWith:(NSInteger)index {
    // 子类继承
    return nil;
}

- (NSInteger)currentTotalCount {
    // 子类继承
    
    return 0;
}

- (void)loadMore {
    // 子类继承
}

- (void)clickBack:(id)sender {
    // 子类继承
}

#pragma mark - Loop
- (void)update:(NSTimeInterval)currentTime {
    [self updateWithTimeSinceLastUpdate:currentTime];
}

- (void)didSimulatePhysics {
    if (self.worldMovedForUpdate) {
        CGPoint targetPos = CGPointMake(-self.curIndex * self.frame.size.width, self.position.y);
        SKNode *node = self.layers[HSSWorldLayerCharacter];
        CGPoint layerPos = node.position;
        if (fabsf(layerPos.x - targetPos.x) <= MoveSpeed) {
            layerPos = targetPos;
            self.worldMovedForUpdate = NO;
        }
        else if (layerPos.x < targetPos.x) {
            layerPos.x += MoveSpeed;
        }
        else if (layerPos.x > targetPos.x) {
            layerPos.x -= MoveSpeed;
        }
        else {
            self.worldMovedForUpdate = NO;
        }
        
        node.position = layerPos;
    }
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self currentTotalCount];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = [self indexStringWith:indexPath.row];
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:FONT_NAME_HP size:62.]}];
    
    return CGSizeMake(size.width, 99);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 64.;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IndexControllerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IndexControllerCell"
                                                                          forIndexPath:indexPath];
    cell.titleLab.text = [self indexStringWith:indexPath.row];
    cell.titleLab.textColor = colorRGB(255, 240, 210, 1);
    if (indexPath.row == self.curIndex) {
        cell.titleLab.textColor = colorRGB(255, 0, 0, 1);
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    IndexControllerCell *cell = (IndexControllerCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.titleLab.textColor = colorRGB(255, 0, 0, 1);
    self.curIndex = indexPath.row;
}

//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    IndexControllerCell *cell = (IndexControllerCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.titleLab.textColor = colorRGB(255, 240, 210, 1);
//}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        if (scrollView.contentOffset.x > scrollView.contentSize.width - scrollView.bounds.size.width + 100) {
            [self loadMore];
        }
    }
}

#pragma mark - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"curIndex"]) {
        NSInteger oldValue = [change[NSKeyValueChangeOldKey] integerValue];
        NSInteger newValue = [change[NSKeyValueChangeNewKey] integerValue];
        if (oldValue == newValue) {
            return;
        }
        
        [self resetAnalyze];
        [self addCharacters:newValue];
        [self focusOn:newValue oldIndex:oldValue];
    }
    else if ([keyPath isEqualToString:@"worldMovedForUpdate"]) {
        BOOL oldValue = [change[NSKeyValueChangeOldKey] boolValue];
        BOOL newValue = [change[NSKeyValueChangeNewKey] boolValue];
        if (oldValue && !newValue) {
            [self destroyCharacters];
        }
    }
}

#pragma mark - AlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self startFromBegain];
    }
    else if (buttonIndex == 1) {
        [self clickBack:nil];
    }
}

@end
