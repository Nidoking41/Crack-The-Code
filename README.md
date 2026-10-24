# Crack the Code

A casual phone game where you crack a secret number code, similar to Mastermind but with digits.

## How to play

Open `index.html` in any browser (it works on phones and computers, with no install needed).

- The computer picks a random secret code. Digits are 0 to 9, and a code can start with 0.
- You have **10 guesses** to crack it.
- Tap digits on the on-screen keypad. A highlight shows which space you're filling, and **Delete** removes the last digit. Tap **Enter** to submit.
- Every guess gets one light per digit. Lights fill in from the top left, greens first, then oranges, then off, so a light's position never tells you which digit it belongs to:
  - **Green:** right digit in the right spot
  - **Orange:** right digit in the wrong spot
  - **Off:** digit is not in the code
- Your past guesses and their lights stay on the board so you can look back at them.
- Tap **Cross out**, then a digit, to mark it with a big red X as a reminder that it's not in the code. Do the same on a crossed digit to clear it.
- You win when every light is green. If your 10th guess misses, the code is revealed.

Each digit in the code can light up only one lamp. For example, if the code is `1123` and you guess `1111`, you get 2 green and 2 off.

## Modes

| Mode | Code length | Repeated digits | Guesses |
| --- | --- | --- | --- |
| Easy | 4 digits | Not allowed | 10 |
| Hard | 4, 5 or 6 digits | Allowed | 10 |

## Timer and stats

A timer starts when you tap your first digit and stops when the game ends. The **Stats** button shows each mode's stats separately:

- Games played and win percentage
- Current streak and best streak
- Codes cracked and failed
- Fastest and average crack time (counting only wins)
- How many codes you cracked in 1 to 10 guesses

Stats are saved in your browser on your device.

## Settings

The **Settings** button lets you pick a color scheme: Auto (matches your device's light or dark mode), Steel, Night, Ocean, Forest, Sunset, Neon or Paper. Your choice is saved on your device.

## Playing it online

To get a link you can open on your phone, turn on GitHub Pages: in this repository go to **Settings → Pages**, set the source to **Deploy from a branch**, choose `main` and `/ (root)`, and save. After a minute or so, the game appears at `https://nidoking41.github.io/Crack-The-Code/`.
