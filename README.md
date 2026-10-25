# Defuse the Bomb

A casual phone game where you defuse a bomb by cracking its secret number code, similar to Mastermind but with digits.

The game opens on a title screen with **Quick Play**, **Campaign**, **How to Play** and **Stats**.

## How to play

Open `index.html` in any browser (it works on phones and computers, with no install needed).

- The computer picks a random secret code. Digits are 0 to 9, and a code can start with 0.
- You have **10 guesses** to crack it. Codes never repeat a digit.
- Tap digits on the on-screen keypad. A highlight shows which space you're filling, and **Delete** removes the last digit. Tap **Enter** to submit.
- Every guess gets one light per digit. Lights fill in from the top left, greens first, then oranges, then off, so a light's position never tells you which digit it belongs to:
  - **Green:** right digit in the right spot
  - **Orange:** right digit in the wrong spot
  - **Off:** digit is not in the code
- Your past guesses and their lights stay on the board so you can look back at them.
- Tap **Cross out** to turn on cross-out mode, then tap digits to mark them with a big red X as a reminder that they're not in the code. Tap a crossed digit to clear it, and tap **Cross out** again to go back to typing.
- You win when every light is green. If your 10th guess misses, the code is revealed.

## Levels

Codes never repeat a digit. Every level gives you 10 guesses.

| Level | Code length |
| --- | --- |
| Easy | 3 digits |
| Medium (default) | 4 digits |
| Hard | 5 digits |
| Expert | 6 digits |

The lights form a shape with one light per digit: a triangle on Easy, a square on Medium, a pentagon on Hard and a hexagon on Expert. On the square they fill in reading order; on the other shapes they start at the top and go clockwise.

After your first guess, the other levels are hidden until the game ends, so a stray tap can't quit your game.

## Quick Play and Campaign

- **Quick Play:** one bomb, 10 guesses, no countdown. The clock records how long you took.
- **Campaign:** defuse bomb after bomb at the level you pick. Level 1 gives you 5:00, and each level after that has 15 seconds less (never under 30 seconds, which is reached at level 19). Under one minute the bomb flashes and pulses. Running out of time or guesses ends the campaign.
- **Concede:** tap Concede twice to give up and return to the title screen. It counts as a loss.

## Stats

Stats are split by Quick Play and Campaign, and by level, and saved in your browser:

- Quick Play: games played, win %, current and best streak, bombs defused and exploded, average guesses, fastest and average defuse time, and a guess breakdown.
- Campaign: highest level cleared, runs, bombs defused, runs ended, average guesses, fastest and average defuse time, and a guess breakdown.

## Settings

The **Settings** button lets you pick a color scheme: Auto (matches your device's light or dark mode), Steel, Night, Ocean, Forest, Sunset, Neon or Paper. Your choice is saved on your device.

## Playing it online

To get a link you can open on your phone, turn on GitHub Pages: in this repository go to **Settings → Pages**, set the source to **Deploy from a branch**, choose `main` and `/ (root)`, and save. After a minute or so, the game appears at `https://nidoking41.github.io/Crack-The-Code/`.
