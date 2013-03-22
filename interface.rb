require './board'
require './player'
require 'colorize'

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
				puts "Invalid move, please select a valid piece"
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

