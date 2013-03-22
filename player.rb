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