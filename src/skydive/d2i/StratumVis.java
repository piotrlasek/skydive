package skydive.d2i;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class StratumVis extends JDialog {
    private JPanel contentPane;
    private JButton buttonOK;
    private JButton buttonCancel;

    Stratum stratum;

    public StratumVis(Stratum s) {
        stratum = s;
        setContentPane(contentPane);
        setModal(true);
        getRootPane().setDefaultButton(buttonOK);

        buttonOK.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                onOK();
            }
        });

        buttonCancel.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                onCancel();
            }
        });

// call onCancel() when cross is clicked
        setDefaultCloseOperation(DO_NOTHING_ON_CLOSE);
        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                onCancel();
            }
        });

// call onCancel() on ESCAPE
        contentPane.registerKeyboardAction(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                onCancel();
            }
        }, KeyStroke.getKeyStroke(KeyEvent.VK_ESCAPE, 0), JComponent.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT);

        this.setSize(600, 400);
    }

    @Override
    public void paint(Graphics graphics) {
        super.paint(graphics);
        // add your code here
        Graphics g = contentPane.getGraphics();
        //contentPane.getGraphics().drawLine(0, 0, 100, 100);
        int size = stratum.getSize();

        for (int w = 0; w < size; w++) {
            for (int h = 0; h < size; h++) {
                Aggregate a = stratum.getAggregate(w, h);
                int x = w * 10;
                int y = h * 10;
                //System.out.println(a.getValue());
                Color c = Color.getHSBColor((float) a.getValues().get(0) / 10, 1f, 1f);
                g.setColor(c);
                g.fillRect(x, y, 10, 10);
            }
        }
    }

    /**
     *
     */
    private void onOK() {
    }


    private void onCancel() {
// add your code here if necessary
        dispose();
    }

}
