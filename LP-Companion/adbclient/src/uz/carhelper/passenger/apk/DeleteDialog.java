package uz.carhelper.passenger.apk;

import android.app.Activity;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import java.io.File;

import uz.carhelper.passenger.Ui;

import static uz.carhelper.passenger.apk.Cards.T;

/** The warning before an app file (.apk or bundle) is deleted from the storage. Only files in the allowed places. */
final class DeleteDialog {
    private DeleteDialog() {
    }

    static void show(final Activity a, final Roots.Root root, final File file, final Runnable afterwards) {
        final Cards.Card c = new Cards.Card(a, Cards.width(a, 860));
        c.title(T("Delete this file?"));
        c.line(file.getName(), 0xffffffff, 22f, 0);
        c.line(Cards.size(file.length()), Ui.TEXT3, 18f, 4);
        c.line(T("The file is removed from the storage. This cannot be undone."), Ui.BAD, 20f, 12);
        TextView no = Cards.grey(a, T("Cancel"), new View.OnClickListener() {
            public void onClick(View v) {
                c.dismiss();
            }
        });
        TextView yes = Cards.red(a, T("Delete"), new View.OnClickListener() {
            public void onClick(View v) {
                c.dismiss();
                String n = file.getName().toLowerCase();
                boolean kind = n.endsWith(".apk") || n.endsWith(".xapk") || n.endsWith(".apks") || n.endsWith(".apkm");
                boolean ok = kind && file.isFile() && Roots.allowed(root, file) && file.delete();
                Toast.makeText(a.getApplicationContext(), ok ? T("File deleted") : T("Could not delete the file"), Toast.LENGTH_LONG).show();
                if (afterwards != null) {
                    afterwards.run();
                }
            }
        });
        c.box.addView(Cards.buttons(a, no, yes));
        c.show();
    }
}
