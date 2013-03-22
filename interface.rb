# encoding: utf-8

require './board'
require './player'
require 'colorize'

class CheckersInterface
	def initialize(red = :human, black = :human)
		@board = Board.new
		@red = setup_player(red, :red)
		@black = setup_player(black, :black)
	end

	def setup_player(player_type, color)
		case player_type
		when :human then HumanPlayer.new(color, @board)
		end
	end

	def play
		turn = @red
		until @board.winner?
			print_board
			puts "#{turn.color.capitalize} player's Turn:"
			start, destination = turn.get_move
			multi_jump = @board.move(start, destination)
			while multi_jump
				print_board
				start, destination = turn.get_destination(destination, multi_jump)
				multi_jump = @board.move(start, destination)
			end
			turn = switch_turn(turn)
		end
		print_board
		print_winner(@board.winner?)
	end

	def switch_turn(turn)
		turn == @red? @black : @red
	end

	def print_winner(winner)
		if winner == :tie
			puts "Draw!"
		else
			puts "#{winner.capitalize} is the winner."
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
		('a'..'h').each { |letter| print " #{letter}  "}
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
			case piece.king
			when false
				print " ◯  ".colorize( :color => piece.color, :background => checker(position))
			when true
				print " ◉  ".colorize( :color => piece.color, :background => checker(position))
			end
		else
			print "    ".colorize( :background => checker(position))
		end
	end
end

