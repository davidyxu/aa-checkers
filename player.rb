class Player
	attr_reader :color
	def initialize(color, board)
		@color = color
		@board = board
	end
	def get_start
		nil
	end
end
class HumanPlayer < Player
	def initialize(color, board)
		super(color, board)
    @letter_to_number = {}
    ('a'..'h').each_with_index do |letter, number|
      @letter_to_number[letter] = number
    end
	end
	def get_move
		start = get_start
		valid_moves = @board[start].valid_moves
		destination = get_destination(valid_moves)
		[start, destination]
	end
	def get_start
		puts "Please select a piece to move:"
		start = input_to_coordinate(gets.chomp)
		until @board.piece_at(start) && @board[start].color == @color
			puts "Invalid move, please select a valid piece:"
			start = input_to_coordinate(gets.chomp)
		end
		if @board[start].valid_moves.empty?
			puts "No Valid moves for this piece"
			start = get_start
		end
		start
	end
	def input_to_coordinate(position)
		converted = []
		converted[1] = @letter_to_number[position[0]]
		converted[0] = position[1].to_i-1
		converted
	end
	def coordinate_to_input(position)
		converted = @letter_to_number.key(position[1])
		converted += (position[0]+1).to_s
		converted
	end
	def print_valid_moves(valid_moves)
		move_coordinates = []
		valid_moves.each do |move|
			move_coordinates << coordinate_to_input(move)
		end

		puts "This piece's valid moves are: #{move_coordinates}"
	end

	def get_destination(valid_moves)
		print_valid_moves(valid_moves)
		puts "Please select a square to move to:"
		destination = input_to_coordinate(gets.chomp)
		until valid_moves.include?(destination)
			puts "Not a valid move, please select from one of the valid moves"
			destination = input_to_coordinate(gets.chomp)
		end
		destination
	end
end