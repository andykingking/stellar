# Stellar

A convenient way to get a relevant background for your desktop.

## Installation

  1. Clone the repository:

    ```bash
    git clone git@github.com:andykingking/stellar.git
    cd stellar
    ```

  2. Install dependencies:

    ```bash
    mix deps.get
    ```

  3. Build the application:

    ```bash
    mix escript.build
    ```

  4. Run the application:

    ```bash
    # <filename> is the name of the output file.
    ./stellar <filename>
    ```

## Options

```bash
# Uses the given URL as the background image.
./stellar -b <url> <filename>

# Uses the given logo location.
# Valid locations:
#   - North
#   - NorthEast
#   - NorthWest
#   - West
#   - Center
#   - East
#   - South
#   - SouthEast
#   - SouthWest
./stellar -l <location> <filename>

# Add verbosity level to output.
./stellar -v <filename>

# Debug level verbosity.
./stellar -v -v -v <filename>
```
