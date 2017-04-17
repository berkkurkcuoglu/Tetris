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
    [_displayLink setPreferredFramesPerSecond:5];
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
    
    [self checkRows];
    
}

-(void) createTetromino{
    u_int32_t randomNumber = 3;//arc4random_uniform(7);
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
            _type = 0;
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
            _type = 1;
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
            _type = 2;
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
            _type = 3;
            break;
        case 4: //S-Block
            _tetromino = [[NSMutableArray alloc] init];
            [_tetromino addObject:[self getCell:9 :0]];
            [_tetromino addObject:[self getCell:8 :0]];
            [_tetromino addObject:[self getCell:8 :1]];
            [_tetromino addObject:[self getCell:7 :1]];
            for(Cell *cell in _tetromino){
                [cell setBackgroundColor:[UIColor redColor]];
                [cell setFull:true];
            }
            _type = 4;
            break;
        case 5: //T-Block
            _tetromino = [[NSMutableArray alloc] init];
            [_tetromino addObject:[self getCell:7 :0]];
            [_tetromino addObject:[self getCell:8 :0]];
            [_tetromino addObject:[self getCell:9 :0]];
            [_tetromino addObject:[self getCell:8 :1]];
            for(Cell *cell in _tetromino){
                [cell setBackgroundColor:[UIColor redColor]];
                [cell setFull:true];
            }
            _type = 5;
            break;
        case 6: //Z-Block
            _tetromino = [[NSMutableArray alloc] init];
            [_tetromino addObject:[self getCell:7 :0]];
            [_tetromino addObject:[self getCell:8 :0]];
            [_tetromino addObject:[self getCell:8 :1]];
            [_tetromino addObject:[self getCell:9 :1]];
            for(Cell *cell in _tetromino){
                [cell setBackgroundColor:[UIColor redColor]];
                [cell setFull:true];
            }
            _type = 6;
            break;
    }
}

-(void) checkRows{
    for( int i= 31; i>= 0 ; i--){
        int counter =0;
        for(int j=0; j<16 ; j++){
            if([self getCell:j :i].full)
                counter++;
        }
        if(counter >= 15)
            [self moveRows:i];
    }
}

-(void) moveRows:(int) row{
    for(int j=0; j<16 ; j++){
        [self getCell:j :row].full = false;
        [[self getCell:j :row] setBackgroundColor:[UIColor blueColor]];
    }
    for(Cell *cell in _tetromino){
        [cell setFull:false];
        [cell setBackgroundColor:[UIColor blueColor]];
    }
    for(int i= row; i >= 0 ; i--){
        for(int j=0; j<16 ; j++){
            if(![self inTetromino:[self getCell:j :i] ]){
                [self getCell:j :row].full = false;
                [[self getCell:j :row] setBackgroundColor:[UIColor blueColor]];
                [self getNextCell:[self getCell:j :row]].full = true;
                [[self getNextCell:[self getCell:j :row]] setBackgroundColor:[UIColor redColor]];
            }
        }
    }
}
-(BOOL) movePossible{
    BOOL result = true;
    for(Cell* cell in _tetromino){
        if(cell.yIndex >= 31)
            result = false;
        if(![self inTetromino:[self getNextCell:cell]] && [self getNextCell:cell].full)
            result = false;
    }
    return result;
}
-(BOOL) inTetromino:(Cell*) currentCell{
    BOOL result = false;
    for(Cell* cell in _tetromino){
        if(cell == currentCell)
            result = true;
    }
    return result;
}

-(BOOL) rightPossible{
    BOOL result = true;
    for(Cell* cell in _tetromino){
        if(cell.xIndex >= 15)
            result = false;
    }
    if([self getRightCell:[self rightMostCell]].full)
        result = false;
    return result;
}

-(BOOL) leftPossible{
    BOOL result = true;
    for(Cell* cell in _tetromino){
        if(cell.xIndex <= 0)
            result = false;
    }
    if([self getLeftCell:[self leftMostCell]].full)
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

-(Cell*) rightMostCell{
    Cell *right = [_tetromino objectAtIndex:0];
    for(Cell *cell in _tetromino){
        if( cell.xIndex > right.xIndex){
            right = cell;
        }
    }
    return right;
}

-(Cell*) leftMostCell{
    Cell *left = [_tetromino objectAtIndex:0];
    for(Cell *cell in _tetromino){
        if( cell.xIndex < left.xIndex){
            left = cell;
        }
    }
    return left;
}
-(Cell*) getNextCell:(Cell*) currentCell{
    return [self getCell:currentCell.xIndex :currentCell.yIndex+1];
}

-(Cell*) getRightCell:(Cell*) currentCell{
    if(currentCell.xIndex+1 > 15)
        return [self getCell:currentCell.xIndex :currentCell.yIndex];
    else
        return [self getCell:currentCell.xIndex+1 :currentCell.yIndex];
}

-(Cell*) getLeftCell:(Cell*) currentCell{
    if(currentCell.xIndex-1 < 0)
        return [self getCell:currentCell.xIndex :currentCell.yIndex];
    else
        return [self getCell:currentCell.xIndex-1 :currentCell.yIndex];
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
    for(Cell *cell in _tetromino){
        [cell setFull:false];
        [cell setBackgroundColor:[UIColor blueColor]];
    }
    _tetroCenter = [_tetromino objectAtIndex:1];
    int xIndex = _tetroCenter.xIndex;
    int yIndex = _tetroCenter.yIndex;
    switch (_type) {
        case 0: //I-Block
            [_tetromino replaceObjectAtIndex:0 withObject:[self getCell: xIndex:yIndex-1]];
            [_tetromino replaceObjectAtIndex:1 withObject:[self getCell: xIndex:yIndex]];
            [_tetromino replaceObjectAtIndex:2 withObject:[self getCell: xIndex:yIndex+1]];
            [_tetromino replaceObjectAtIndex:3 withObject:[self getCell: xIndex:yIndex+2]];
            break;
        case 1: //J-Block
            [_tetromino replaceObjectAtIndex:0 withObject:[self getCell: xIndex:yIndex-1]];
            [_tetromino replaceObjectAtIndex:1 withObject:[self getCell: xIndex:yIndex]];
            [_tetromino replaceObjectAtIndex:2 withObject:[self getCell: xIndex:yIndex+1]];
            [_tetromino replaceObjectAtIndex:3 withObject:[self getCell: xIndex-1:yIndex+1]];
            break;
        case 2: //L-Block
            [_tetromino replaceObjectAtIndex:0 withObject:[self getCell: xIndex:yIndex-1]];
            [_tetromino replaceObjectAtIndex:1 withObject:[self getCell: xIndex:yIndex]];
            [_tetromino replaceObjectAtIndex:2 withObject:[self getCell: xIndex:yIndex+1]];
            [_tetromino replaceObjectAtIndex:3 withObject:[self getCell: xIndex+1:yIndex+1]];
            break;
        case 3: //O-Block
            break;
        case 4: //S-Block
            [_tetromino replaceObjectAtIndex:0 withObject:[self getCell: xIndex+1:yIndex]];
            [_tetromino replaceObjectAtIndex:1 withObject:[self getCell: xIndex:yIndex]];
            [_tetromino replaceObjectAtIndex:2 withObject:[self getCell: xIndex:yIndex+1]];
            [_tetromino replaceObjectAtIndex:3 withObject:[self getCell: xIndex-1:yIndex+1]];
            break;
        case 5: //T-Block
            [_tetromino replaceObjectAtIndex:0 withObject:[self getCell: xIndex-1:yIndex]];
            [_tetromino replaceObjectAtIndex:1 withObject:[self getCell: xIndex:yIndex]];
            [_tetromino replaceObjectAtIndex:2 withObject:[self getCell: xIndex+1:yIndex]];
            [_tetromino replaceObjectAtIndex:3 withObject:[self getCell: xIndex:yIndex+1]];
            break;
        case 6: //Z-Block
            [_tetromino replaceObjectAtIndex:0 withObject:[self getCell: xIndex-1:yIndex]];
            [_tetromino replaceObjectAtIndex:1 withObject:[self getCell: xIndex:yIndex]];
            [_tetromino replaceObjectAtIndex:2 withObject:[self getCell: xIndex:yIndex+1]];
            [_tetromino replaceObjectAtIndex:3 withObject:[self getCell: xIndex+1:yIndex+1]];
            break;
    }
    for(Cell *cell in _tetromino){
        [cell setFull:true];
        [cell setBackgroundColor:[UIColor redColor]];
    }
}
- (IBAction)rightwards:(id)sender {
    for(Cell *cell in _tetromino){
        [cell setFull:false];
        [cell setBackgroundColor:[UIColor blueColor]];
    }
    _tetroCenter = [_tetromino objectAtIndex:1];
    int xIndex = _tetroCenter.xIndex;
    int yIndex = _tetroCenter.yIndex;
    switch (_type) {
        case 0: //I-Block
            [_tetromino replaceObjectAtIndex:0 withObject:[self getCell: xIndex-1:yIndex]];
            [_tetromino replaceObjectAtIndex:1 withObject:[self getCell: xIndex:yIndex]];
            [_tetromino replaceObjectAtIndex:2 withObject:[self getCell: xIndex+1:yIndex]];
            [_tetromino replaceObjectAtIndex:3 withObject:[self getCell: xIndex+2:yIndex]];
            break;
        case 1: //J-Block
            [_tetromino replaceObjectAtIndex:0 withObject:[self getCell: xIndex:yIndex-1]];
            [_tetromino replaceObjectAtIndex:1 withObject:[self getCell: xIndex:yIndex]];
            [_tetromino replaceObjectAtIndex:2 withObject:[self getCell: xIndex+1:yIndex]];
            [_tetromino replaceObjectAtIndex:3 withObject:[self getCell: xIndex+2:yIndex]];
            break;
        case 2: //L-Block
            [_tetromino replaceObjectAtIndex:0 withObject:[self getCell: xIndex:yIndex+1]];
            [_tetromino replaceObjectAtIndex:1 withObject:[self getCell: xIndex:yIndex]];
            [_tetromino replaceObjectAtIndex:2 withObject:[self getCell: xIndex+1:yIndex]];
            [_tetromino replaceObjectAtIndex:3 withObject:[self getCell: xIndex+2:yIndex]];
            break;
        case 3: //O-Block
            break;
        case 4: //S-Block
            [_tetromino replaceObjectAtIndex:0 withObject:[self getCell: xIndex:yIndex-1]];
            [_tetromino replaceObjectAtIndex:1 withObject:[self getCell: xIndex:yIndex]];
            [_tetromino replaceObjectAtIndex:2 withObject:[self getCell: xIndex+1:yIndex]];
            [_tetromino replaceObjectAtIndex:3 withObject:[self getCell: xIndex+1:yIndex+1]];
            break;
        case 5: //T-Block
            [_tetromino replaceObjectAtIndex:0 withObject:[self getCell: xIndex:yIndex-1]];
            [_tetromino replaceObjectAtIndex:1 withObject:[self getCell: xIndex:yIndex]];
            [_tetromino replaceObjectAtIndex:2 withObject:[self getCell: xIndex:yIndex+1]];
            [_tetromino replaceObjectAtIndex:3 withObject:[self getCell: xIndex+1:yIndex]];
            break;
        case 6: //Z-Block
            [_tetromino replaceObjectAtIndex:0 withObject:[self getCell: xIndex:yIndex-1]];
            [_tetromino replaceObjectAtIndex:1 withObject:[self getCell: xIndex:yIndex]];
            [_tetromino replaceObjectAtIndex:2 withObject:[self getCell: xIndex-1:yIndex]];
            [_tetromino replaceObjectAtIndex:3 withObject:[self getCell: xIndex-1:yIndex+1]];
            break;
    }
    for(Cell *cell in _tetromino){
        [cell setFull:true];
        [cell setBackgroundColor:[UIColor redColor]];
    }

}
- (IBAction)leftwards:(id)sender {
    for(Cell *cell in _tetromino){
        [cell setFull:false];
        [cell setBackgroundColor:[UIColor blueColor]];
    }
    _tetroCenter = [_tetromino objectAtIndex:1];
    int xIndex = _tetroCenter.xIndex;
    int yIndex = _tetroCenter.yIndex;
    switch (_type) {
        case 0: //I-Block
            [_tetromino replaceObjectAtIndex:0 withObject:[self getCell: xIndex-1:yIndex]];
            [_tetromino replaceObjectAtIndex:1 withObject:[self getCell: xIndex:yIndex]];
            [_tetromino replaceObjectAtIndex:2 withObject:[self getCell: xIndex+1:yIndex]];
            [_tetromino replaceObjectAtIndex:3 withObject:[self getCell: xIndex+2:yIndex]];
            break;
        case 1: //J-Block
            [_tetromino replaceObjectAtIndex:0 withObject:[self getCell: xIndex-1:yIndex]];
            [_tetromino replaceObjectAtIndex:1 withObject:[self getCell: xIndex:yIndex]];
            [_tetromino replaceObjectAtIndex:2 withObject:[self getCell: xIndex+1:yIndex]];
            [_tetromino replaceObjectAtIndex:3 withObject:[self getCell: xIndex+1:yIndex+1]];
            break;
        case 2: //L-Block
            [_tetromino replaceObjectAtIndex:0 withObject:[self getCell: xIndex-1:yIndex]];
            [_tetromino replaceObjectAtIndex:1 withObject:[self getCell: xIndex:yIndex]];
            [_tetromino replaceObjectAtIndex:2 withObject:[self getCell: xIndex+1:yIndex]];
            [_tetromino replaceObjectAtIndex:3 withObject:[self getCell: xIndex+1:yIndex-1]];
            break;
        case 3: //O-Block
            break;
        case 4: //S-Block
            [_tetromino replaceObjectAtIndex:0 withObject:[self getCell: xIndex:yIndex-1]];
            [_tetromino replaceObjectAtIndex:1 withObject:[self getCell: xIndex:yIndex]];
            [_tetromino replaceObjectAtIndex:2 withObject:[self getCell: xIndex+1:yIndex]];
            [_tetromino replaceObjectAtIndex:3 withObject:[self getCell: xIndex+1:yIndex+1]];
            break;
        case 5: //T-Block
            [_tetromino replaceObjectAtIndex:0 withObject:[self getCell: xIndex-1:yIndex]];
            [_tetromino replaceObjectAtIndex:1 withObject:[self getCell: xIndex:yIndex]];
            [_tetromino replaceObjectAtIndex:2 withObject:[self getCell: xIndex:yIndex-1]];
            [_tetromino replaceObjectAtIndex:3 withObject:[self getCell: xIndex:yIndex+1]];
            break;
        case 6: //Z-Block
            [_tetromino replaceObjectAtIndex:0 withObject:[self getCell: xIndex:yIndex-1]];
            [_tetromino replaceObjectAtIndex:1 withObject:[self getCell: xIndex:yIndex]];
            [_tetromino replaceObjectAtIndex:2 withObject:[self getCell: xIndex-1:yIndex]];
            [_tetromino replaceObjectAtIndex:3 withObject:[self getCell: xIndex-1:yIndex+1]];
            break;
    }
    for(Cell *cell in _tetromino){
        [cell setFull:true];
        [cell setBackgroundColor:[UIColor redColor]];
    }
}
- (IBAction)downwards:(id)sender {
    for(Cell *cell in _tetromino){
        [cell setFull:false];
        [cell setBackgroundColor:[UIColor blueColor]];
    }
    _tetroCenter = [_tetromino objectAtIndex:1];
    int xIndex = _tetroCenter.xIndex;
    int yIndex = _tetroCenter.yIndex;
    switch (_type) {
        case 0: //I-Block
            break;
        case 1: //J-Block
            [_tetromino replaceObjectAtIndex:0 withObject:[self getCell: xIndex-1:yIndex]];
            [_tetromino replaceObjectAtIndex:1 withObject:[self getCell: xIndex:yIndex]];
            [_tetromino replaceObjectAtIndex:2 withObject:[self getCell: xIndex:yIndex+1]];
            [_tetromino replaceObjectAtIndex:3 withObject:[self getCell: xIndex:yIndex+2]];
            break;
        case 2: //L-Block
            [_tetromino replaceObjectAtIndex:0 withObject:[self getCell: xIndex+1:yIndex]];
            [_tetromino replaceObjectAtIndex:1 withObject:[self getCell: xIndex:yIndex]];
            [_tetromino replaceObjectAtIndex:2 withObject:[self getCell: xIndex:yIndex+1]];
            [_tetromino replaceObjectAtIndex:3 withObject:[self getCell: xIndex:yIndex+2]];
            break;
        case 3: //O-Block
            break;
        case 4: //S-Block
            [_tetromino replaceObjectAtIndex:0 withObject:[self getCell: xIndex-1:yIndex]];
            [_tetromino replaceObjectAtIndex:1 withObject:[self getCell: xIndex:yIndex]];
            [_tetromino replaceObjectAtIndex:2 withObject:[self getCell: xIndex:yIndex+1]];
            [_tetromino replaceObjectAtIndex:3 withObject:[self getCell: xIndex+1:yIndex+1]];
            break;
        case 5: //T-Block
            [_tetromino replaceObjectAtIndex:0 withObject:[self getCell: xIndex-1:yIndex]];
            [_tetromino replaceObjectAtIndex:1 withObject:[self getCell: xIndex:yIndex]];
            [_tetromino replaceObjectAtIndex:2 withObject:[self getCell: xIndex+1:yIndex]];
            [_tetromino replaceObjectAtIndex:3 withObject:[self getCell: xIndex:yIndex-1]];
            break;
        case 6: //Z-Block
            [_tetromino replaceObjectAtIndex:0 withObject:[self getCell: xIndex+1:yIndex]];
            [_tetromino replaceObjectAtIndex:1 withObject:[self getCell: xIndex:yIndex]];
            [_tetromino replaceObjectAtIndex:2 withObject:[self getCell: xIndex:yIndex+1]];
            [_tetromino replaceObjectAtIndex:3 withObject:[self getCell: xIndex-1:yIndex+1]];
            break;
    }
    for(Cell *cell in _tetromino){
        [cell setFull:true];
        [cell setBackgroundColor:[UIColor redColor]];
    }

}
- (IBAction)goLeft:(id)sender {
    if([self leftPossible]){
        for(Cell *cell in _tetromino){
            [cell setFull:false];
            [cell setBackgroundColor:[UIColor blueColor]];
        }
        for(int i = 0; i < [_tetromino count];i++){
            [_tetromino replaceObjectAtIndex:i withObject:[self getLeftCell:[_tetromino objectAtIndex:i]]];
        }
        for(Cell *cell in _tetromino){
            [cell setFull:true];
            [cell setBackgroundColor:[UIColor redColor]];
        }
    }
}
- (IBAction)goRight:(id)sender {
    if([self rightPossible]){
        for(Cell *cell in _tetromino){
            [cell setFull:false];
            [cell setBackgroundColor:[UIColor blueColor]];
        }
        for(int i = 0; i < [_tetromino count];i++){
            [_tetromino replaceObjectAtIndex:i withObject:[self getRightCell:[_tetromino objectAtIndex:i]]];
        }
        for(Cell *cell in _tetromino){
            [cell setFull:true];
            [cell setBackgroundColor:[UIColor redColor]];
        }
    }
}

@end
