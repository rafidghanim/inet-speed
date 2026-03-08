# inet.sh - Limit Internet Speed on Linux Wi-Fi

**inet.sh** is a simple script to limit internet speed on Linux, specifically for Wi-Fi interfaces (`wlp2s0`) using `tc`. With this script, you can:

* Limit download and upload speeds.
* Change limits anytime.
* Easily remove the limits.

---

## 📦 Installation

1. Save the script to `/bin/inet.sh`:

```bash
sudo nano /bin/inet.sh
# Paste the inet.sh script
sudo chmod +x /bin/inet.sh
```

2. Make sure your Wi-Fi interface is named `wlp2s0`.
   Check with:

```bash
ip a
```

If your interface has a different name, edit the `INTERFACE` variable in `/bin/inet.sh`:

```bash
INTERFACE="your_wifi_interface_name"
```

---

## ⚡ Usage

### 1. Set a Limit

Example: limit download to 1024 kbit/s and upload to 512 kbit/s:

```bash
sudo inet.sh set 1024 512
```

### 2. Change an Existing Limit

Example: change the limit to download 512 kbit/s and upload 256 kbit/s:

```bash
sudo inet.sh change 512 256
```

### 3. Remove Limit

```bash
sudo inet.sh clear
```

---

## 🔍 Check Status

To verify the limit is active, run:

```bash
tc -s qdisc ls dev wlp2s0
```

Look at `overlimits` and `Sent` fields to see traffic being limited.

---

## ⚙️ Tips

* This script limits **all traffic** on the Wi-Fi interface (`wlp2s0`). Every application using Wi-Fi—including Brave, Firefox, or terminal downloaders—will be affected.
* If you want to limit a single application only, you can use tools like `trickle` (if available) or `firejail` (more complex setup).
* This script is ready to use: just run `sudo inet.sh [set|change|clear] [DOWNLOAD] [UPLOAD]`.

---

## 📝 License

MIT License

---

## 💡 Example Workflow

1. **Set limit for browsing:**

```bash
sudo inet.sh set 1024 512
```

2. **Change limit while downloading:**

```bash
sudo inet.sh change 512 256
```

3. **Remove limit when done:**

```bash
sudo inet.sh clear
```

---

## ⚡ Notes

* **DOWNLOAD** and **UPLOAD** are in **kbit/s**.
* Script works on Fedora, Ubuntu, and other Linux distributions with `tc` available.
* To make it easier, you can create a shell alias in your `.bashrc` or `.zshrc`:

```bash
alias inet='sudo /bin/inet.sh'
```

Then you can run:

```bash
inet set 1024 512
```

without typing `sudo` every time.
