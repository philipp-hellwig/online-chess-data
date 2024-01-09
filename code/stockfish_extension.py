from stockfish import Stockfish

class StockfishPlus(Stockfish):

    def reset_game_params(self):
        self.halfmoves_made = 0
        self.reached_endgame = False
        self.set_position()


    def __call__(self, moves: list):
        self.moves = moves
        self.reset_game_params()
        return self.evaluate_game()
        
    def evaluate_game(self):
        stages, evals = [],[]

        for move in self.moves:
            self.make_moves_from_current_position([move])
            eval = self.evaluate_move()
            evals.append(eval)
            if self.halfmoves_made < 20:
                stages.append("opening")
            elif not self.reached_endgame and max(self.get_material_counts()) > 13:
                stages.append("middle")
            else:
                stages.append("ending")
                self.reached_endgame = True
            
            self.halfmoves_made += 1
        
        if evals[-1] == "checkmate":
            evals[-1] = evals[-2]

        return (evals, stages)


    def evaluate_move(self):
        """
        return: return a move's evaluation compared to the previous position (in centipawns).
        """
        mate_eval = 1400
        eval = self.get_evaluation()

        if eval["type"] == "cp":
            return eval['value']
        else:
            if eval["value"] > 0:
                return mate_eval
            elif eval["value"] < 0:
                return mate_eval * -1
            else:
                return "checkmate"


    @staticmethod            
    def get_piece_value(piece):
        piece_values = {

            # White:
            "K": 0,
            "Q": 9,
            "R": 5,
            "B": 3,
            "N": 3,
            "P": 1,

            # Black:
            "k": 0,
            "q": -9,
            "r": -5,
            "b": -3,
            "n": -3,
            "p": -1,
        }
        try: 
            return piece_values[piece.value]
        except AttributeError:  # case when no piece is on a given square
            return 0


    def get_material_counts(self):
        files = ["a","b","c","d","e","f","g","h"]
        white, black = 0, 0
        
        for file in files:
            for rank in range(1,9):
                piece = self.get_what_is_on_square(file+str(rank)) # returns None if there is no piece
                if not piece:
                    pass
                piece_value = self.get_piece_value(piece)
                if piece_value > 0:
                    white += piece_value
                else:
                    black += abs(piece_value)
        return (white, black)

stf = StockfishPlus("C:/Users/phili/stockfish-windows-x86-64-avx2/stockfish/stockfish-windows-x86-64-avx2.exe")

print(stf(["e2e4","e7e5", "f2f4"]))

