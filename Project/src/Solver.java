import org.jpl7.Query;
import org.jpl7.Term;
import java.util.ArrayList;

public class Solver {

    public Solver() { Query.hasSolution("consult('quarto.pl')"); }

    public Term startGame(String player)
    {
       // if(player.equals("0"))
        //{
            Term term = Query.oneSolution("play([0, play,[0, 0, 0, 0, 0, 0, 0, 0, 0]], [1,2,3,4,5,6,7,8],X)").get("X");
           // System.out.println(term);
            return term;
//        }
//        else
//        {
//            Term term = Query.oneSolution("play([1, play, [0, 0, 0, 0, 0, 0, 0, 0, 0]], [1,2,3,4,5,6,7,8],Rp)").get("Rp");
//            //System.out.println(term);
//            return term;
//        }
    }
    public Term PlayerGame(ArrayList<String> Board,ArrayList<String> Pieces)
    {
        String pieces = "[";
        for (int i = 0; i < Pieces.size(); i++) {
            pieces += (i+1);
            if (i != Pieces.size() - 1) pieces += ",";
        }
        pieces += "]";
        Term term = Query.oneSolution("play([0, play,["+ Board.get(0) + "," + Board.get(1) + "," + Board.get(2) + "," + Board.get(3) + "," + Board.get(4) + "," + Board.get(5) + "," + Board.get(6) + "," + Board.get(7) + "," + Board.get(8) + "]], "+pieces+",X)").get("X");
       // System.out.println(term.toString());
        return term;

    }
}
