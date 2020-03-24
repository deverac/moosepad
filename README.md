__Moosepad__ is [Mousepad](https://git.xfce.org/apps/mousepad/) with a patch which alters some behaviors.

Mousepad is a wonderful program - small and speedy. So far, it has avoided the feature bloat that so many other text editors succumb to. There are some things I wished Mousepad did differently, hence the patch. The patch makes the following changes:

* In the preview encoding dialog, Mousepad does not wrap the displayed text; __Moosepad__ does wrap the displayed text.

* When the preview encoding dialog is cancelled, Mousepad will open with an empty window; __Moosepad__ will not open.

* __Moosepad__ adds a `Lossy ISO-8859-1` encoding. The Lossy encoding converts all NULLs to spaces. This allows any file to be previewed, even corrupted text documents. (If, and only if, the Lossy encoding modifies the document data, a warning is displayed in the preview window.) Mousepad will only load 'well-formed' text documents. 

* In the preview encoding dialog, Mousepad auto-selects the `System` encoding. (This is not useful if your System encoding is set to UTF-8 because Mousepad already tried, and failed, to load the file as a UTF-8 document.) __Moosepad__ will auto-select the `Other` encoding which previews the document using the 'Lossy' encoding.

* __Moosepad__ uses a different icon than Mousepad.

* __Moosepad__ is a patched version of Mousepad, but has been altered enough so that both programs can exist and be run on the same system. However, both programs share things like Settings, Recent documents, etc.

* In __Moosepad__, the text in the `About` dialog has been modified.

Running `make-moosepad.sh` will extract the Mousepad source, apply the patch, compile the program, and build a `.deb` package. Additional packages may need to be installed in order for the script to succeed.

To install moosepad, run `dpkg -i moosepad.deb`

To remove moosepad, run `dpkg -r moosepad` (or `apt-get remove moosepad`).

If installing via 'su' and PATH errors are reported, use 'su -', instead.

BUGS:

There are no translations for added English text.
