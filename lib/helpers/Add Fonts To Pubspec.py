import os

# Function to add fonts to the pubspec.yaml file
def add_fonts_to_pubspec(font_folder):
    # Check if pubspec.yaml exists in the current directory
    if not os.path.exists('pubspec.yaml'):
        print("Error: 'pubspec.yaml' not found in the current directory.")
        return
    
    # Check if the font folder exists
    if not os.path.exists(font_folder):
        print(f"Error: The folder '{font_folder}' does not exist.")
        return
    
    # Get all font files in the folder
    font_files = [f for f in os.listdir(font_folder) if f.endswith('.ttf') or f.endswith('.otf')]
    font_files.sort()
    print(font_files)
    # Read the existing content of pubspec.yaml
    with open('pubspec.yaml', 'r') as file:
        content = file.readlines()
    
    # Locate the position of the 'fonts:' section or add it if it doesn't exist
    fonts_index = next((i for i, line in enumerate(content) if 'fonts:' in line), None)
    if fonts_index is None:
        content.append('flutter:\n')
        content.append('  fonts:\n')
        fonts_index = len(content) - 1
    else:
        fonts_index += 1  # Start adding after 'fonts:'
    
    # Add font files to the pubspec.yaml content
    for font_file in font_files:
        content.insert(fonts_index, f"    - family: QP{os.path.splitext(os.path.basename(font_file))[0]}\n")
        content.insert(fonts_index + 1, f"      fonts:\n")
        content.insert(fonts_index + 2, f"        - asset: assets/fonts/quran_fonts/{font_file}\n")
    
    # Write the updated content back to pubspec.yaml
    with open('pubspec.yaml', 'w') as file:
        file.writelines(content)
    print(f"Fonts from '{font_folder}' added to 'pubspec.yaml' successfully.")

# Main script to get user input and call the function
if __name__ == "__main__":
    # Get user input for the font folder path
    font_folder = input("Enter the path to the folder containing the font files: ")
    
    # Call the function to add fonts to pubspec.yaml
    add_fonts_to_pubspec(font_folder)