import sys
import platform

def print_versions():
    print(f"Machine: {platform.machine()}")
    print(f"Python version: {sys.version}")
    print(f"Python bitness: {platform.architecture()[0]}")
    print(f"Python compiler: {platform.python_compiler()}")

    try:
        import gi
        gi.require_version('Gtk', '3.0')
        from gi.repository import Gtk
        print(f"Gtk version: {Gtk.get_major_version()}.{Gtk.get_minor_version()}.{Gtk.get_micro_version()}")
        print(f"PyGObject version: {gi.__version__}")
    except (ImportError, ValueError) as e:
        print("GTK/PyGObject not available")

if __name__ == "__main__":
    print_versions()
