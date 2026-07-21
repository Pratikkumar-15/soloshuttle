import re

def patch_file():
    with open('lib/presentation/screens/tutorials_screen.dart', 'r', encoding='utf-8') as f:
        content = f.read()

    # Replace all empty video URLs with a generic valid youtube link
    content = content.replace(
        "videoUrl: '',",
        "videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',"
    )
    
    with open('lib/presentation/screens/tutorials_screen.dart', 'w', encoding='utf-8') as f:
        f.write(content)

    print("Patched tutorials_screen.dart")

if __name__ == '__main__':
    patch_file()
