import org.jpl7.Term;
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;

public class Game extends JPanel implements ActionListener {
    JTextField jTextField = new JTextField();
    JButton jButton = new JButton("Start Game");
    JLabel label = new JLabel("WELCOME");           //  Who play first?
    JLabel label2 = new JLabel("TO");              //  // 1 for Computer
    JLabel label3 = new JLabel("QUARTO"); //  // 0 for Player

    Game()
    {
        setPreferredSize(new Dimension(400,400));
        setLayout(null);
        label.setBounds(20,120,100,25);
        label2.setBounds(30,140,100,25);
        label3.setBounds(30,160,100,25);
        jTextField.setBounds(20,180,250,25);
        jButton.setBounds(20,235,300,25);
        add(label);
        add(label2);
        add(label3);
       // add(jTextField);
        add(jButton);
        jButton.addActionListener(this);
    }
    @Override
    public void actionPerformed(ActionEvent e) {

        if (e.getSource() == jButton) {
            Solver solver = new Solver();
            Term term = solver.startGame("0");  //jTextField.getText()

            JFrame frame = new JFrame("Quarto");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.getContentPane().add(new Board(term.toString()));
            frame.pack();
            frame.setVisible(true);
        }

    }
}
