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