# PowerForensicator
```
 _____                       ______                       _           _             
|  __ \                     |  ____|                     (_)         | |            
| |__) |____      _____ _ __| |__ ___  _ __ ___ _ __  ___ _  ___ __ _| |_ ___  _ __ 
|  ___/ _ \ \ /\ / / _ \ '__|  __/ _ \| '__/ _ \ '_ \/ __| |/ __/ _` | __/ _ \| '__|
| |  | (_) \ V  V /  __/ |  | | | (_) | | |  __/ | | \__ \ | (_| (_| | || (_) | |   
|_|   \___/ \_/\_/ \___|_|  |_|  \___/|_|  \___|_| |_|___/_|\___\__,_|\__\___/|_|   

```


### Usage

How to use the tool?

```
 powershell.exe -ExecutionPolicy Bypass -File .\PowerForensicator.ps1
```

### 1. Install python-telegram-bot library

```
pip install python-telegram-bot --upgrade

```
Or you can install from source with:

```
git clone https://github.com/python-telegram-bot/python-telegram-bot --recursive
cd python-telegram-bot
python setup.py install
```

### 2. Create your own bot
To create your own bot you should go to your Telegram App and talk to @BotFather. 

Use the /newbot command to create a new bot. The BotFather will ask you for a name and username, then generate an authorization token for your new bot.

The name of your bot is displayed in contact details and elsewhere.

The Username is a short name, to be used in mentions and t.me links. Usernames are 5-32 characters long and are case insensitive, but may only include Latin characters, numbers, and underscores. Your bot's username must end in 'bot', e.g. 'tetris_bot' or 'TetrisBot'.

The token is a string along the lines of 110201543:AAHdqTcvCH1vGWJxfSeofSAs0K5PALDsaw that is required to authorize the bot and send requests to the Bot API. Keep your token secure and store it safely, it can be used by anyone to control your bot.

P.S: If you want to change the bot's profile pictures use the command /setuserpic . It's always nice to put a face to a name.

You can find all the necessary information about its BotFather and Telegram API on this [page].(https://core.telegram.org/bots#6-botfather)

### 3. Get XDR API Token
Now, that you have your Telegram Bot Token, it is time to get your XDR token. Go to your XDR console → Account Management → Edit/Create Account → Copy the Authentication Code.

### 4. Start the bot
Edit the file main.py with your Telegram Bot Token.

```
def main():
    """Start the bot."""
    # Create the Updater and pass it your bot's token.
    updater = Updater("YOUR_TELEGRAM_BOT_TOKEN_HERE", use_context=True)
```
Also, you need to edit the file xdr.py with your XDR API Token.

```
token ="YOUR_XDR_API_TOKEN_HERE"
```
With this configuration, you can open your terminal/cmd, start your bot and interact :)

```
python main.py
```
### 5. Edit the Code
You can edit some bot commands with your specific timeframe or parameters. 

/workbench - Edit the queryParam variable with your desired date in xdr.py getWorkbench() function. Remember that the format must be ISO 8601 timestamp to the millisecond in UTC, yyyy-mm-ddThh:mm:ss.mmmZ. (The default code is showing workbench opened since 09/01/2020 with High or Medium Severity).

/cases - Edit the queryParam variable with your desired date in xdr.py countWorkbench() function. Remember that the format must be ISO 8601 timestamp to the millisecond in UTC, yyyy-mm-ddThh:mm:ss.mmmZ. (The default code is showing workbench opened since 09/01/2020 with High or Medium Severity).

/bdomain - The default command is setup to block the domain 0secops.com. If you want to change edit the parameter targetValue inside blockDomain() function in xdr.py file. You can also change it to a SHA1, IP, URL or Mailbox.

/rdomain - The default command is setup to block the domain 0secops.com. If you want to change edit the parameter targetValue inside removeDomain() function in xdr.py file. You can also change it to a SHA1, IP, URL or Mailbox.


