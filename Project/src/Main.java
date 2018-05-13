import javax.swing.*;


public class Main {

    public static void main(String[] args) {

        JFrame frame = new JFrame("Quarto");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.getContentPane().add(new Game());
        frame.pack();
        frame.setVisible(true);
    }
}
