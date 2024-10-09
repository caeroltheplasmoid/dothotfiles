import os
import subprocess
from blessed import Terminal

def list_epub_files(directory):
    return [f for f in os.listdir(directory) if f.endswith('.epub')]

def open_epub(file):
    subprocess.run(['epy', file])

def main():
    term = Terminal()
    directory = 'Documents/Books/'  # Adjust the directory as per your setup

    files = list_epub_files(directory)

    with term.fullscreen(), term.cbreak():
        key = ''
        index = 0

        while key.lower() != 'q':
            output = term.clear() + term.center(term.bold('Epub Library')) + '\n\n'

            for i, file in enumerate(files):
                if i == index:
                    output += term.reverse(f'{i+1}. {file}\n')
                else:
                    output += f'{i+1}. {file}\n'

            print(output)

            with term.cbreak():
                key = term.inkey()

            if key.name == 'KEY_DOWN':
                index = min(index + 1, len(files) - 1)
            elif key.name == 'KEY_UP':
                index = max(index - 1, 0)
            elif key == '\n':
                open_epub(os.path.join(directory, files[index]))

if __name__ == "__main__":
    main()

