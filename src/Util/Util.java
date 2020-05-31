package Util;

import javax.swing.*;
import java.awt.*;
import java.awt.event.KeyEvent;

public class Util {

    public static void soundAlert(KeyEvent evt, JTextField aux, int size){
        if(aux.getText().length() >= size){
            evt.consume();
            Toolkit.getDefaultToolkit().beep();
        }
    }

    public static void onlyNumbers(KeyEvent evt, JTextField aux){
        if(!Character.isDigit(evt.getKeyChar()))
            evt.consume();
    }
}
