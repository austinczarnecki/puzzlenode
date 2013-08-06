# [[#5] Counting Cards](http://www.puzzlenode.com/puzzles/5-counting-cards)

_This puzzle was contributed by Eric Gjertsen and published on May 15, 2011_

# Counting Cards

Rocky sat down hours ago with his three fellow troublemakers and now is too drunk to remember what card game they are playing. Rocky figures even if he doesn't remember, he's halfway there if he can at least keep track of his partner's hand. Luckily, his partner Lil devised ahead of time a system of signals so that they could communicate their moves to each other without the other players knowing, and she also let Rocky peek at her initial hand. The problem is that Lil is not very good at hiding her signals, and their opponents Danny Dogg and Shady Skunk have caught on. Rocky's vision never was that good, and in his inebriated state, he can't always tell if it's Lil giving him signals or his opponents tricking him with fake signals. 

I know you're walking in late to the saloon, but can you help Rocky keep track of what's in Lil's hand?

Mouse Nell has a nervous habit of watching the game from Rocky's shoulder and has been taking obsessive notes about what moves she can see and what signals are being given. 

Her notes are attached below in the "INPUT" file. The format is described below.

## Problem

You'll need to provide Rocky with a list of which cards Lil has in her hand after each of her turns. The format of this file is also described below.

Note that:

- One standard deck of cards is being used in the game (52  suit cards, no Joker cards).
- Everyone is dealt 4 cards to begin with.
- Possible moves are drawing from the deck, passing a card to another player, and discarding to the discard pile.
- Once a card is discarded, it never goes back into a player's hand.
- When a player discards a card, everyone sees it. 
- Luckily, you don't have to understand anything more than this about the game itself.

The moves that Lil signals to Rocky are **drawing** a card, **passing** a card to another player, and **receiving** a card from another player, which may have happened earlier in the round. 

So for example, her turn might consist of:

1. receiving the Jack of Diamonds and 10 of Clubs from Rocky and 2 other cards from Shady during the round;
- drawing 3 cards;
- discarding the 7 of Hearts;
- passing 2 cards to Danny;
- and passing the Jack of Spades to Rocky. 

Note that the discarded 7 of Hearts and the Jack of Spades she passed are visible to Rocky, as well as the two cards she received from Rocky, while the other cards are not visible. 

**The only moves that Lil signals to Rocky (and the opponents fake-signal) are the ones not visible to him**: in this example, the 3 drawn cards, 2 passed cards to Danny, and 2 received cards from Shady. 

**The order of Lil's moves makes a difference.** For instance, since she drew 3 cards *before* discarding the 7 of hearts, one of these drawn cards might have been the 7 of hearts (provided she didn't already have it in her hand). So while her discard is visible, and thus *not* signaled to Rocky, her acquisition of the 7 of hearts is one of the moves that Rocky didn't see, so it *may* be signaled. Likewise with the Jack of Spades she passed to Rocky.

Note also that:

- Only after Lil's turn are her moves signaled/faked.
- Lil will always accurately signal all of her unknown moves and all cards she received during the round.
- The other players can signal any set of moves - they don't have to actually hold the cards in their hands or anything like that.

## Example

### Input

Each line of the input represents a player's moves during his or her turn. The line consists of the name of the player followed by a set of actions they took. When any action involves passing or drawing cards that Rocky can't see, the card is listed as `??`. 

Otherwise, any card that Rocky can see is listed as `<value><suit>`, where `Values = [2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K, A]` and `Suits = [C, D, S, H]` 

So for example:

    Danny  +?? +?? +?? -??:Shady -??:Shady -7H:discard

This means Danny drew three (unknown) cards, passed two (unknown) cards to Shady, and discarded a 7 of hearts.

Rocky's turns don't have any question marks, obviously. For instance:

    Rocky  +3C +5C +JD -AS:Lil -KD:Lil -9H:discard

Lil's turns are similar to the other players:

    Lil +AS:Rocky +KD:Rocky +?? -??:Danny -??:Danny -5D:discard

Note here that the passes are always denoted from **both giver and receiver's end**. (Part of Mouse Nell's obsessiveness...)  So here the Ace of Spades and King of Diamonds passed from Rocky to Lil is matched in Lil's turn by a `+AS:Rocky +KD:Rocky`.

Lil's turn is followed by one or more records starting with asterisk (*), representing the moves that Lil and other players **signal** to Rocky:

    * +QS -JC:Danny -10D:Danny
    * +2C -7S:Danny -JD:Danny
    * +7H -JC:Danny -10D:Danny

So then it's your job to determine which is really Lil's signal. Note in this example, the second signal cannot be true since we know Rocky is holding the Jack of Diamonds, not Lil. The third signal cannot be true either, because the 7 of Hearts was discarded already by Danny. The first signal *could* be true, and since there's no other signal, it must be Lil's.

In some cases more than one signal may be valid. In such cases you must follow all valid possibilities until you run into a dead-end on all but one of the branches. 

Note that:

- The input for the game is in a file named INPUT.
- The first four lines represent the cards dealt to each player. Rocky's and Lil's will both be completely visible, while Danny and Shady's will be completely invisible.
- There will always be exactly one valid set of signals that threads all the way to the end of the game, this is what you must use to construct Lil's hand after each of her turns.

### Output

The output format is a single line per each of Lil's turns, with each of her cards listed *in the order it entered her hand*, *after her turn ended*. The first line should be the cards she was originally dealt. For example, in a 4-round game the output might be:

    KS 6S 3C 4D 5D 4C
    KS 5D 4C 8D AH
    5D 4C 8D 6C 10S
    8D 6C 10S 7D
    6C 10S 7D 6S 8H KC

Note that the output file should be UNIX, rather than MS-DOS style (lines end in LF, including final line). That means you'll have trouble if you use Notepad to submit your solution!

### Notes

#### To get started, a game with just Lil's signals
Included under "Input" below is a sample game (**SAMPLE\_INPUT**) where there's only one set of (valid) signals per round -- that is, you don't have to determine invalid from valid signals. See if you can solve this game first, simply by resolving the signals against the unknown cards in Lil's hand, and keeping track of her cards as you go. SAMPLE_SOLUTION lists the solution.

#### To get rolling, a practice round played with cards showing

There's also a second sample (**SAMPLE\_INPUT\_2**), which represents one round of the game immediately before Lil's turn. In this sample, you know what's currently in each of the players' hands and what's in the discard pile. Here there are *six* sets of signals, only one of which can match Lil's actual moves. See if you can determine which is the correct set of signals, and from this determine the cards in Lil's hand at the end of the round. **SAMPLE\_SOLUTION\_2** lists the solution. Note that the invalid signals in this sample cover many (but not all) of the corner cases you're likely to encounter in the main puzzle.
