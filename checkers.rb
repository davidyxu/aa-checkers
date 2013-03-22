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
				pieces << Piece.new(:red, position)

				position = [row+5, col*2]
				position[1] += 1 if row.odd?
				pieces << Piece.new(:black, position)
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
end

class CheckersInterface
	def initialize(red = HumanPlayer.new, black = HumanPlayer.new)
		@board = Board.new
		@red, @black = red, black
	end
	def play
		turn = @red
		until @board.over?

			turn == @red? @black : @red
		end
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
			print "#{row} "
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
	def get_move
		nil
	end
end
class HumanPlayer < Player
end

class Piece
	attr_reader :color, :position, :king
	def initialize(color, position)
		@color, @position = color, position
		@king = false
	end
	def movement_vector
		return [-1, 1] if @king
		[-1] if @color == :red
		[1] if @color == :black
	end
	def move
		nil
	end
end

game = CheckersInterface.new
game.print_board