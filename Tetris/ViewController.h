//
//  ViewController.h
//  Tetris
//
//  Created by berk on 4/6/17.
//  Copyright © 2017 berk. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Cell.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *gameView;
@property (strong, nonatomic) IBOutlet UIButton *upButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *downButton;
@property (strong, nonatomic) IBOutlet UIButton *goLeftButton;
@property (strong, nonatomic) IBOutlet UIButton *goRightButton;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, strong) NSMutableArray *tetromino;
@property (nonatomic) int type;
@property (nonatomic) Cell *tetroCenter;
-(void)simulate:(CADisplayLink *)sender;
@end

