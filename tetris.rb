# @Author: Akshay Bhardwj
# @Description: Modified Tetris designed during a course project of "Programming Languages Course"
# *This Tetris allows user to cheat using c (100 pts penalty applied) and people can flip the pieces

class MyTetris < Tetris
  # your enhancements here
  def key_bindings
    @root.bind('u',proc {@board.rotate180})
    @root.bind('c',proc {@board.cheat})
    super
  end
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end
end

class MyPiece < Piece
  # All pieces available in Tetris available here
  All_My_Pieces = [[[[0, 0], [1, 0], [0, 1], [1, 1]]],  # square (only needs one)
               rotations([[0, 0], [-1, 0], [1, 0], [0, -1]]), # T
               [[[0, 0], [-1, 0], [1, 0], [2, 0]], # long (only needs two)
               [[0, 0], [0, -1], [0, 1], [0, 2]]],
               rotations([[0, 0], [0, -1], [0, 1], [1, 1]]), # L
               rotations([[0, 0], [0, -1], [0, 1], [-1, 1]]), # inverted L
               rotations([[0, 0], [-1, 0], [0, -1], [1, -1]]), # S
               rotations([[0, 0], [1, 0], [0, -1], [-1, -1]]), # Z
                   [[[0,0],[-1,0],[-2,0],[1,0],[2,0]],
                    [[0,0],[0,-1],[0,-2],[0,1],[0,2]]], # 5-long New 2
                   rotations([[0,0], [-1,0], [1,0], [0,1],[1,1]]), #New 1 
                   rotations([[0,0], [0,-1], [1,0]]) # New 3
                  ]
  # Modified functions
  def self.next_piece (board)
    if board.cheat_code 
      board.cheat_code = false
      MyPiece.new([[[[0,0]]]].sample,board)
    else
      MyPiece.new(All_My_Pieces.sample, board)
    end
  end

end

class MyBoard < Board
  attr_accessor :cheat_code
  # Modified functions
  def next_piece
    @current_block = MyPiece.next_piece(self)
    @current_pos = nil
  end
  def cheat
    if !game_over? and @game.is_running?
      if @score >= 100 and !self.cheat_code 
        self.cheat_code = true
        @score = @score - 100
      end
    end
  end
  def rotate180
    if !game_over? and @game.is_running?
      @current_block.move(0,0,2)
    end
  end

  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    si = locations.length - 1
    (0..si).each{|index| 
      current = locations[index];
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
      @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end
end
#To help each game of Tetris be unique
srand
