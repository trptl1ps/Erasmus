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
	puts "==>in #{__method__.to_s}" if $DEBUG

	puts "Welcome to Raz's Blackjack version 1.0"
	display_money
end

#####################################
# Display the player's current money. 
# Uses global var $player_money
def display_money
	puts "==>in #{__method__.to_s}" if $DEBUG

	puts "You have $#{$player_money}"	
end

#####################################
# Determine the user command
# Valid commands depend on if the game has started or not
# 
def get_user_command(game_started)
	puts "==>in #{__method__.to_s}" if $DEBUG

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
	puts "==>in #{__method__.to_s}" if $DEBUG

	player_hand = []			# Contains the player's cards
	dealer_hand = []			# Contains the dealer's cards

	# Reset the deck
	$card_deck = $cards.keys	
	#puts card_deck

	# Deal the cards
	deal_cards(player_hand, dealer_hand)
	dealer_turn = false

	display_hands(player_hand, dealer_hand, dealer_turn)
	$game_status = display_status(player_hand, dealer_hand, dealer_turn)
	if game_over?($game_status)
	 	return
	end


	while true	# Play until the game is over
		command = get_user_command(game_started=true)

		case command
		when 'Q'
			abort "Goodbye"

		when 'H'
			# Deal another card
			deal_card(player_hand)
			display_hands(player_hand, dealer_hand, dealer_turn)
			$game_status = display_status(player_hand, dealer_hand, dealer_turn)
			if game_over?($game_status) 
				return
			end

		when 'S'
			# Player is done betting
			dealer_turn = true
			play_dealer_hand(dealer_hand, player_hand)
			display_hands(player_hand, dealer_hand, dealer_turn)
			$game_status = display_status(player_hand, dealer_hand, dealer_turn)
			if game_over?($game_status) 
				return
			end
			break
		end
	end
end

#####################################
# method: display_status
# Display the status of the game 
# => games status
def display_status(player_hand, dealer_hand, dealer_turn)
	puts "==>in #{__method__.to_s}" if $DEBUG

	player_total = get_hand_total(player_hand)
	dealer_total = get_hand_total(dealer_hand)

	# We need to know if this if this is the first two cards
	if player_hand.length == 2 && dealer_hand.length == 2

		# check for game conditions
		# check for dealer blackjack
		if dealer_total == 21
			if player_total == 21
				# this is a draw
				puts ""
				puts "Game over: draw"
				return $DRAW
			else
				# Dealer wins
				puts "Game over: dealer blackjack"
				$player_money -= 10
				return $DEALER_WINS
			end
		else
			# check if the player has a blackjack
			if player_total == 21
				puts "Game over: player blackjack"
				$player_money += 10 * 2.5
				return $PLAYER_BLACKJACK
			else
				return $IN_PROGRESS
			end
		end
	end

	# For this next section, we need to know if the dealer has already played
	if dealer_turn
		# This is not the original cards
		# check for game conditions
		# check for dealer blackjack
		if dealer_total == player_total && dealer_total <= 21 && player_total <= 21
			puts "Game over: draw"
			return $DRAW
		elsif player_total > 21 && dealer_total <= 21
			puts "Game over: dealer wins"
			$player_money -= 10
			return $DEALER_WINS
		elsif dealer > 21 && player_total <= 21
			puts "Game over: player wins"
			$player_money += 10
			return $PLAYER_WINS
		elsif dealer_total > player_total
			puts "Game over: dealer wins"
			$player_money -= 10
			return $DEALER_WINS
		else
			puts "Game over: dealer wins"
			$player_money -= 10
			return $DEALER_WINS
		end
	else
		# It's the players turn. They get checked after every move, so you need to know if they go bust
		if player_total > 21
			$player_money -= 10
			return $DEALER_WINS
		else		
			return $IN_PROGRESS
		end
	end
end

#####################################
# method: game_over?
# Displays the status of the game
# Returns true if the player or 
def game_over?(game_status)
	puts "==>in #{__method__.to_s}" if $DEBUG
	return $game_status != $IN_PROGRESS
end

#####################################
# display_hands
# Shows the hands of both player and dealer and evaluates if the game
# is over.
# 
# Needs to know if to show or hide the other dealer card
def display_hands(player_hand, dealer_hand, dealer_turn)
	puts "==>in #{__method__.to_s}" if $DEBUG

	# show the hands
	puts "        Player            Dealer"
	puts "        ======            ======"

	# Determine the max rows to display
	max_rows = [player_hand.length, dealer_hand.length].max

	for index in 0..max_rows-1
		display_card(player_hand, dealer_hand, index, dealer_turn)
	end

	# Print the totals
	display_card_total(player_hand, dealer_hand, dealer_turn)
end

#####################################
# method: display_card
# input:
# 	player_hand
#   dealer_hand
#   i: index to the hands
#   dealer_turn: boolean true if it is the dealer turn. Determines whether to show the dealers second card
#
# The method prints blanks if there are no more cards
# T
def display_card(player_hand,dealer_hand,index,dealer_turn)
	puts "==>in #{__method__.to_s}" if $DEBUG

	puts "index: #{index}"

	if index >= dealer_hand.length
		# we know that we have gone past the length of the hand, so print blanks
		player_card = '  '
	else
		player_card = player_hand[index]
	end

	# To print the dealer hand, we know that if dealer_turn is false, don't dislay the second card
	if !dealer_turn
		if index == 1
			dealer_card = '--'
		elsif index == 0
			dealer_card = dealer_hand[0]
		else
			dealer_card = '  '
		end
	else 
		# We know it is the dealer turn
		if index >= dealer_hand.length
			# we know that we have gone past the length of the hand, so print blanks
			dealer_card = '  '
		else
			dealer_card = dealer_hand[index]
		end
	end

	puts (" " * (13 - player_card.length)) + player_card + (" " * (17 - dealer_card.length)) + dealer_card
end 

#####################################
# method: display_card_total
# Prints the card totals for player and dealer.
# dealer_turn - if false, do not include the second (hidden) card in the total
def display_card_total(player_hand, dealer_hand, dealer_turn)
	puts "==>in #{__method__.to_s}" if $DEBUG

	player_total = get_hand_total(player_hand).to_s
	dealer_total = get_dealer_total(dealer_hand,dealer_turn).to_s
	
	puts
	puts "Total" + (" " * (8 - player_total.length)) + player_total + (" " * (17 - dealer_total.length)) + dealer_total

end

#####################################
# method: get_hand_total
# => total value of cards
def get_hand_total(player_hand)
	puts "==>in #{__method__.to_s}" if $DEBUG


	# In order to deal properly with aces, we need to know whether to treat them as 11 or 1.
	# At first, each ace is treated as 11. If the player goes over 21, then we try to get the
	# total under 21 by treating each ace (one at a time) as 1. So, if the player just has one ace,
	# it's easy: the ace becomes 1. But if the user has two aces, the first can be 1, and the second
	# can still be 11 if it works. So this method has to deal with each ace in turn. To do that,
	# this method creates a local array of cards and values, and manipulates each ace value to
	# see what produces the largest value below 21.
	hand = {}
	puts hand.class.name if $DEBUG

	for i in 0..player_hand.length - 1
		puts player_hand[i] if $DEBUG
		puts $cards[player_hand[i]] if $DEBUG
		hand.store(player_hand[i],$cards[player_hand[i]])
		p hand if $DEBUG
	end

	while true
		player_total = 0 		# Total value of player's hand

		# Add all the card values together
		hand.each do |card, value|
			puts "card: #{card}" if $DEBUG
			puts "value: #{value}" if $DEBUG
			player_total += value
		end

		puts "player_total = #{player_total} " if $DEBUG
		puts "=================" if $DEBUG

		if player_total <= 21
			return player_total
		#elsif THIS WAS A MAJOR BUG!!!!! BEWARE
		else
			puts "*" * 10 if $DEBUG
			puts "player_total is above 21" if $DEBUG
			# See if there are aces to flip
			ace_to_flip_found = false

			# check if there are aces that haven't been flipped to value 1
			hand.each do |card, value|
				p card if $DEBUG
				p value if $DEBUG
				# is this an ace
				if ["AC","AD","AS","AH"].include? card && value == 11
					puts "Found an ace with value #{value}" if $DEBUG
					hand[card] = 1
					puts "New value #{hand[card]}" if $DEBUG
					ace_to_flip_found = true
				end
			end
			# Check if there was an ace to flip
			if !ace_to_flip_found 
				# We can't do anything else - we busted
				puts "Return player_total" if $DEBUG
				return player_total
			else
				puts "ace_to_flip_found is true????" if $DEBUG
				#We loop and try again
			end
		end
	end
	# return player_total
end

#####################################
# method: get_dealer_total
# dealer_turn: When false, do not incude value of second card
# => total value of cards
def get_dealer_total(dealer_hand,dealer_turn)
	puts "==>in #{__method__.to_s}" if $DEBUG

	dealer_total = 0	# Total value of dealer's visible cards

	if !dealer_turn
		dealer_total = $cards[dealer_hand[0]]
	else
		dealer_total = get_hand_total(dealer_hand)
	end
	return dealer_total
end

#####################################
# method: deal_cards
# Deals two cards to the player and dealer
def deal_cards(player_hand, dealer_hand)
	puts "==>in #{__method__.to_s}" if $DEBUG

	# Everyone gets 2 cards
	2.times do
		deal_card(player_hand)
		deal_card(dealer_hand)
	end
end

#####################################
# method: deal_card
# Deal a single card to the hand
def deal_card(hand)
	puts "==>in #{__method__.to_s}" if $DEBUG

	# pick a random card and add to the hand
	index = rand($card_deck.length)
	hand << $card_deck[index]

	# remove the card from the deck
	$card_deck.delete_at(index)
end

#####################################
# Play the dealer hand until hold or bust
def play_dealer_hand(dealer_hand, player_hand)
	puts "==>in #{__method__.to_s}" if $DEBUG

	player_total = get_hand_total(player_hand)

	while player_total > get_hand_total(dealer_hand) && get_hand_total(dealer_hand) < 21
		deal_card(hand)
	end
end

#####################################
# method: display_summary
# Displays the final result of the game and adjust player money
def display_summary(player_hand, dealer_hand)
	puts "==>stub: #{__method__.to_s}" if $DEBUG
end

#####################################
# main program
# 
# Public: Sets up the main loop to play the game
#####################################
puts "==>in #{__method__.to_s}" if $DEBUG

# Global Variables
$player_money = 100			# Everyone starts with $100
$cards = { 
	'AC'=>11,'KC'=>10,'QC'=>10,'JC'=>10,'10C'=>10,'9C'=>9,'8C'=>8,'7C'=>7,'6C'=>6,'5C'=>5,'4C'=>4,'3C'=>3,'2C'=>2,
	'AS'=>11,'KS'=>10,'QS'=>10,'JS'=>10,'10S'=>10,'9S'=>9,'8S'=>8,'7S'=>7,'6S'=>6,'5S'=>5,'4S'=>4,'3S'=>3,'2S'=>2,
	'AD'=>11,'KD'=>10,'QD'=>10,'JD'=>10,'10D'=>10,'9D'=>9,'8D'=>8,'7D'=>7,'6D'=>6,'5D'=>5,'4D'=>4,'3D'=>3,'2D'=>2,
	'AH'=>11,'KH'=>10,'QH'=>10,'JH'=>10,'10H'=>10,'9H'=>9,'8H'=>8,'7H'=>7,'6H'=>6,'5H'=>5,'4H'=>4,'3H'=>3,'2H'=>2
}
$IN_PROGRESS = 0
$PLAYER_WINS = 1
$DEALER_WINS = 2
$DRAW = 3
$PLAYER_BLACKJACK = 4
$game_status = $IN_PROGRESS	#Represents undefined status


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
