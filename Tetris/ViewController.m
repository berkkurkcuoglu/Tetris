//
//  ViewController.m
//  Tetris
//
//  Created by berk on 4/6/17.
//  Copyright © 2017 berk. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(simulate:)];
    [_displayLink setPreferredFramesPerSecond:10];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];

    
    NSInteger width = [_gameView frame].size.width/16;
    NSInteger height = [_gameView frame].size.height/32;
    _cells = [[NSMutableArray alloc] init];
    for(int i=0; i < 32; i++){
        for(int j=0; j < 16; j++){
            Cell *cell;
            if( i == 0 && j==0)
                cell = [[Cell alloc] initWithFrame:CGRectMake(j * width + width/2, i * height + height/2 , width, height)];
            else if(i==0)
                cell = [[Cell alloc] initWithFrame:CGRectMake((j * (width+2)) + width/2, i * height + height/2 , width, height)];
            else if(j==0)
                cell = [[Cell alloc] initWithFrame:CGRectMake(j * width + width/2, (i * (height+2)) + height/2, width, height)];
            else
               cell = [[Cell alloc] initWithFrame:CGRectMake((j * (width+2)) + width/2, (i * (height+2)) + height/2, width, height)];
            //NSLog(@"X:%ld Y:%ld W:%ld H:%ld",j*width,i*height,(long)width,(long)height);
            cell.xIndex = j;
            cell.yIndex = i;
            cell.full = false;
            [cell setBackgroundColor:[UIColor blueColor]];
            [_cells addObject:cell];
            [_gameView addSubview:cell];
        }
    }
    [self createTetromino];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)simulate:(CADisplayLink *)sender{
    //[self createTetromino];
    if([self movePossible])
        [self moveTetromino];
    else
        [self createTetromino];
}

-(void) createTetromino{
    u_int32_t randomNumber = arc4random_uniform(7);
    switch (randomNumber) {
        case 0: //I-Block
            _tetromino = [[NSMutableArray alloc] init];
            [_tetromino addObject:[self getCell:8 :0]];
            [_tetromino addObject:[self getCell:8 :1]];
            [_tetromino addObject:[self getCell:8 :2]];
            [_tetromino addObject:[self getCell:8 :3]];
            for(Cell *cell in _tetromino){
                [cell setBackgroundColor:[UIColor redColor]];
                [cell setFull:true];
            }
            break;
        case 1: //J-Block
            _tetromino = [[NSMutableArray alloc] init];
            [_tetromino addObject:[self getCell:8 :0]];
            [_tetromino addObject:[self getCell:8 :1]];
            [_tetromino addObject:[self getCell:8 :2]];
            [_tetromino addObject:[self getCell:7 :2]];
            for(Cell *cell in _tetromino){
                [cell setBackgroundColor:[UIColor redColor]];
                [cell setFull:true];
            }

            break;
        case 2: //L-Block
            _tetromino = [[NSMutableArray alloc] init];
            [_tetromino addObject:[self getCell:8 :0]];
            [_tetromino addObject:[self getCell:8 :1]];
            [_tetromino addObject:[self getCell:8 :2]];
            [_tetromino addObject:[self getCell:9 :2]];
            for(Cell *cell in _tetromino){
                [cell setBackgroundColor:[UIColor redColor]];
                [cell setFull:true];
            }

            break;
        case 3: //O-Block
            _tetromino = [[NSMutableArray alloc] init];
            [_tetromino addObject:[self getCell:8 :0]];
            [_tetromino addObject:[self getCell:8 :1]];
            [_tetromino addObject:[self getCell:7 :0]];
            [_tetromino addObject:[self getCell:7 :1]];
            for(Cell *cell in _tetromino){
                [cell setBackgroundColor:[UIColor redColor]];
                [cell setFull:true];
            }

            break;
        case 4: //S-Block
            _tetromino = [[NSMutableArray alloc] init];
            [_tetromino addObject:[self getCell:8 :0]];
            [_tetromino addObject:[self getCell:9 :0]];
            [_tetromino addObject:[self getCell:8 :1]];
            [_tetromino addObject:[self getCell:7 :1]];
            for(Cell *cell in _tetromino){
                [cell setBackgroundColor:[UIColor redColor]];
                [cell setFull:true];
            }

            break;
        case 5: //T-Block
            _tetromino = [[NSMutableArray alloc] init];
            [_tetromino addObject:[self getCell:8 :0]];
            [_tetromino addObject:[self getCell:7 :0]];
            [_tetromino addObject:[self getCell:9 :0]];
            [_tetromino addObject:[self getCell:8 :1]];
            for(Cell *cell in _tetromino){
                [cell setBackgroundColor:[UIColor redColor]];
                [cell setFull:true];
            }

            break;
        case 6: //Z-Block
            _tetromino = [[NSMutableArray alloc] init];
            [_tetromino addObject:[self getCell:8 :0]];
            [_tetromino addObject:[self getCell:7 :0]];
            [_tetromino addObject:[self getCell:8 :1]];
            [_tetromino addObject:[self getCell:9 :1]];
            for(Cell *cell in _tetromino){
                [cell setBackgroundColor:[UIColor redColor]];
                [cell setFull:true];
            }

            break;
    }
}
-(BOOL) movePossible{
    BOOL result = true;
    for(Cell* cell in _tetromino){
        if(cell.yIndex >= 31)
            result = false;
    }
    if([self getNextCell:[self deepestCell]].full)
        result = false;
    return result;
}

-(void) moveTetromino{
    for(Cell *cell in _tetromino){
        [cell setFull:false];
        [cell setBackgroundColor:[UIColor blueColor]];
    }
    for(int i = 0; i < [_tetromino count];i++){
        [_tetromino replaceObjectAtIndex:i withObject:[self getNextCell:[_tetromino objectAtIndex:i]]];
    }
    for(Cell *cell in _tetromino){
        [cell setFull:true];
        [cell setBackgroundColor:[UIColor redColor]];
    }
}

-(Cell*) deepestCell{
    Cell *deep = [_tetromino objectAtIndex:0];
    for(Cell *cell in _tetromino){
        if( cell.yIndex > deep.yIndex){
            deep = cell;
        }
    }
    return deep;
}

-(Cell*) getNextCell:(Cell*) currentCell{
    return [self getCell:currentCell.xIndex :currentCell.yIndex+1];
}

-(Cell*) getCell:(int)x :(int)y{
    for(Cell *cell in _cells){
        if(cell.xIndex == x && cell.yIndex == y){
            return cell;
        }
    }
    return nil;
}
- (IBAction)upwards:(id)sender {
}
- (IBAction)rightwards:(id)sender {
}
- (IBAction)leftwards:(id)sender {
}
- (IBAction)downwards:(id)sender {
}
- (IBAction)goLeft:(id)sender {
}
- (IBAction)goRight:(id)sender {
}

@end
