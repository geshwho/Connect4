# Connect4
Ruby program to go through all possible connect 4 board combinations.
According to wikipedia, there are over 4.5 trillion possible board combinations. AFAIK, this includes incomplete combinations (ones in which no one has won and it is not a draw). 

This Program is intended to find all of them and evaluate whether it is a Player1 win a Player2 win or a draw. Unfortunately, running this can take several days to complete due to the large number of boards to find.

### Connect6.rb
This is a recursive program that goes back and forth calling `Player1` and `Player2` until an endstate is reached. An endstate is either when the whole board has been filled (`@options` is empty) or a Player has achieved 4 in a row.

### Connect7.rb
Essentially the same as Connect6, but making use of Ruby Threads.

Each of the seven Threads makes one of the 7 first moves by Player1 and then continues recursing. Not the most efficient use of threads, but offers large improvements over Conncet6 if using an interpreter supporting tru OS level threading and doesnt suffer from GIL (Jruby)
