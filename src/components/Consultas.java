package components;

import javax.swing.*;
import java.awt.*;

public class Consultas {
    public JRadioButton rb_caducar;
    public JRadioButton rb_inventario;
    public JRadioButton rb_usados;
    public JPanel Consultas;
    public JTable tablaVistas;
    public JRadioButton rb_alergicos;

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
        Consultas = new JPanel();
        Consultas.setLayout(new GridBagLayout());
        rb_caducar = new JRadioButton();
        Font rb_caducarFont = this.$$$getFont$$$("Arial Rounded MT Bold", -1, -1, rb_caducar.getFont());
        if (rb_caducarFont != null) rb_caducar.setFont(rb_caducarFont);
        rb_caducar.setText("Cerca de caducar");
        GridBagConstraints gbc;
        gbc = new GridBagConstraints();
        gbc.gridx = 0;
        gbc.gridy = 0;
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.ipadx = 10;
        gbc.ipady = 4;
        gbc.insets = new Insets(5, 5, 5, 5);
        Consultas.add(rb_caducar, gbc);
        rb_inventario = new JRadioButton();
        Font rb_inventarioFont = this.$$$getFont$$$("Arial Rounded MT Bold", -1, -1, rb_inventario.getFont());
        if (rb_inventarioFont != null) rb_inventario.setFont(rb_inventarioFont);
        rb_inventario.setSelected(true);
        rb_inventario.setText("Inventario");
        gbc = new GridBagConstraints();
        gbc.gridx = 1;
        gbc.gridy = 0;
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.ipadx = 10;
        gbc.ipady = 4;
        gbc.insets = new Insets(5, 5, 5, 5);
        Consultas.add(rb_inventario, gbc);
        rb_usados = new JRadioButton();
        Font rb_usadosFont = this.$$$getFont$$$("Arial Rounded MT Bold", -1, -1, rb_usados.getFont());
        if (rb_usadosFont != null) rb_usados.setFont(rb_usadosFont);
        rb_usados.setText("Ingredientes más usados");
        gbc = new GridBagConstraints();
        gbc.gridx = 2;
        gbc.gridy = 0;
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.ipadx = 10;
        gbc.ipady = 4;
        gbc.insets = new Insets(5, 5, 5, 5);
        Consultas.add(rb_usados, gbc);
        final JScrollPane scrollPane1 = new JScrollPane();
        Font scrollPane1Font = this.$$$getFont$$$("Arial Rounded MT Bold", -1, -1, scrollPane1.getFont());
        if (scrollPane1Font != null) scrollPane1.setFont(scrollPane1Font);
        scrollPane1.setPreferredSize(new Dimension(600, 350));
        gbc = new GridBagConstraints();
        gbc.gridx = 0;
        gbc.gridy = 1;
        gbc.gridwidth = 4;
        gbc.fill = GridBagConstraints.BOTH;
        Consultas.add(scrollPane1, gbc);
        tablaVistas = new JTable();
        tablaVistas.setPreferredSize(new Dimension(400, 400));
        scrollPane1.setViewportView(tablaVistas);
        rb_alergicos = new JRadioButton();
        Font rb_alergicosFont = this.$$$getFont$$$("Arial Rounded MT Bold", -1, -1, rb_alergicos.getFont());
        if (rb_alergicosFont != null) rb_alergicos.setFont(rb_alergicosFont);
        rb_alergicos.setSelected(false);
        rb_alergicos.setText("Niños alérgicos");
        gbc = new GridBagConstraints();
        gbc.gridx = 3;
        gbc.gridy = 0;
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.ipadx = 10;
        gbc.ipady = 4;
        gbc.insets = new Insets(5, 5, 5, 5);
        Consultas.add(rb_alergicos, gbc);
        ButtonGroup buttonGroup;
        buttonGroup = new ButtonGroup();
        buttonGroup.add(rb_caducar);
        buttonGroup.add(rb_caducar);
        buttonGroup.add(rb_inventario);
        buttonGroup.add(rb_usados);
        buttonGroup.add(rb_alergicos);
    }

    /**
     * @noinspection ALL
     */
    private Font $$$getFont$$$(String fontName, int style, int size, Font currentFont) {
        if (currentFont == null) return null;
        String resultName;
        if (fontName == null) {
            resultName = currentFont.getName();
        } else {
            Font testFont = new Font(fontName, Font.PLAIN, 10);
            if (testFont.canDisplay('a') && testFont.canDisplay('1')) {
                resultName = fontName;
            } else {
                resultName = currentFont.getName();
            }
        }
        return new Font(resultName, style >= 0 ? style : currentFont.getStyle(), size >= 0 ? size : currentFont.getSize());
    }

    /**
     * @noinspection ALL
     */
    public JComponent $$$getRootComponent$$$() {
        return Consultas;
    }

}