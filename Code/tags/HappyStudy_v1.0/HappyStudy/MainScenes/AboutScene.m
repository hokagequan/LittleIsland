//
//  AboutScene.m
//  HappyStudy
//
//  Created by Quan on 14/11/4.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "AboutScene.h"
#import "GlobalUtil.h"

@interface AboutScene ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) SKView *parentView;

@end

@implementation AboutScene

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (AboutScene *)sceneFromNib {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"AboutScene"
                                                   owner:nil
                                                 options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[AboutScene class]]) {
            AboutScene *scene = (AboutScene *)view;
            scene.textView.text = [GlobalUtil gameInfoWithKey:@"About"];
            scene.textView.font = [UIFont fontWithName:FONT_NAME_HP size:17];
            scene.textView.textColor = colorRGB(180, 100, 50, 1);
            return scene;
        }
    }
    
    return nil;
}

- (void)showInView:(SKView *)view {
    self.parentView = view;
    self.parentView.scene.userInteractionEnabled = NO;
    
    CGRect frame = self.frame;
    frame.origin = CGPointMake(0,0);
    frame.size = view.bounds.size;
    self.frame = frame;
    
    [view addSubview:self];
    [view bringSubviewToFront:self];
}

- (IBAction)clickClose:(id)sender {
    self.parentView.scene.userInteractionEnabled = YES;
    [self removeFromSuperview];
}

@end
