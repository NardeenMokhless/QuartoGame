import org.jpl7.Query;
import org.jpl7.Term;
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.util.ArrayList;
import java.util.Map;

public class Board  extends JPanel implements ActionListener {
    JButton piece = new JButton("");
    JLabel label = new JLabel("");
    JButton board1 = new JButton("1");
    JButton board2 = new JButton("2");
    JButton board3 = new JButton("3");
    JButton board4 = new JButton("4");
    JButton board5 = new JButton("5");
    JButton board6 = new JButton("6");
    JButton board7 = new JButton("7");
    JButton board8 = new JButton("8");
    JButton board9 = new JButton("9");
    ArrayList<String> Pieces = new ArrayList<>();
    ArrayList<String> Board = new ArrayList<>();

    Board(String s)
    {
        setPreferredSize(new Dimension(600,600));
        setLayout(null);

        board1.setBounds(20,100,100,50);
        board4.setBounds(20,150,100,50);
        board7.setBounds(20,200,100,50);
        board2.setBounds(120,100,100,50);
        board5.setBounds(120,150,100,50);
        board8.setBounds(120,200,100,50);
        board3.setBounds(220,100,100,50);
        board6.setBounds(220,150,100,50);
        board9.setBounds(220,200,100,50);

        piece.setBounds(200,30,100,50);
        label.setBounds(250,250,200,25);

        Pieces.add("brt");  Pieces.add("brh");  Pieces.add("bst");  Pieces.add("bsh");
        Pieces.add("wrt");  Pieces.add("wrh");  Pieces.add("wrh");  Pieces.add("wsh");
        piece.setText(Pieces.get(Integer.parseInt(s)-1));

        for(int i = 0;i<9;i++)
            Board.add("0");

        add(board1);
        add(board2);
        add(board3);
        add(board4);
        add(board5);
        add(board6);
        add(board7);
        add(board8);
        add(board9);
        add(piece);
        add(label);

        board1.addActionListener(this);
        board2.addActionListener(this);
        board3.addActionListener(this);
        board4.addActionListener(this);
        board5.addActionListener(this);
        board6.addActionListener(this);
        board7.addActionListener(this);
        board8.addActionListener(this);
        board9.addActionListener(this);

    }
    @Override
    public void actionPerformed(ActionEvent e) {

        Object pressed = e.getSource();
        if(pressed == board1 )
            actionButton(board1,1);
        else if(pressed == board2 )
            actionButton(board2,2);
        else if(pressed == board3 )
            actionButton(board3,3);
        else if(pressed == board4 )
            actionButton(board4,4);
        else if(pressed == board5 )
            actionButton(board5,5);
        else if(pressed == board6 )
            actionButton(board6,6);
        else if(pressed == board7 )
            actionButton(board7,7);
        else if(pressed == board7)
            actionButton(board8,8);
        else if(pressed == board9 )
            actionButton(board9,9);

    }

    public void actionButton(JButton button,int num)
    {
        if(Board.contains(button.getText()))
        {
            label.setText("Invalid place");
        }
        else {
            button.setText(piece.getText());
            String pieces = "[";
            for (int i = 0; i < Pieces.size(); i++) {
                pieces += Pieces.get(i);
                if (i != Pieces.size() - 1) pieces += ",";
            }
            pieces += "]";
            String board = "[";
            for (int i = 0; i < Board.size(); i++) {
                board += Board.get(i);
                if (i != Board.size() - 1) board += ",";
            }
            board += "]";
            Pieces.remove(piece.getText());
            Board.set(num - 1,button.getText());
            if(checkWinner() || checkDraw())
            {
                if(checkDraw())
                    label.setText("Draw !!! ");
                else
                    label.setText("Player is the WINNER :D");

                JFrame frame = new JFrame("Quarto");
                frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
                frame.getContentPane().add(new Game());
                frame.pack();
                frame.setVisible(true);
                return;
            }
            Map<String, Term> terms = Query.oneSolution("continuePlay([0, play,"+board+ "]," + pieces + "," + piece.getText() + ","+num+",CompPiece,ComputerPosition)");

            int compPiece = Integer.valueOf(String.valueOf((terms.get("CompPiece"))));
            int compPosition = Integer.valueOf(String.valueOf((terms.get("ComputerPosition"))));
            Board.set(compPosition-1,Pieces.get(compPiece-1));
            addPieceToBoard(compPiece,compPosition);

            if(checkWinner() || checkDraw())
            {
                if(checkWinner())
                    label.setText("Computer is the WINNER :D");
                else
                    label.setText("Draw !!! ");

                JFrame frame = new JFrame("Quarto");
                frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
                frame.getContentPane().add(new Game());
                frame.pack();
                frame.setVisible(true);
                return;
            }
            Solver solver = new Solver();
            Term term = solver.PlayerGame(Board,Pieces);
            int ind = Integer.parseInt(term.toString());
            piece.setText(Pieces.get(ind-1));
        }

    }

    public void  addPieceToBoard(int compPiece, int compPosition)
    {
        String piece = Pieces.get(compPiece - 1);
        if(compPosition == 1)
            board1.setText(piece);
        else if(compPosition == 2)
            board2.setText(piece);
        else if(compPosition == 3)
            board3.setText(piece);
        else if(compPosition == 4)
            board4.setText(piece);
        else if(compPosition == 5)
            board5.setText(piece);
        else if(compPosition == 6)
            board6.setText(piece);
        else if(compPosition == 7)
            board7.setText(piece);
        else if(compPosition == 8)
            board8.setText(piece);
        else if(compPosition == 9)
            board9.setText(piece);

        Pieces.remove(compPiece - 1);
    }

    public boolean checkDraw()
    {
        boolean draw = false;

        if (Pieces.size() == 0)
            draw = true;

        return draw;
    }

    public boolean checkWinner()
    {
        boolean win = false;

        if(checkProperties(Board.get(0),Board.get(1),Board.get(2)))
            win = true;
        if(checkProperties(Board.get(3),Board.get(4),Board.get(5)))
            win = true;
        if(checkProperties(Board.get(6),Board.get(7),Board.get(8)))
            win = true;
        if(checkProperties(Board.get(0),Board.get(3),Board.get(6)))
            win = true;
        if(checkProperties(Board.get(1),Board.get(4),Board.get(7)))
            win = true;
        if(checkProperties(Board.get(2),Board.get(5),Board.get(8)))
            win = true;
        if(checkProperties(Board.get(0),Board.get(4),Board.get(8)))
            win = true;
        if(checkProperties(Board.get(2),Board.get(4),Board.get(6)))
            win = true;

        return win;
    }

    public boolean checkProperties(String s1,String s2,String s3)
    {
        boolean win = false;

        if(s1.contains("t") && s2.contains("t") &&  s3.contains("t"))
            win = true;
        if(s1.contains("r") && s2.contains("r") &&  s3.contains("r"))
            win = true;
        if(s1.contains("b") && s2.contains("b") && s3.contains("b"))
            win = true;
        if(s1.contains("s") && s2.contains("s") && s3.contains("s"))
            win = true;
        if(s1.contains("h")  && s2.contains("h") && s3.contains("h"))
            win = true;
        if(s1.contains("w") && s2.contains("w") &&  s3.contains("w"))
            win = true;

        return win;
    }
}
