# Putting Defuse the Bomb on the App Store and Google Play

Everything that can be built is already in this repository: the iPhone and Android app projects, the icon, the splash screen, the privacy policy, the store screenshots and the store text. What's left are the steps only you can do, because they need your accounts and your payment details.

You don't need a Mac. A service called **Codemagic** builds the iPhone app on its own Macs for you, and it's free for a small project like this (500 build minutes a month; one build takes about 10 minutes).

Do the parts in order. Parts 1 and 2 can be started on the same day, because both accounts take a few days to be approved.

---

## Part 1: Sign up for the developer accounts

### Apple ($99 a year)

1. On your iPhone, install the **Apple Developer** app from the App Store.
2. Open it, sign in with your Apple ID, and tap **Account → Enroll Now**. Enroll as an **Individual**.
3. Pay the $99. Approval usually takes from a few hours to two days. You'll get an email.

### Google Play ($25 once)

1. Go to <https://play.google.com/console/signup> and sign in with a Google account.
2. Choose **Yourself** (a personal account), pay the $25, and verify your identity (they ask for a photo ID).
3. Approval can take a few days.

> **Important for Google:** new personal accounts must run a **closed test with at least 12 testers for 14 days in a row** before the app can go public. Start lining up 12 friends or family members with Android phones now. They just need to tap a link and install the app; they don't have to play every day.

---

## Part 2: Turn on the privacy policy page

The stores need a privacy policy link. It's already written (`privacy.html`); GitHub Pages just has to be on.

1. Open the repository on GitHub, go to **Settings → Pages**.
2. Under **Source** choose **Deploy from a branch**, pick `main` and `/ (root)`, and click **Save**.
3. After a minute, check that <https://nidoking41.github.io/Crack-The-Code/privacy.html> opens.

---

## Part 3: Set up Codemagic

1. Go to <https://codemagic.io/signup> and sign up **with GitHub**.
2. Click **Add application**, choose GitHub, and pick the **Crack-The-Code** repository. When it asks for the project type, choose **Ionic Capacitor App** (or "Other"); it will find `codemagic.yaml` on its own.

### Add the Android upload key

The key that proves Android updates come from you is already made. It's in the project's Library, in the `app-signing` folder, together with a note that has its passwords. **Keep both files private and don't put them on GitHub.**

1. In Codemagic, open **Settings** (your user or team settings) **→ Code signing identities → Android keystores**.
2. Upload `defuse-upload.keystore`, type the password and alias from the note, and set the **Reference name** to `defuse_upload_key`.

### Connect your Apple account (after Apple approves you)

1. Go to <https://appstoreconnect.apple.com> → **Users and Access → Integrations → App Store Connect API**. Request access if asked, then click **+** to make a key. Name it "Codemagic" and give it the **App Manager** role.
2. Download the key file (`.p8`). Apple only lets you download it once, so save it. Note the **Issuer ID** and **Key ID** shown on the page.
3. In Codemagic, open **Settings → Integrations → Developer Portal → Connect**. Name the key exactly `Defuse the Bomb`, then paste the Issuer ID and Key ID and upload the `.p8` file.

---

## Part 4: Create the app in each store

### Apple

1. In App Store Connect go to **Apps → + → New App**.
2. Platform **iOS**, name **Defuse the Bomb**, language **English (U.S.)**.
3. For **Bundle ID**: if `com.nidoking41.defusethebomb` isn't in the list, open <https://developer.apple.com/account/resources/identifiers/list>, click **+**, pick **App IDs → App**, enter that exact ID with any description, save, and come back.
4. **SKU** can be anything, for example `defusethebomb`. Click **Create**.

### Google

1. In the Play Console click **Create app**.
2. Name **Defuse the Bomb**, language English, **Game**, **Free**, tick the declarations, and click **Create app**.

---

## Part 5: Build the apps

In Codemagic, open the app and click **Start new build**. Pick the `main` branch and one workflow:

- **iPhone app → TestFlight**: builds the iPhone app and sends it straight to App Store Connect. After about 15 minutes more of processing on Apple's side, it shows up in **TestFlight**.
- **Android app bundle**: builds the Android file. When it finishes, download the `.aab` file from the build page.

### Try the iPhone app on your own phone

1. Install the **TestFlight** app from the App Store on your iPhone.
2. In App Store Connect, open the app → **TestFlight → Internal Testing**, click **+**, make a group, and add yourself.
3. Open TestFlight on your iPhone and install Defuse the Bomb.

---

## Part 6: Fill in the store listings

All the text and pictures are ready in [`store/listing.md`](store/listing.md) and the `store/` folder. Copy and paste them in.

- **Apple:** in App Store Connect fill in the app's page, App Privacy ("Data Not Collected"), age rating, price (Free) and the iPhone screenshots. Under **Build**, choose the build Codemagic uploaded.
- **Google:** fill in **Main store listing**, then everything under **Policy → App content** (privacy policy, ads, content rating, target audience, data safety).

---

## Part 7: Send it in

### Apple

Click **Add for Review**, then **Submit**. Review usually takes one to three days. If Apple asks a question, paste it into the project chat and I'll help you answer.

### Google

1. Go to **Testing → Closed testing**, create a track, and upload the `.aab` file you downloaded from Codemagic.
2. Add your 12+ testers' Gmail addresses and send them the opt-in link.
3. After 14 days, the Play Console unlocks **Apply for production**. Answer its short questions about the test, and Google reviews the app (a few days).

---

## Releasing an update later

1. Change the game in `index.html` as usual.
2. Run both Codemagic workflows again. They give each build a new number automatically.
3. Apple: pick the new build on a new version page and submit. Google: upload the new `.aab` to a release and roll it out.

## For anyone working on the code

- `index.html` is still the game. `npm run build` copies it into `www/` with the fonts bundled so the app works offline, and `npm run sync` also updates the `ios/` and `android/` projects.
- `npm run assets` regenerates the icons and splash screens from `assets/`.
- The app ID on both stores is `com.nidoking41.defusethebomb`. It can't change after the first upload.
- The app is iPhone only and portrait only, which keeps the screenshots and review simple. iPads can still run it in iPhone mode.
- `.github/workflows/app-build.yml` checks that both apps still build on every change.
