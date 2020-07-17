require './board.rb'

module TicTacToe
    def launch_game
        chosen_char = ''
        puts "Hello and welcome to Tic Tac Toe! This is a game built right into your console for all of the Tic Tac Toe fun you could desire!"
        sleep(3)
        puts "\nFirst we need to start by creating our players so if player one would like to step up to the keyboard we can get started."
        sleep(3)
        player1 = build_player(chosen_char)
        sleep(1)
        puts "\nAlright now lets create player two."
        sleep(2)
        chosen_char = player1.sym
        player2 = build_player(chosen_char)
        game = Game.new(player1, player2)
        sleep(1)
        puts "Alright lets get started!"
        while true
            game.play_game
            sleep(2)
            puts "Scores:          #{player1.name}: #{player1.score}           #{player2.name}: #{player2.score}"
            print "Would you like to play again? (y or n):"
            input = gets.chomp
            if(input.strip == 'y')
                game.reset
                next
            else   
                puts "Alright, have a good day then."
                break
            end
        end
    end

    def build_player(chosen_char)
        puts "\n\n"
        while true
            print "Please enter your name: "
            name = gets.chomp.strip
            print "Ok your name will be #{name}, are you satisfied with that? (y or n): "
            input = gets.chomp
            if(input.strip == 'y')
                puts "Great! Nice to meet you #{name}."
                break
            else
                puts "Alright lets try again then."
                next
            end
        end
        while true
            while true
                print "Enter the character you wish to use: "
                char = gets.chomp.strip
                if(chosen_char.include?(char))
                    puts "Sorry that character was already chosen."
                elsif(char.length > 1)
                    puts "Enter only one character for your character."
                else
                    break
                end
            end
            print "Ok your character will be #{char}, are you satisfied with that? (y or n): "
            input = gets.chomp
            if(input.strip == 'y')
                puts "Great! Have a fun game."
                break
            else
                puts "Alright lets try again then."
                next
            end
        end
        return Player.new(name, char)
    end

    class Game
        attr_reader :player1, :player2, :board

        WIN_PATTERNS = [[[0,0],[0,1],[0,2]],
                        [[1,0],[1,1],[1,2]],
                        [[2,0],[2,1],[2,2]],
                        [[0,0],[1,0],[2,0]],
                        [[0,1],[1,1],[2,1]],
                        [[0,2],[1,2],[2,2]],
                        [[0,0],[1,1],[2,2]],
                        [[0,2],[1,1],[2,0]]]

        def initialize(player1, player2)
            @player1 = player1
            @player2 = player2
            @board = GameBoard.new
        end
        
        def reset
            self.board.reset
        end

        def play_game
            turn_number = 1
            player = player2
            while true
                player = (player == player2) ? player1 : player2
                puts self.board
                take_a_turn(player)
                if turn_number >= 5
                    winner = self.check_win_condition
                    if winner == 1
                        puts self.board
                        puts "#{player1.name} has won the game!"
                        player1.score += 1
                        break
                    elsif winner == 2
                        puts self.board
                        puts "#{player2.name} has won the game!"
                        player2.score += 1
                        break
                    elsif turn_number == 9
                        puts self.board
                        puts "Sorry it looks like no one has won this game."
                        break
                    end
                end
                turn_number += 1
            end
        end

        def take_a_turn(player)
            valid = ['0','1','2']
            puts "It is #{player.name}'s turn."
            while true
                puts "Please enter the coordinate you want to control as x , y format (only integers from 0 - 2):"
                coors = gets.chomp.split(',')
                if(coors.length != 2)
                    puts "You must enter only two values."
                    next
                end
                if(valid.include?(coors[0].strip) && valid.include?(coors[1].strip)) 
                    x = coors[0].to_i
                    y = coors[1].to_i
                else
                    puts "That is out of bounds."
                    next
                end
                if(self.board.get_item(x, y).changed)
                    puts "That point has already been taken, try again."
                    next
                else
                    self.board.change_piece(x, y, player.sym)
                    break
                end
            end
        end
        
        def check_win_condition
            player1_pattern = Array.new(3, self.player1.sym)
            player2_pattern = Array.new(3, self.player2.sym)
            WIN_PATTERNS.each do |pattern|
                arr = []
                pattern.each do |coor|
                    arr.push(board.get_item(coor[0],coor[1]).sym)
                end
                if arr == player1_pattern
                    return 1
                elsif arr == player2_pattern
                    return 2
                end
            end
            return false
        end
    end

    class Player
        attr_reader :sym, :score, :name
        attr_writer :score
        def initialize(name, sym)
            @name = name
            @sym = sym
            @score = 0
        end
    end

    class GameBoard < Board
        def initialize
            super(3)
            fill_board
        end

        def change_piece(x, y, value)
            self.get_item(x, y).sym = value
        end

        def reset
            for i in 0...3
                for j in 0...3
                    self.change_piece(i, j, nil)
                    self.get_item(i, j).changed = false
                end
            end
        end

        private

        def fill_board
            for i in 0...3
                for j in 0...3
                    set_item(i, j, BoardPiece.new)
                end
            end
        end
    end

    class BoardPiece
        attr_reader :sym
        attr_accessor :changed
        def initialize(sym = nil)
            @sym = sym
            @changed = false
        end

        def sym=(value)
            @sym = value
            @changed = true
        end

        def to_s
            if self.sym == nil
                return " "
            else
                return self.sym
            end
        end
    end
end