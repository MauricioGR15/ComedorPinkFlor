package components;

import javax.swing.*;
import java.awt.*;

public class Tabs {
    public JPanel panelTabs;
    public JTabbedPane tabbedPane;

    public Tabs(JPanel formTut, JPanel modTut, JPanel formAlu, JPanel tablaVistas, JPanel formAlergias) {
        tabbedPane.addTab("Tutores", formTut);
        tabbedPane.addTab("Modificar Tutor", modTut);
        tabbedPane.add("Alumnos", formAlu);
        tabbedPane.add("Consultas", tablaVistas);
        tabbedPane.add("Bajas Alergias", formAlergias);
        panelTabs.add(tabbedPane);
    }

    {
// GUI initializer generated by IntelliJ IDEA GUI Designer
// >>> IMPORTANT!! <<<
// DO NOT EDIT OR ADD ANY CODE HERE!
        $$$setupUI$$$();
    }

    /**
     * Method generated by IntelliJ IDEA GUI Designer
     * >>> IMPORTANT!! <<<
     * DO NOT edit this method OR call it in your code!
     *
     * @noinspection ALL
     */
    private void $$$setupUI$$$() {
        panelTabs = new JPanel();
        panelTabs.setLayout(new BorderLayout(0, 0));
        tabbedPane = new JTabbedPane();
        panelTabs.add(tabbedPane, BorderLayout.CENTER);
    }

    /**
     * @noinspection ALL
     */
    public JComponent $$$getRootComponent$$$() {
        return panelTabs;
    }

}
