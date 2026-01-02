import os
import sys
from pathlib import Path

# Try to import TOML libraries
try:
    import tomli
    import tomli_w
except ImportError:
    print("Error: Required TOML libraries not found.")
    print("Please install them using one of these commands:")
    print("  sudo pacman -S python-tomli python-tomli-w  # Arch Linux")
    print("  sudo apt install python3-tomli python3-tomli-w  # Debian/Ubuntu")
    print("  pip3 install --user tomli tomli-w  # Using pip")
    sys.exit(1)

def merge_toml(base_dict, overwrite_dict):
    """Recursively merge overwrite_dict into base_dict, replacing values."""
    result = base_dict.copy()
    
    for key, value in overwrite_dict.items():
        if key in result and isinstance(result[key], dict) and isinstance(value, dict):
            # Recursively merge nested dictionaries
            result[key] = merge_toml(result[key], value)
        else:
            # Replace value (handles primitives, lists, and new keys)
            result[key] = value
    
    return result

def merge_toml_files(src_path, dest_path):
    """Merge TOML files, replacing keys from src into dest."""
    src_path = Path(src_path).expanduser()
    dest_path = Path(dest_path).expanduser()
    
    if not src_path.exists():
        print(f"Source file not found: {src_path}")
        return False
    
    # Create destination directory if needed
    dest_path.parent.mkdir(parents=True, exist_ok=True)
    
    # Read source file
    with open(src_path, "rb") as f:
        overwrite_data = tomli.load(f)
    
    # If destination doesn't exist, just copy source
    if not dest_path.exists():
        with open(dest_path, "wb") as f:
            tomli_w.dump(overwrite_data, f)
        print(f"Created: {dest_path}")
        return True
    
    # Read destination file
    with open(dest_path, "rb") as f:
        dest_data = tomli.load(f)
    
    # Merge the files
    merged_data = merge_toml(dest_data, overwrite_data)
    
    # Write back to destination
    with open(dest_path, "wb") as f:
        tomli_w.dump(merged_data, f)
    
    print(f"Merged: {dest_path}")
    return True

def main():
    script_dir = Path(__file__).parent.resolve()
    
    # Define file pairs
    files = [
        (script_dir / "overwrite-alacritty.toml", 
         Path.home() / ".config/alacritty/alacritty.toml"),
        (script_dir / "overwrite-walker.toml", 
         Path.home() / ".config/walker/config.toml"),
        (script_dir / "overwrite-elephant-search.toml", 
         Path.home() / ".config/elephant/websearch.toml"),
    ]
    
    # Process each file pair
    for src, dest in files:
        merge_toml_files(src, dest)
    
    print("Done.")

if __name__ == "__main__":
    main()
