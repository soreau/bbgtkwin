import os
import sys
import platform

def print_versions(exit_on_error=False):
    print(f"Machine: {platform.machine()}")
    print(f"Python version: {sys.version}")
    print(f"Python bitness: {platform.architecture()[0]}")
    print(f"Python compiler: {platform.python_compiler()}")

    try:
        import gi
    except ImportError as e:
        print(f"PyGObject not available: {e}")
        if exit_on_error:
            sys.exit(1)
        return
    print(f"PyGObject version: {gi.__version__}")

    try:
        gi.require_version('Gtk', '3.0')
        from gi.repository import Gtk
    except ImportError as e:
        print(f"GTK not available: {e}")
        import ctypes
        print("Last Windows error:", ctypes.get_last_error())
        if exit_on_error:
            sys.exit(1)
    else:
        print(f"Gtk version: {Gtk.get_major_version()}.{Gtk.get_minor_version()}.{Gtk.get_micro_version()}")

if __name__ == "__main__":
    print("Environment PATH:")
    print(os.environ['PATH'].split(os.pathsep))
    print("\nPython DLL search path:")
    print(sys.path)
    exit_on_error = "--required" in sys.argv
    print_versions(exit_on_error)
