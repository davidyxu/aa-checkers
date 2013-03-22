require 'colorize'

class Board
	attr_reader :pieces
	def initialize
		@pieces = initialize_pieces
	end
	def initialize_pieces
		pieces = []
		3.times do |row|
			4.times do |col|
				position = [row, col*2] 
				position[1] += 1 if row.even?
				pieces << Piece.new(:red, position, self)

				position = [row+5, col*2]
				position[1] += 1 if row.odd?
				pieces << Piece.new(:black, position, self)
			end
		end
		pieces
	end
	def piece_at(position)
		piece = @pieces.select { |piece| piece.position == position }
		return false if piece.empty?
		piece[0]
	end
	def pieces_of(color)
		@pieces.select { |piece| piece.color == color}
	end
	def [](position)
		piece_at(position)
	end
	def over?
		return true if pieces_of(:red).empty? || pieces_of(:black).empty?
	end
	def winner
 		pieces_of(:red).empty? ? :black : :red
	end
	def moves_of(position)
		[position].valid_moves
	end
end

class CheckersInterface
	def initialize(red = HumanPlayer.new(:red), black = HumanPlayer.new(:black))
		@board = Board.new
		@red, @black = red, black
	end
	def play
		turn = @red
		until @board.over?
			print_board
			puts "#{turn.color.capitalize} player's Turn:"
			move = turn.get_start
			until @board.piece_at(move) && @board[move].color == turn.color
				print_board
				puts "Invalid move, please select another piece"
				move = turn.get_start
			end
			valid_moves = @board[move].valid_moves
			move = turn.get_destination(valid_moves)
			turn == @red? @black : @red
		end
	end
	def print_winner(winner)
		puts "The winner is "
	end
	def piece_positions_of(color)
		@board.pieces_of(color).map { |piece| piece.position}
	end
	def checker(position)
		(position[0] - position[1]).even? ? :white : :light_white
	end
	def print_border_letters
		print "  "
		('a'..'h').each { |letter| print " #{letter} "}
		puts
	end
	def print_board
		print_border_letters
		8.times do |row|
			print "#{row + 1} "
			8.times do |col|
				print_piece([row, col])
			end
			puts
		end
	end
	def print_piece(position)
		piece = @board[position]
		if piece
			print " O ".colorize( :color => piece.color, :background => checker(position))
		else
			print "   ".colorize( :background => checker(position))
		end
	end
end

class Player
	attr_reader :color
	def initialize(color)
		@color = color
	end
	def get_start
		nil
	end
end
class HumanPlayer < Player
	def initialize(color)
		super(color)
    @letter_to_number = {}
    ('a'..'h').each_with_index do |letter, number|
      @letter_to_number[letter] = number
    end
	end
	def get_start
		puts "Please select a piece to move:"
		input_to_coordinate(gets.chomp)
	end
	def input_to_coordinate(move)
		converted = []
		converted[1] = @letter_to_number[move[0]]
		converted[0] = move[1].to_i-1
		converted
	end
	def coordinate_to_input(move)
		converted = @letter_to_number.key(move[1])
		converted += (move[0]+1).to_s
		converted
	end
	def print_valid_moves(valid_moves)
		move_coordinates = []
		valid_moves.each do |move|
			move_coordinates << coordinate_to_input(move)
		end
		if move_coordinates.empty?
			puts "This piece has no valid moves."
		else
			puts "This piece's valid moves are: #{move_coordinates}"
		end
	end

	def get_destination(valid_moves)
		print_valid_moves(valid_moves)
	end
end

class Piece
	attr_reader :color, :position, :king
	def initialize(color, position, board)
		@board = board
		@color, @position = color, position
		@king = false
	end
	def movement_vector
		return [-1, 1] if @king
		@color == :red ? [1] : [-1]
	end
	def promote
		@king = true
	end
	def valid_moves
		moves = []
		movement_vector.each do |direction|
			[-1,1].each do |side|
				row, col = position[0], position[1]
				move = [row+direction, col+side]
				next if out_of_bounds?(move)
				if @board[move]
					jump = [move[0]+direction, move[1]+side]
					if @board[move].color != @color && @board[jump]
						moves << jump
					end
				else
					moves << move
				end
			end
		end
		moves
	end

	def out_of_bounds?(move)
		return true if move[0] < 0 || move[0] > 7 || move [1] < 0 || move[1] > 7
		false
	end 
end

game = CheckersInterface.new
game.play