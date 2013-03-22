require './piece'

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
	def remove_piece_at(position)
		@pieces.reject! { |piece| piece.position == position }
	end
	def moves_of(position)
		[position].valid_moves
	end
	def move(start, destination)
		piece_at(start).move_to(destination)
	end
end

