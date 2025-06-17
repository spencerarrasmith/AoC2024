import sys
import os

sample = """
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
""".strip()

UP = 0
RIGHT = 1
DOWN = 2
LEFT = 3

class Guard:
    def __init__(self, ground):
        self.ground = ground
        self.startx = 0
        self.starty = 0
        self.startdir = UP

        self.x = 0
        self.y = 0
        self.dir = UP

        self.count = 0
        self.obstructions = 0

        self.done = False

    def walk(self):
        #print(self.x, self.y, self.dir)
        if self.dir == UP:
            if self.y == 0:
                self.mark()
                self.done = True
            elif self.ground[self.y-1][self.x] == '#':
                self.turn()
            else:
                self.mark()
                self.y -= 1

                
        elif self.dir == RIGHT:
            if self.x == len(self.ground[0]) - 1:
                self.mark()
                self.done = True
            elif self.ground[self.y][self.x+1] == '#':
                self.turn()
            else:
                self.mark()
                self.x += 1

        elif self.dir == DOWN:
            if self.y == len(self.ground) - 1:
                self.mark()
                self.done = True
            elif self.ground[self.y+1][self.x] == '#':
                self.turn()
            else:
                self.mark()
                self.y += 1

        elif self.dir == LEFT:
            if self.x == 0:
                self.mark()
                self.done = True
            elif self.ground[self.y][self.x-1] == '#':
                self.turn()
            else:
                self.mark()
                self.x -= 1
        
        if self.x == self.startx and self.y == self.starty and self.dir == self.startdir:
            self.done = True

    def turn(self):
        self.dir += 1
        self.dir %= 4

    def mark(self):
        if self.ground[self.y][self.x] != 'X':
            self.ground[self.y] = self.ground[self.y][:self.x] + 'X' + self.ground[self.y][self.x+1:]
            self.count += 1

        if self.dir == LEFT:
            self.look_up()
        if self.dir == UP:
            self.look_right()
        if self.dir == RIGHT:
            self.look_down()
        if self.dir == DOWN:
            self.look_left()
  
    def look_up(self):
        line = "".join([self.ground[self.y-G][self.x] for G in range(1, self.y+1)])
        wall = line.find('#')
        if wall > 0 and line[wall-1] == 'X':
            self.obstructions += 1
            print("Looked up!")

    def look_right(self):
        line = self.ground[self.y][self.x+1:]
        wall = line.find('#')
        if wall > 0 and line[wall-1] == 'X':
            self.obstructions += 1
            print("Looked right!")

    def look_down(self):
        line = "".join([self.ground[self.y+G][self.x] for G in range(1, len(self.ground)-self.y)])
        wall = line.find('#')
        if wall > 0 and line[wall-1] == 'X':
            self.obstructions += 1
            print("Looked down!")

    def look_left(self):
        line = self.ground[self.y][:self.x][::-1]
        wall = line.find('#')
        if wall > 0 and line[wall-1] == 'X':
            self.obstructions += 1
            print("Looked left!")

        
def find_guard(txt):
    for y, row in enumerate(txt.split('\n')):
        if row.find('^') > 0:
            return row.find('^'), y

def part1():
    #txt = sample
    f = open('input.txt', 'r')
    txt = f.read()
    f.close()
    
    guard = Guard(txt.split('\n'))
    x,y = find_guard(txt)
    guard.startx = x
    guard.x = x
    guard.starty = y
    guard.y = y

    while not guard.done:
        guard.walk()

    #print("\n".join(guard.ground))
    #print()
    print(guard.count)

    return
    

def part2():
    #txt = sample
    f = open('input.txt', 'r')
    txt = f.read()
    f.close()
    
    guard = Guard(txt.split('\n'))
    x,y = find_guard(txt)
    guard.startx = x
    guard.x = x
    guard.starty = y
    guard.y = y

    while not guard.done:
        guard.walk()

    #print("\n".join(guard.ground))
    #print()
    print(guard.obstructions)

    return


if __name__ == "__main__":
    curdir = os.path.dirname(os.path.abspath(__file__))
    os.chdir(curdir)
    part = sys.argv[1]
    if part == '1':
        part1()
    elif part == '2':
        part2()