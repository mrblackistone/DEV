using System;
using System.Drawing;
using System.Windows.Forms;

namespace csDrawing1 {
    class Program {
        static void Main (string[] args) {
            Form f = new Form ();
            f.BackColor = Color.White;
            f.FormBorderStyle = FormBorderStyle.None;
            f.Bounds = Screen.PrimaryScreen.Bounds;
            f.TopMost = true;

            Application.EnableVisualStyles ();
            Application.Run (f);
        }
    }
}