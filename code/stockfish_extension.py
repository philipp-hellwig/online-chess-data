from stockfish import Stockfish

class StockfishPlus(Stockfish):

    def reset_game_params(self):
        self.halfmoves_made = 0
        self.reached_endgame = False
        self.set_position()

    def __call__(self, moves: list, game_stages=False):
        """
        moves: a list of moves in LAN notation.
        game stages: boolean whether or not to include game stage "opening", "middle" or "ending" for each move.
        return: a list of position evaluations in centipawns or a tuple of lists of position evaluations in centipawns and game stages.
        """
        self.moves = moves
        return self.evaluate_game(game_stages=game_stages)
        
    def evaluate_game(self, game_stages=False):
        self.reset_game_params()
        stages, evals = [], []

        for move in self.moves:
            self.make_moves_from_current_position([move]) # make the next move
            eval = self.evaluate_position() # get evaluation of the move
            evals.append(eval)
            if game_stages:
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

        return (evals, stages) if game_stages else evals

    def evaluate_position(self):
        """
        return: returns the current position's evaluation (in centipawns).
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
        """
        return: returns a tuple of integers with the corresponding material counts of the current position for White and Black.
        """
        files = ["a","b","c","d","e","f","g","h"]
        white, black = 0, 0  # initialize material counts at zero
        
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
