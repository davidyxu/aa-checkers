require 'colorize'

class Checkers
	attr_reader :pieces
	def initialize
		@pieces = initialize_pieces
	end
	def initialize_pieces
		3.times do |row|
			4.times do |col|
				position = [row, col] 
				postion[1] += 1 if row.even?
				pieces << Piece.new(:red, position)

				position = [row+5, col]
				position[1] += 1 if row.odd?
				pieces << Piece.new(:black, position)
		end
		pieces
	end
	def piece_at(position)
		piece = @pieces.select { |piece| piece.position == position }
		return false if piece.empty?
		piece[0].color
	end
	def pieces_of(color)
		@pieces.select { |piece| piece.color == color}
	end
end

class CheckersInterface
	def initialize
		game = Checkers.new
	end
	def piece_positions_of(color)
		@checkers.pieces_of(color).map { |piece| piece.position}
	end

	def draw_board

	end
end

class Player
	def get_move

	end
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

	end
end