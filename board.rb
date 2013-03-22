require './piece'

class Board
	attr_reader :pieces
	def initialize
		#@pieces = initialize_pieces
		@pieces = test_initialize
	end

	def test_initialize
		pieces = []
		pieces << Piece.new(:red, [4,2], self)
		pieces << Piece.new(:black, [5,3], self)
		pieces << Piece.new(:black, [1,1], self)
		pieces << Piece.new(:black, [3,3], self)
		pieces << Piece.new(:red, [2,2], self)
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

	def valid_moves_left?(color)
		valid_moves = pieces_of(color).inject([]) do |move_set, piece|
			move_set + piece.valid_moves
		end
		valid_moves.empty? ? false : true
	end

	def winner?
		return :black if pieces_of(:red).empty?
		return :red if pieces_of(:black).empty?
		return :black unless valid_moves_left?(:red)
		return :red unless valid_moves_left?(:black)
 		false
	end

	def remove_piece_at(position)
		@pieces.reject! { |piece| piece.position == position }
	end

	def moves_of(position)
		[position].valid_moves
	end

	def move(start, destination)
		return false if start == destination
		moving_piece = piece_at(start)
		moving_piece.move_to(destination)
		promoted = moving_piece.promote
		multi_jump?(moving_piece, promoted) ? true : false
	end
	def multi_jump?(moving_piece, promoted)
		!moving_piece.valid_jumps.empty? && !promoted
	end
end