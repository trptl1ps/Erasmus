# Public: This program simulates a blackjack game 
#
# This first version of the program uses a procedural approach. The next version will use an object-oriented approach
# 
# The following contains assumptions along with a general description of how the game will work.
#
# 1) play with one 52 card deck
# 2) just you against the dealer
# 3) you can hit or stand. If you bust, the dealer wins
# 4) bets are fixed at $10 per round 
# 5) you win $15 for natural blackjack (ace and 10 value card on the first deal)
# 6) you win $10 if you beat the dealer
# 7) dealer must play <= 16 and hold >= 17
# 8) Commands you can enter:
# 	a) D = deal
#  	b) H = hit
#        c) S = stand
#        d) Q = quit
# 	e) M = display how much money you have
#        f) Anything else, display these 5 commands
#
# 9) each round you display two columns:
# 				Dealer				You
# 				=====					===
#
# 10) card are display as two digit identifiers of value and suit: e.g. Ace hearts, 2 clubs, etc.
# 11) each card is displayed on a separate row
# 12) the dealers uncovered card is displayed as xxxxxx
# 13) example 
#
# Welcome to Blackjack Release 1.0
# You have $100. Each bet is $10
# What would you like to do? D
#
# 				Dealer				You
# 				=====					===
# 				3 hearts			6 clubs
# 				xxxxx					jack diamonds
# total:								16
#
# What would you like to do? H
#
# 				Dealer				You
# 				=====					===
# 				3 hearts			6 clubs
# 				xxxxx					jack diamonds
# 											3 spades
# total:								19
#
# What would you like to do? S
#
# 				Dealer				You
# 				=====					===
# 				3 hearts			6 clubs
# 				9 spade				jack diamonds
# 				9 hearts			3 spades
#
# total:		21 					19
#
# Dealer wins. You lose $10. You have $90 dollars
#
# What would you like to do? M
# You have $90
#
# What would you like to do? Q
# Goodbye

# Name: getUserCommand 
# Public: Get the user's input. If invalid, print out list of commands.
#
# text  - The String to be duplicated.
# count - The Integer number of times to duplicate the text.
#
# Examples
#

#####################################
# Say hi
def display_welcome_message
	puts "Welcome to Raz's Blackjack version 1.0"
	display_money
end

#####################################
# Display the player's current money. 
# Uses global var $player_money
def display_money
	puts "You have $#{$player_money}"	
end

#####################################
# Determine the user command
# Valid commands depend on if the game has started or not
# 
def get_user_command(game_started)
	print "What do you want to do? "
	if !game_started
		# The game hasn't started
		while true
			command = gets.chomp[0].upcase
			if ['D','M','Q'].include?(command)
				return command
			else
				puts "Invalid command. Valid options are: [D]eal,[M]oney,[Q]uit"
			end
		end
	else
		while true
			# The game has started
			command = gets.chomp[0].upcase
			if ['Q','H','S'].include?(command)
				return command
			else 
				puts "Invalid command. Valid options are: [H]it,[S],[Q]uit"
			end				
		end
	end
end

#####################################
# Play the game. Deal the cards and let the player do their thing
def play_game
	player_hand = []			# Contains the player's cards
	dealer_hand = []			# Contains the dealer's cards
		
	# Deal the cards
	deal_cards(player_hand, dealer_hand)

	while true	# Play until the game is over
		command = get_user_command(game_started=true)

		case command
		when 'H'
			# Deal another card
			deal_card(player_hand)
		
		when 'S'
			# Player is done betting
			play_dealer_hand(dealer_hand)
		end
	end

end

#####################################
# Deal the cards
def deal_cards(player_hand, dealer_hand)
	puts "stub: deal_cards"
end

#####################################
# Deal a single card to the player or dealer
def deal_card(hand)
	puts "stub: deal_card"
end

#####################################
# Play the dealer hand until hold or bust
def play_dealer_hand(hand)
	puts "stub: play_dealer_hand"
end


#####################################
# main program
# 
# Public: Sets up the main loop to play the game
#####################################


# Global Variables
$player_money = 100			# Everyone starts with $100
$card_deck = { 
	'AC'=>11,'KC'=>10,'QC'=>10,'JC'=>10,'10C'=>10,'9C'=>9,'8C'=>8,'7C'=>7,'6C'=>6,'5C'=>5,'4C'=>4,'3C'=>3,'2C'=>2,
	'AS'=>11,'KS'=>10,'QS'=>10,'JS'=>10,'10S'=>10,'9S'=>9,'8S'=>8,'7S'=>7,'6S'=>6,'5S'=>5,'4S'=>4,'3S'=>3,'2S'=>2,
	'AD'=>11,'KD'=>10,'QD'=>10,'JD'=>10,'10D'=>10,'9D'=>9,'8D'=>8,'7D'=>7,'6D'=>6,'5D'=>5,'4D'=>4,'3D'=>3,'2D'=>2,
	'AH'=>11,'KH'=>10,'QH'=>10,'JH'=>10,'10H'=>10,'9H'=>9,'8H'=>8,'7H'=>7,'6H'=>6,'5H'=>5,'4H'=>4,'3H'=>3,'2H'=>2
}

# Local variables
user_command = ""			# This stores the users current command selection


# Start the program
display_welcome_message


while true

	#game_started = false

	# Prompt the user what they want to do
	user_command = get_user_command(game_started=false)

	case user_command 
	when 'D'
		game_started = true			# we don't need to state this. Obviously the game has started
		# The user wants to deal and start a new game
		play_game
	
	when 'M'
		# Display money
		display_money

	when 'Q'
		# End the game
		break
	end

end 

puts "Goodbye"



