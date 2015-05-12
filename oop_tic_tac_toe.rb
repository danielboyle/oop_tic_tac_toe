class Board
  WINNING_LINES = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]

  def initialize
    @data = {}
    (1..9).each { |position| @data[position] = Square.new(' ') }
  end

  def draw
    system 'clear'
    puts
    puts " #{@data[1]} | #{@data[2]} | #{@data[3]} "
    puts "---+---+---"
    puts " #{@data[4]} | #{@data[5]} | #{@data[6]} "
    puts "---+---+---"
    puts " #{@data[7]} | #{@data[8]} | #{@data[9]} "
    puts
  end

  def all_squares_marked?
    empty_squares.size == 0
  end

  def empty_squares
    @data.select { |_, square| square.value == ' ' }.values
  end

  def empty_positions
    @data.select { |_, square| square.empty? }.keys
  end

  def mark_square(position, marker)
    @data[position].mark(marker)
  end

  def winning_condition?(marker)
    WINNING_LINES.each do |line|
      return true if @data[line[0]].value == marker && @data[line[1]].value == marker && @data[line[2]].value == marker
    end
    false
  end

  def reset
    initialize
  end
end

class Square
  attr_accessor :value

  def initialize(value)
    @value = value
  end

  def mark(marker)
    @value = marker
  end

  def occupied?
    @value != ' '    
  end

  def empty?
    @value == ' '
  end

  def to_s
    @value 
  end
end

class Player
  attr_accessor :name
  attr_reader :marker

  def initialize(name, marker)
    @name = name
    @marker = marker
  end

  def set_name
    system "clear"
    puts "Get ready to play Tic Tac Toe!"  
    puts
    puts "Please enter your name."
    puts 
    self.name = gets.chomp
  end
end

class Game
  attr_reader :human

  def initialize
    @board = Board.new
    @human = Player.new(" ", "X")
    @computer = Player.new("Computer", "O")
    @current_player = @human
  end

  def current_player_mark_square
    if @current_player == @human
      begin
        puts "Choose a position (1-9)"
        position = gets.chomp.to_i
      end until @board.empty_positions.include?(position)
    else
      position = @board.empty_positions.sample
    end
    @board.mark_square(position, @current_player.marker)
  end

  def current_player_win?
    @board.winning_condition?(@current_player.marker)
  end

  def alternate_player
    if @current_player == @human
      @current_player = @computer
    else
      @current_player = @human
    end
  end

  def play_again?
    begin
      puts "Play again? (Y/N)"
      answer = gets.chomp.downcase
    end until ['y', 'n'].include?(answer)
    if answer == 'y'
      true
    else 
      false
    end
  end

  def end_game
    system "clear"
    puts
    puts "Thanks for playing!"
    puts
  end

  def play
    human.set_name
    begin
      @board.reset
      loop do
        @board.draw
        current_player_mark_square
        @board.draw
        if current_player_win?
          puts "#{@current_player.name} wins!"
          break
        elsif @board.all_squares_marked?
          puts "It's a tie"
        else
          alternate_player
        end
      end
    end until play_again? == false
    end_game
  end
end

Game.new.play
