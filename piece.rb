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
		if @position[0] == promotion_row && @king == false
			@king = true
			return true
		end
		false
	end	

	def valid_moves(multi_jump = false)
		moves = valid_jumps
		moves += valid_adjacent unless multi_jump
		moves
=begin
		moves = []
		movement_vector.each do |direction|
			[-1,1].each do |side|
				row, col = position[0], position[1]
				move = [row+direction, col+side]
				next if out_of_bounds?(move)
				unless 
				if @board[move]
					jump = [move[0]+direction, move[1]+side]
					next if out_of_bounds?(jump)
					if @board[move].color != @color && !@board[jump]
						moves << jump
					end
				else
					moves << move
				end
			end
		end
		moves
=end
	end
	def valid_adjacent
		moves = []
		movement_vector.each do |vert_vector|
			[-1,1].each do |horiz_vector|
				move = [position[0] + vert_vector, position[1] + horiz_vector]
				next if out_of_bounds?(move)
				moves << move unless @board[move]
			end
		end
		moves
	end
	def valid_jumps
		moves = []
		movement_vector.each do |vert_vector|
			[-1,1].each do |horiz_vector|
				move = [position[0] + vert_vector, position[1] + horiz_vector]
				next if out_of_bounds?(move) || !@board[move]
				if @board[move].color != @color
					jump = [move[0] + vert_vector, move[1] + horiz_vector]
					next if out_of_bounds?(jump)
					moves << jump unless @board[move].color == @color || @board[jump]
				end
			end
		end
		moves
	end
	def jumping_move(destination)
		difference = [destination[0]-position[0], destination[1] - position[1]]
		jumped_position = [position[0]+difference[0]/2,position[1]+difference[1]/2]
		@board.remove_piece_at(jumped_position)
	end
	def move_to(destination)
		jumping_move(destination) if (destination[0]-position[0]).abs == 2
		@position = destination
	end
	def promotion_row
		@color == :red ? 7 : 0
	end
	def out_of_bounds?(move)
		return true if move[0] < 0 || move[0] > 7 || move [1] < 0 || move[1] > 7
		false
	end 
end