$one = 0
$two = 0
$draw = 0

class Board

  def initialize(a)
    @board = Array.new(6) { Array.new(7, a) }
    @options = [0,1,2,3,4,5,6]    # Keep track of columns that are not filled
    @current = [0,0,0,0,0,0,0]    # Keep track of the next move row for each column
  end

  def current
    @board
  end

  def setval(b, c)                #Plays in column b for player c.
    @board[@current[b]][b] = c    # assign either 1 or 2 to the location
    if @current[b] == 5
      @options.delete(b)
    end
    @current[b]+=1
    victor @current[b]-1, b       #check for victory conditions
  end

  def undo(a)
    @current[a] = @current[a]-1
    @board[@current[a]][a] = 0
    if @current[a] == 5
      @options.push(a)
    end
  end

  def victor (a, b) #only check around the last move (a, b)
    #vertical case
    if a > 2 && @board[a][b] == @board[a-1][b] && @board[a][b] == @board[a-2][b] && @board[a][b] == @board[a-3][b]
      return @board[a][b]
    end
    #horizontal case
    sum = 0
    if b+1 < 7 && @board[a][b+1] == @board[a][b]
      sum+=1
      if b+2 < 7 && @board[a][b+2] == @board[a][b]
        sum+=1
        if b+3 < 7 && @board[a][b+3] == @board[a][b]
          sum+=1
          return @board[a][b] if sum == 3
        end
      end
    end
    if b-1 > -1  && @board[a][b-1] == @board[a][b]
      sum+=1
      return @board[a][b] if sum == 3
      if b-2 > -1 && @board[a][b-2] == @board[a][b]
        sum+=1
        return @board[a][b] if sum == 3
        if b-3 > -1 && @board[a][b-3] == @board[a][b]
          sum+=1
          return @board[a][b] if sum == 3
        end
      end
    end

    #right diagonal
    sum = 0
    if a+1 < 6 && b+1 < 7 && @board[a+1][b+1] == @board[a][b]
      sum+=1
      if a+2 < 6 && b+2 < 7 && @board[a+2][b+2] == @board[a][b]
        sum+=1
        if a+3 < 6 && b+3 < 7 && @board[a+3][b+3] == @board[a][b]
          sum+=1
          return @board[a][b] if sum == 3
        end
      end
    end
    if a-1 > -1 && b-1 > -1  && @board[a-1][b-1] == @board[a][b]
      sum+=1
      return @board[a][b] if sum == 3
      if a-2 > -1 && b-2 > -1 && @board[a-2][b-2] == @board[a][b]
        sum+=1
        return @board[a][b] if sum == 3
        if a-3 > -1 && b-3 > -1 && @board[a-3][b-3] == @board[a][b]
          sum+=1
          return @board[a][b] if sum == 3
        end
      end
    end

    #left diagonal
    sum = 0
    if a-1 > -1 && b+1 < 7 && @board[a-1][b+1] == @board[a][b]
      sum+=1
      if a-2 > -1 && b+2 < 7 && @board[a-2][b+2] == @board[a][b]
        sum+=1
        if a-3 > -1 && b+3 < 7 && @board[a-3][b+3] == @board[a][b]
          sum+=1
          return @board[a][b] if sum == 3
        end
      end
    end
    if a+1 < 6 && b-1 > -1  && @board[a+1][b-1] == @board[a][b]
      sum+=1
      return @board[a][b] if sum == 3
      if a+2 < 6 && b-2 > -1 && @board[a+2][b-2] == @board[a][b]
        sum+=1
        return @board[a][b] if sum == 3
        if a+3 < 6 && b-3 > -1 && @board[a+3][b-3] == @board[a][b]
          sum+=1
          return @board[a][b] if sum == 3
        end
      end
    end

    return 0
  end

  ## To print boards for debugging
  def show
    for a in 0..5
      for b in 0..6
        print @board[a][b]
      end
      print "\n"
    end
    puts ""
  end

  def options
    @options
  end
end

def Clone(board)
  a = Board.new(0)
  for j in 0..6
    for i in 0..5
      break if board.current[i][j] == 0
      a.setval(j, board.current[i][j]) unless board.current[i][j] == 0
    end
  end
  a
end

def Play(board, a, player)
  if($one + $two +$draw) % 100000 == 0
    puts "Player 1 - #{$one}    Player 2 - #{$two}     Draws - #{$draw}"
  end
  v = 0
  v = board.setval(a, player)
  if v == 0
    return 1
  elsif v == 1
    $one += 1
  else
    $two += 1
  end
  return 0
end

def Player1(board)
  opt = board.options
  if opt == []
    $draw += 1
    return
  end
  opt.shuffle.each do |x|
    if Play(board, x, 1) == 1
      Player2(board)
    end
    board.undo(x)
  end
end


def Player2(board)
  opt = board.options
  if opt == []
    $draw += 1
    return
  end
  opt.shuffle.each do |x|
    if Play(board, x, 2) == 1
      Player1(board)
    end
    board.undo(x)
  end
end

win = Board.new(0)
t0 = Thread.new{
  obj = Clone(win)
  Play(obj, 0, 1)
  Player2(obj)
}
t1 = Thread.new{
  obj = Clone(win)
  Play(obj, 1, 1)
  Player2(obj)
}
t2 = Thread.new{
  obj = Clone(win)
  Play(obj, 2, 1)
  Player2(obj)
}
t3 = Thread.new{
  obj = Clone(win)
  Play(obj, 3, 1)
  Player2(obj)
}
t4 = Thread.new{
  obj = Clone(win)
  Play(obj, 4, 1)
  Player2(obj)
}
t5 = Thread.new{
  obj = Clone(win)
  Play(obj, 5, 1)
  Player2(obj)
}
t6 = Thread.new{
  obj = Clone(win)
  Play(obj, 6, 1)
  Player2(obj)
}
puts ""
t0.join
t1.join
t2.join
t3.join
t4.join
t5.join
t6.join
puts "Player 1 - #{$one}    Player 2 - #{$two}     Draws - #{$draw}"
